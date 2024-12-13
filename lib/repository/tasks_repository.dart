import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskflow/database/db_firestore.dart';
import 'package:taskflow/models/task.dart';

class TasksRepository extends ChangeNotifier {
  List<Tasks> tableTask = [];
  bool isSorted = false;
  late FirebaseFirestore db;
  late User? user = FirebaseAuth.instance.currentUser;
  final String listId;

  TasksRepository({required this.listId}) {
    _startRepository();
  }

  Future<void> _startRepository() async {
    await _startFirestore();
    await _loadInitialData();
  }

  _startFirestore() {
    db = DbFirestore.get();
  }

  Future<void> _loadInitialData() async {
    if (user != null) {
      try {
        final snapshot =
            await db.collection('users/${user!.uid}/lists/$listId/tasks').get();
        tableTask = snapshot.docs.map((doc) {
          return Tasks(
            id: doc.id,
            name: doc['taskname'],
            date: doc['taskdate'],
            isChecked: doc['taskcompleted'],
            listId: doc['listid'],
          );
        }).toList();
        notifyListeners();
      } catch (e) {
        debugPrint("Erro ao carregar tarefas: $e");
      }
    }
  }

  Future<void> addTask(Tasks task) async {
    tableTask.add(task);
    try {
      await db
          .collection('users/${user!.uid}/lists/$listId/tasks')
          .doc(task.id)
          .set({
        'taskid': task.id,
        'taskname': task.name,
        'taskdate': task.date,
        'taskcompleted': task.isChecked,
        'listid': task.listId,
      });
      notifyListeners(); // Notifica que a lista foi alterada
    } catch (e) {
      debugPrint("Erro ao adicionar tarefa: $e");
    }
  }

  List<Tasks> getTasks() {
    // Filtra as tarefas pelo taskListId
    return tableTask;
  }

  Future<void> removeTask(Tasks task) async {
    tableTask.removeWhere((t) => t.id == task.id);
    try {
      await db
          .collection('users/${user!.uid}/lists/$listId/tasks')
          .doc(task.id)
          .delete();
      notifyListeners(); // Notifica que a lista foi alterada
    } catch (e) {
      debugPrint("Erro ao remover tarefa: $e");
    }
  }

  Future<void> updateTask(Tasks task) async {
    int index = tableTask.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tableTask[index] = task;
      try {
        await db
            .collection('users/${user!.uid}/lists/$listId/tasks')
            .doc(task.id)
            .update({
          'taskname': task.name,
          'taskdate': task.date,
          'taskcompleted': task.isChecked,
          'listid': task.listId,
        });
        notifyListeners(); // Notifica que a lista foi alterada
      } catch (e) {
        debugPrint("Erro ao atualizar tarefa: $e");
      }
    }
  }

  Future<void> updateTaskCompleted(
      String taskId, String newtaskcompleted) async {
    try {
      await db
          .collection('users/${user!.uid}/lists/$listId/tasks')
          .doc(taskId)
          .update({
        'taskcompleted': newtaskcompleted,
      });
      // Atualizar o estado local da lista de tarefas
      int index = tableTask.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        tableTask[index].isChecked = newtaskcompleted;
        notifyListeners(); // Notifica que a lista foi alterada
      }
    } catch (e) {
      debugPrint("Erro ao atualizar campo taskcompleted: $e");
    }
  }

  Tasks findTaskById(String id) {
    // Procura a tarefa pelo ID
    return tableTask.firstWhere((task) => task.id == id, orElse: () {
      throw Exception("A tarefa '$id' não foi encontrada.");
    });
  }

  void sortByName(String taskListId) {
    // Ordena somente as tarefas da lista especificada
    List<Tasks> filteredTasks =
        tableTask.where((task) => task.listId == taskListId).toList();

    if (!isSorted) {
      filteredTasks.sort((Tasks a, Tasks b) => a.name.compareTo(b.name));
      isSorted = true;
    } else {
      filteredTasks.sort((Tasks a, Tasks b) => a.name.compareTo(b.name));
      filteredTasks = filteredTasks.reversed.toList();
      isSorted = false;
    }

    // Atualiza a lista principal com as tarefas ordenadas
    tableTask.removeWhere((task) => task.listId == taskListId);
    tableTask.addAll(filteredTasks);

    notifyListeners(); // Notifica que a lista foi alterada
  }
}
