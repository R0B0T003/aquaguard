


//Mosquitto MQTT Broker with ESP32

#include <WiFi.h>
#include <PubSubClient.h>

#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

#define DHTPIN 13     // Digital pin connected to the DHT sensor 
#define DHTTYPE    DHT22     // DHT 22 (AM2302)
#define RELAIS 23

#define VEGETABLE_THRESHOLD 76
#define MAIZE_THRESHOLD     43
#define BEANS_THRESHOLD     50
#define OKRA_THRESHOLD      59

//WiFi Credentials
const char* ssid = "robot";
const char* password = "password";

//MQTT Broker details
const char* mqtt_server = "192.168.103.49";
const int mqtt_port = 1883;
const char* mqtt_topic = "device";
const char* d_mqtt_topic = "device/parameters/distance";
const char* m_mqtt_topic = "device/parameters/moisture";
const char* h_mqtt_topic = "device/parameters/humidity";
const char* t_mqtt_topic = "device/parameters/temperature";
const char* w_mqtt_topic = "device/parameters/wetness";
const char* p_mqtt_topic = "device/parameters/pumpStatus";
const char* history_mqtt_topic = "device/parameters/history";
const char* config_mqqt_topic = "device/config/crop_type";
String cropType = "";


//WiFiClient = Makes the actual internet connection.
//PubSubClient = Talks MQTT protocol over that connection.

WiFiClient espClient;
PubSubClient client(espClient);

float prevMoisture = -1;
float prevTemperature = -1;
float prevHumidity = -1;
float prevWet = -1;
float prevDistanceCm = -1;
bool prevPumpRunning = false;
bool dataChanged;

unsigned long durationMinutes = 1;  // Pump run duration in minutes
unsigned long durationMs = durationMinutes * 60UL * 1000UL;

unsigned long historyInterval = 60UL * 1000UL;  // 1 minute in milliseconds
unsigned long lastHistoryTime = 0;

bool pumpRunning = false;
unsigned long pumpStartTime = 0;

int moisture, m_sensor_analog, rain, r_sensor_analog;
int MOISTURE_WET_THRESHOLD = 80;   // Above this percentage, soil is considered "wet"
int MOISTURE_DRY_THRESHOLD = 30;   // Below this, it's considered "dry"

int RAIN_THRESHOLD = 50;           // Rain is detected if wetness percentage is above this


const int r_sensor_pin = 33;  /* Rain sensor O/P pin */
const int m_sensor_pin = 32;   /* Soil moisture sensor O/P pin */
const int trigPin = 5;
const int echoPin = 18;

String deviceName = "";
//define sound speed in cm/uS
#define SOUND_SPEED 0.03478

long duration;
int distanceCm;

DHT_Unified dht(DHTPIN, DHTTYPE);

uint32_t delayMS;

