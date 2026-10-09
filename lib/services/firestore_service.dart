import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incident.dart';

class FirestoreService {
  final CollectionReference _incidents =
      FirebaseFirestore.instance.collection('incidents');

  Future<void> addIncident(Incident data) async {
    await _incidents.add(data.toMap());
  }

  Stream<List<Incident>> getIncidentsStream() {
    return _incidents
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Incident.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateIncident(String id, Incident data) async {
    await _incidents.doc(id).update(data.toMap());
  }

  Future<void> deleteIncident(String id) async {
    await _incidents.doc(id).delete();
  }
}