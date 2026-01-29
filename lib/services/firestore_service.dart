import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Funkcija koja povlači sve servise iz baze
  Stream<List<Service>> getServices() {
    return _db
        .collection('services')
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Service.fromMap(doc.data(), doc.id))
            .toList());
  }
}