void setup() {
  Serial.begin(9600);
  pinMode(RELAIS,OUTPUT);
  digitalWrite(RELAIS, LOW);
  // Initialize device.
  dht.begin();
  Serial.println(F("DHTxx Unified Sensor Example"));
  // Print temperature sensor details.
  sensor_t sensor;
  dht.temperature().getSensor(&sensor);
  Serial.println(F("------------------------------------"));
  Serial.println(F("Temperature Sensor"));
  Serial.print  (F("Sensor Type: ")); Serial.println(sensor.name);
  Serial.print  (F("Driver Ver:  ")); Serial.println(sensor.version);
  Serial.print  (F("Unique ID:   ")); Serial.println(sensor.sensor_id);
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("°C"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("°C"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("°C"));
  Serial.println(F("------------------------------------"));
  // Print humidity sensor details.
  dht.humidity().getSensor(&sensor);
  Serial.println(F("Humidity Sensor"));
  Serial.print  (F("Sensor Type: ")); Serial.println(sensor.name);
  Serial.print  (F("Driver Ver:  ")); Serial.println(sensor.version);
  Serial.print  (F("Unique ID:   ")); Serial.println(sensor.sensor_id);
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("%"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("%"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("%"));
  Serial.println(F("------------------------------------"));
  // Set delay between sensor readings based on sensor details.
  delayMS = sensor.min_delay / 1000;
  Serial.println(delayMS);
  
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input

  
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);


}

void setup_wifi() {
    delay(10);
    Serial.println("Connecting to WiFi...");
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi Connected!");
}

void callback(char* topic, byte* message, unsigned int length) {
    Serial.print("Message received on topic: ");
    Serial.println(topic);
    Serial.print("Message: ");
    for (int i = 0; i < length; i++) {
        Serial.print((char)message[i]);
    }
    Serial.println();

    String topicStr = String(topic);
    String payload = "";
  
    for (int i = 0; i < length; i++) {
      payload += (char)message[i];
    }
  
    Serial.print("Message received [");
    Serial.print(topicStr);
    Serial.print("]: ");
    Serial.println(payload);
  
    if (topicStr == "device/config/crop") {
      cropType = payload;
      Serial.println("Updated crop type: " + cropType);
    }

}

void reconnect() {
    while (!client.connected()) {
        Serial.print("Attempting MQTT connection...");
        if (client.connect("ESP32Client")) {
            Serial.println("connected");
            client.subscribe(mqtt_topic);
        } else {
            Serial.print("failed, rc=");
            Serial.print(client.state());
            Serial.println(" retrying in 5 seconds");
            delay(5000);
        }
    }
}



void loop() {
  unsigned long startTime = millis();
  // dataChanged = false;
  // Delay between measurements.
  m_sensor_analog = analogRead(m_sensor_pin);
  r_sensor_analog = analogRead(r_sensor_pin);
  moisture = ( 100 - ( (m_sensor_analog/4095.00) * 100 ) );
  rain = ( 100 - ( (r_sensor_analog/4095.00) * 100 ) );

  if (moisture >= MOISTURE_WET_THRESHOLD) {
    Serial.println("Soil is Wet");
  } else if (moisture <= MOISTURE_DRY_THRESHOLD) {
    Serial.println("Soil is Dry");
  } else {
    Serial.println("Soil is Moist (Moderate)");
  }

  if (rain > RAIN_THRESHOLD) {
    Serial.println("It is Raining");
  } else {
    Serial.println("It is not Raining");
  }

  
  if (!client.connected()) {
  reconnect();
}
  client.loop();

  // Clears the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);

  // Calculate the distance
  distanceCm = duration * SOUND_SPEED/2;
//  tank = distancecm;
  delay(delayMS);
  // Get temperature event and print its value.
  sensors_event_t tempEvent, humidEvent;
  dht.temperature().getEvent(&tempEvent);
  dht.humidity().getEvent(&humidEvent);
  if (isnan(tempEvent.temperature)) {
    Serial.println(F("Error reading temperature!"));
  }
  else {
    Serial.print(F("Temperature: "));
    Serial.print(tempEvent.temperature);
    Serial.println(F("°C"));
  }
  // Get humidity event and print its value.
  dht.humidity().getEvent(&humidEvent);
  if (isnan(humidEvent.relative_humidity)) {
    Serial.println(F("Error reading humidity!"));
  }
  else {
    Serial.print(F("Humidity: "));
    Serial.print(humidEvent.relative_humidity);
    Serial.println(F("%"));
  }

  Serial.print("Moisture = ");
  Serial.println(m_sensor_analog);
  Serial.print(moisture);  /* Print Temperature on the serial window */
  Serial.println("%");
  delay(10);   

  Serial.print("Wet? = ");
  Serial.println(r_sensor_analog);
  Serial.print(rain);  /* Print Temperature on the serial window */
  Serial.println("%");

  int calibratedDistancePercent = map(distanceCm, 19, 6, 0, 100);
  calibratedDistancePercent = constrain(calibratedDistancePercent, 0, 100);
  
  Serial.print("Distance (cm): ");
  Serial.println(distanceCm);
  Serial.print("Calibrated Distance (%): ");
  Serial.println(calibratedDistancePercent);

  if (!pumpRunning && moisture < MOISTURE_DRY_THRESHOLD) {
    pumpRunning = true;
    pumpStartTime = millis();
    digitalWrite(RELAIS, HIGH);
    Serial.println("Pump started.");
    
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"gaiaTbeta\",";
    jsonPayload += "\"status\": " + String(pumpRunning ? "true" : "false") ;
    jsonPayload += "}";
  
    client.publish(p_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published pump: " + jsonPayload);
    //dataChanged = true;
    delay(200); // simple debounce
  }

  
  if (cropType == "Vegetable") {
    MOISTURE_WET_THRESHOLD = 80;
    MOISTURE_DRY_THRESHOLD = 70;
    }
  else if (cropType == "Maize") {
    MOISTURE_WET_THRESHOLD = 35;
    MOISTURE_DRY_THRESHOLD = 45;
    }
  else if (cropType == "Beans") {
    MOISTURE_WET_THRESHOLD = 45;
    MOISTURE_DRY_THRESHOLD = 55;
    }
    
  else if (cropType == "Okra") {
    MOISTURE_WET_THRESHOLD = 55;
    MOISTURE_DRY_THRESHOLD = 65;
    }

    
  // If pump is running, check if time is up
  if ((millis() - pumpStartTime >= durationMs) || moisture > MOISTURE_WET_THRESHOLD) {
    digitalWrite(RELAIS, LOW);
    pumpRunning = false;
    Serial.println("Pump stopped.");
    
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"gaiaTbeta\",";
    jsonPayload += "\"status\": " + String(pumpRunning ? "true" : "false") ;
    jsonPayload += "}";
  
    client.publish(p_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published pump: " + jsonPayload);
    delay(2000);

    //dataChanged = true;
  }
  Serial.println(durationMs);
  Serial.println(millis() - pumpStartTime);

  if (moisture != prevMoisture) {
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"gaiaTbeta\",";
    jsonPayload += "\"moisture\": " + String(moisture);
    jsonPayload += "}";
    //dataChanged = true;
    client.publish(m_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published moisture values: " + jsonPayload);
  
    prevMoisture = moisture;
  }
  if (tempEvent.temperature != prevTemperature) {
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"gaiaTbeta\",";
    jsonPayload += "\"temperature\": " + String((tempEvent.temperature)) ;
    jsonPayload += "}";
    //dataChanged = true;
    client.publish(t_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published temperature values: " + jsonPayload);
    
    prevTemperature = tempEvent.temperature;
  }
  if (round(humidEvent.relative_humidity) != prevHumidity) {
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"gaiaTbeta\",";
    jsonPayload += "\"humidity\": " + String(round(humidEvent.relative_humidity));
    jsonPayload += "}";
    //dataChanged = true;
    client.publish(h_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published humidity values: " + jsonPayload);
    
    prevHumidity = round(humidEvent.relative_humidity);
  }

  if (rain != prevWet) {
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"gaiaTbeta\",";
    jsonPayload += "\"wetness\": " + String(rain) ;
    jsonPayload += "}";
    //dataChanged = true;
    client.publish(w_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published wet values: " + jsonPayload);
    
    prevWet = rain;
  }
  if(distanceCm != prevDistanceCm){
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"gaiaTbeta\",";
    jsonPayload += "\"distance\": " + String(calibratedDistancePercent);
    jsonPayload += "}";
    prevDistanceCm = calibratedDistancePercent;
    //dataChanged = true;
    client.publish(d_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published distance values: " + jsonPayload);
  }
  if(deviceName != "gaiaTbeta"){
    deviceName = "gaiaTbeta";
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"" + String(deviceName) + "\"";
    jsonPayload += "}";
  
    client.publish(mqtt_topic, jsonPayload.c_str());
    Serial.println("Published updated device name" + jsonPayload);
  }
if (millis() - lastHistoryTime >= historyInterval) {
    lastHistoryTime = millis(); 
    String jsonPayload = "{";
    jsonPayload += "\"device\": \"" + String(deviceName) + "\",";
    jsonPayload += "\"moisture\": " + String(moisture) + ",";
    jsonPayload += "\"humidity\": " + String(round(humidEvent.relative_humidity)) + ",";
    jsonPayload += "\"temperature\": " + String(tempEvent.temperature) + ",";
    jsonPayload += "\"wetness\": " + String(rain) + ",";
    jsonPayload += "\"distance\": " + String(calibratedDistancePercent) + ",";
    jsonPayload += "\"status\": " + String(pumpRunning ? "true" : "false");
    jsonPayload += "}";

    client.publish(history_mqtt_topic, jsonPayload.c_str());
    Serial.println("Published history values: " + jsonPayload);
  }

  delay(5000);  
  }
