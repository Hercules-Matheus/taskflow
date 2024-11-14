import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskflow/database/db_firestore.dart';
import 'package:taskflow/models/list.dart';
import 'package:taskflow/services/auth_service.dart';

class ListRepository extends ChangeNotifier {
  static List<Lists> tableList = [];
  late FirebaseFirestore db;
  late AuthService auth;

  ListRepository({required this.auth}) {
    _startRepository();
    _loadInitialData();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DbFirestore.get();
  }

  Future<void> _loadInitialData() async {
    if (auth.localUser != null) {
      final snapshot =
          await db.collection('users/${auth.localUser!.uid}/lists').get();
      tableList = snapshot.docs.map((doc) {
        return Lists(
          name: doc['listname'],
          date: doc['listdate'],
          isChecked: doc['listbool'],
        );
      }).toList();
      notifyListeners();
    }
  }

  void addList(Lists tasklist) {
    tableList.add(tasklist);
    db.collection('users/${auth.localUser!.uid}/lists').doc(tasklist.id).set({
      'listname': tasklist.name,
      'listdate': tasklist.date,
      'listbool': tasklist.isChecked
    });
    notifyListeners();
  }

  List<Lists> getList() {
    return tableList;
  }

  void removeList(Lists tasklist) async {
    await db
        .collection('users/${auth.localUser!.uid}/lists')
        .doc(tasklist.id)
        .delete();

    tableList.remove(tasklist);
    notifyListeners();
  }

  void updateList(Lists tasklist) {
    int index = tableList.indexWhere((t) => t.id == tasklist.id);
    if (index != -1) {
      tableList[index] = tasklist;
    }
    notifyListeners();
  }

  Lists findListById(String id) {
    return tableList.firstWhere((tasklist) => tasklist.id == id, orElse: () {
      throw Exception("A lista '$id' não foi encontrada.");
    });
  }
}
