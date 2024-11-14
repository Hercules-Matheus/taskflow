import 'package:cloud_firestore/cloud_firestore.dart';

class DbFirestore {
  DbFirestore._();
  static final DbFirestore _instance = DbFirestore._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory DbFirestore() {
    return _instance;
  }

  static FirebaseFirestore get() {
    return _instance._firestore;
  }
}
