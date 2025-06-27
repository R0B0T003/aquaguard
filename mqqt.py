import firebase_admin
from firebase_admin import credentials, firestore
import paho.mqtt.client as mqtt
import json
from datetime import datetime, timezone
import threading
import time

# Load Firebase credentials
cred = credentials.Certificate("/home/robot/Desktop/firebaseMQTT/mqtt-env/scripts/serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# MQTT Setup
MQTT_BROKER = "localhost"  # Or your PC's IP
MQTT_PORT = 1883
MQTT_TOPICS = [
    "device",
    "device/parameters/moisture",
    "device/parameters/temperature",
    "device/parameters/humidity",
    "device/parameters/wetness",
    "device/parameters/distance",
    "device/parameters/pumpStatus",
    "device/parameters/history"
]

def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT broker with result code {rc}")
    for topic in MQTT_TOPICS:
        client.subscribe(topic)
        print(f"✅ Subscribed to {topic}")

def on_message(client, userdata, msg):
    try:
        payload = msg.payload.decode()
        print(f"Received message: {payload}")

        data = json.loads(payload)
        data["timestamp"] = datetime.now(timezone.utc)

        if "device" not in data:
            print("❌ device_name missing in payload, skipping...")
            return

        device_id = data["device"]

        # Save latest data
        db.collection("iot_data").document(device_id).set(data, merge=True)

        # Save to history
        timestamp = datetime.now(timezone.utc).isoformat()
        db.collection("iot_data").document(device_id).collection("history").document(timestamp).set(data)
        print(f"✅ Data written to Firestore under device '{device_id}'")
    except Exception as e:
        print("❌ Failed to process message:", e)

def fetch_and_publish_config():
    while True:
        try:
            # Loop through known devices (you can customize or pull dynamically)
            device_ids = ["gaiaTbeta"]  # Add more if needed

            for device_id in device_ids:
                config_ref = db.collection("iot_data").document(device_id)
                config_ref2 = db.collection("users").document("8lJmONsbBzZxD7vRkJtYEGtI4fD2")
                
                config = config_ref.get()
                config2 = config_ref2.get()
                if config.exists:
                    config_data = config.to_dict()
                    if "status" in config_data:
                        status = config_data["status"]
                        mqtt_client.publish(f"device/{device_id}/config/pumpStatus", str(status))
                        print(f"🔁 Published pumpThreshold {status} to device/{device_id}/config/pumpThreshold")
                if config2.exists:
                    config_data2 = config2.to_dict()
                    if "crop" in config_data2:
                        crop_type = config_data["crop"]
                        mqtt_client.publish(f"device/{device_id}/config/cropType", str(crop_type))
                        print(f"🔁 Published croptype{crop_type} to device/{device_id}/config/cropType")
        except Exception as e:
            print("❌ Error publishing config:", e)

        time.sleep(10)  # Adjust interval as needed

# Setup MQTT client
mqtt_client = mqtt.Client()
mqtt_client.on_connect = on_connect
mqtt_client.on_message = on_message

mqtt_client.connect(MQTT_BROKER, MQTT_PORT, 60)

# Start config publisher in a background thread
config_thread = threading.Thread(target=fetch_and_publish_config, daemon=True)
config_thread.start()

# Run the MQTT loop
mqtt_client.loop_forever()
