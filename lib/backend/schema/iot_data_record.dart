import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class IotDataRecord extends FirestoreRecord {
  IotDataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "device" field.
  String? _device;
  String get device => _device ?? '';
  bool hasDevice() => _device != null;

  // "humidity" field.
  double? _humidity;
  double get humidity => _humidity ?? 0.0;
  bool hasHumidity() => _humidity != null;

  // "moisture" field.
  double? _moisture;
  double get moisture => _moisture ?? 0.0;
  bool hasMoisture() => _moisture != null;

  // "temperature" field.
  double? _temperature;
  double get temperature => _temperature ?? 0.0;
  bool hasTemperature() => _temperature != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "wetness" field.
  double? _wetness;
  double get wetness => _wetness ?? 0.0;
  bool hasWetness() => _wetness != null;

  // "distance" field.
  double? _distance;
  double get distance => _distance ?? 0.0;
  bool hasDistance() => _distance != null;

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "status" field.
  bool? _status;
  bool get status => _status ?? false;
  bool hasStatus() => _status != null;

  // "auto" field.
  bool? _auto;
  bool get auto => _auto ?? false;
  bool hasAuto() => _auto != null;

  void _initializeFields() {
    _device = snapshotData['device'] as String?;
    _humidity = castToType<double>(snapshotData['humidity']);
    _moisture = castToType<double>(snapshotData['moisture']);
    _temperature = castToType<double>(snapshotData['temperature']);
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _wetness = castToType<double>(snapshotData['wetness']);
    _distance = castToType<double>(snapshotData['distance']);
    _user = snapshotData['user'] as DocumentReference?;
    _status = snapshotData['status'] as bool?;
    _auto = snapshotData['auto'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('iot_data');

  static Stream<IotDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => IotDataRecord.fromSnapshot(s));

  static Future<IotDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => IotDataRecord.fromSnapshot(s));

  static IotDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      IotDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static IotDataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      IotDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'IotDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is IotDataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createIotDataRecordData({
  String? device,
  double? humidity,
  double? moisture,
  double? temperature,
  DateTime? timestamp,
  double? wetness,
  double? distance,
  DocumentReference? user,
  bool? status,
  bool? auto,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'device': device,
      'humidity': humidity,
      'moisture': moisture,
      'temperature': temperature,
      'timestamp': timestamp,
      'wetness': wetness,
      'distance': distance,
      'user': user,
      'status': status,
      'auto': auto,
    }.withoutNulls,
  );

  return firestoreData;
}

class IotDataRecordDocumentEquality implements Equality<IotDataRecord> {
  const IotDataRecordDocumentEquality();

  @override
  bool equals(IotDataRecord? e1, IotDataRecord? e2) {
    return e1?.device == e2?.device &&
        e1?.humidity == e2?.humidity &&
        e1?.moisture == e2?.moisture &&
        e1?.temperature == e2?.temperature &&
        e1?.timestamp == e2?.timestamp &&
        e1?.wetness == e2?.wetness &&
        e1?.distance == e2?.distance &&
        e1?.user == e2?.user &&
        e1?.status == e2?.status &&
        e1?.auto == e2?.auto;
  }

  @override
  int hash(IotDataRecord? e) => const ListEquality().hash([
        e?.device,
        e?.humidity,
        e?.moisture,
        e?.temperature,
        e?.timestamp,
        e?.wetness,
        e?.distance,
        e?.user,
        e?.status,
        e?.auto
      ]);

  @override
  bool isValidKey(Object? o) => o is IotDataRecord;
}
