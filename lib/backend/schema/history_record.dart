import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HistoryRecord extends FirestoreRecord {
  HistoryRecord._(
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

  // "index" field.
  int? _index;
  int get index => _index ?? 0;
  bool hasIndex() => _index != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _device = snapshotData['device'] as String?;
    _humidity = castToType<double>(snapshotData['humidity']);
    _moisture = castToType<double>(snapshotData['moisture']);
    _temperature = castToType<double>(snapshotData['temperature']);
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _wetness = castToType<double>(snapshotData['wetness']);
    _index = castToType<int>(snapshotData['index']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('history')
          : FirebaseFirestore.instance.collectionGroup('history');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('history').doc(id);

  static Stream<HistoryRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HistoryRecord.fromSnapshot(s));

  static Future<HistoryRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HistoryRecord.fromSnapshot(s));

  static HistoryRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HistoryRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HistoryRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HistoryRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HistoryRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HistoryRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHistoryRecordData({
  String? device,
  double? humidity,
  double? moisture,
  double? temperature,
  DateTime? timestamp,
  double? wetness,
  int? index,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'device': device,
      'humidity': humidity,
      'moisture': moisture,
      'temperature': temperature,
      'timestamp': timestamp,
      'wetness': wetness,
      'index': index,
    }.withoutNulls,
  );

  return firestoreData;
}

class HistoryRecordDocumentEquality implements Equality<HistoryRecord> {
  const HistoryRecordDocumentEquality();

  @override
  bool equals(HistoryRecord? e1, HistoryRecord? e2) {
    return e1?.device == e2?.device &&
        e1?.humidity == e2?.humidity &&
        e1?.moisture == e2?.moisture &&
        e1?.temperature == e2?.temperature &&
        e1?.timestamp == e2?.timestamp &&
        e1?.wetness == e2?.wetness &&
        e1?.index == e2?.index;
  }

  @override
  int hash(HistoryRecord? e) => const ListEquality().hash([
        e?.device,
        e?.humidity,
        e?.moisture,
        e?.temperature,
        e?.timestamp,
        e?.wetness,
        e?.index
      ]);

  @override
  bool isValidKey(Object? o) => o is HistoryRecord;
}
