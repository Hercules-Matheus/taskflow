import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskflow/database/db_firestore.dart';
import 'package:taskflow/models/list.dart';
import 'package:taskflow/services/auth_service.dart';

class ListRepository extends ChangeNotifier {
  static List<Lists> tableList = [];
  late FirebaseFirestore db;
  late User? user = FirebaseAuth.instance.currentUser;

  ListRepository({required AuthService authService}) {
    authService.addListener(() {
      user = authService.localUser;
      if (user != null) {
        _loadInitialData();
      }
    }); // Carregar dados do usuário ao logar } });
    _startRepository();
  }

  void update(AuthService authService) {
    user = authService.localUser;
    if (user != null) {
      _loadInitialData();
    }
  }

  Future<void> _startRepository() async {
    await _startFirestore();
    if (user != null) {
      await _loadInitialData();
    } // Carregue os dados aqui
  }

  _startFirestore() {
    db = DbFirestore.get();
  }

  Future<void> _loadInitialData() async {
    if (user != null) {
      final snapshot = await db.collection('users/${user!.uid}/lists').get();
      tableList = snapshot.docs.map((doc) {
        return Lists(
          id: doc.id, // Usar ID do documento do Firestore
          name: doc['listname'],
          date: doc['listdate'],
          isChecked: doc['listbool'].toString(),
        );
      }).toList();
      notifyListeners();
    }
  }

  void addList(Lists tasklist) async {
    tableList.add(tasklist);
    await db.collection('users/${user!.uid}/lists').doc(tasklist.id).set({
      'listid': tasklist.id,
      'listname': tasklist.name,
      'listdate': tasklist.date,
      'listbool': tasklist.isChecked
    });
    notifyListeners();
  }

  void removeList(Lists tasklist) async {
    debugPrint('on removeList');
    try {
      await db.collection('users/${user!.uid}/lists').doc(tasklist.id).delete();
      tableList.remove(tasklist);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao remover lista: $e');
    }
  }

  void updateList(Lists tasklist) async {
    debugPrint('on updateList');
    try {
      int index = tableList.indexWhere((t) => t.id == tasklist.id);
      if (index != -1) {
        tableList[index] = tasklist;
        await db
            .collection('users/${user!.uid}/lists')
            .doc(tasklist.id)
            .update({
          'listid': tasklist.id,
          'listname': tasklist.name,
          'listdate': tasklist.date,
          'listbool': tasklist.isChecked
        });
        notifyListeners();
      } else {
        debugPrint('Lista não encontrada: ${tasklist.id}');
      }
    } catch (e) {
      debugPrint('Erro ao atualizar lista: $e');
    }
  }

  Future<void> updateListBool(String listId, String newListBool) async {
    try {
      await db.collection('users/${user!.uid}/lists').doc(listId).update({
        'listbool': newListBool,
      });
      // Atualizar o estado local da lista de tarefas
      int index = tableList.indexWhere((tasklist) => tasklist.id == listId);
      if (index != -1) {
        tableList[index].isChecked = newListBool;
        notifyListeners(); // Notifica que a lista foi alterada
      }
    } catch (e) {
      debugPrint("Erro ao atualizar campo listbool: $e");
    }
  }

  List<Lists> getList() {
    return tableList;
  }

  Lists findListById(String id) {
    return tableList.firstWhere((tasklist) => tasklist.id == id, orElse: () {
      throw Exception("A lista '$id' não foi encontrada.");
    });
  }
}
