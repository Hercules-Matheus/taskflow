import 'package:flutter/material.dart';
import 'package:taskflow/models/task.dart';

class TasksRepository extends ChangeNotifier {
  List<Tasks> tableTask = [];
  bool isSorted = false;

  void addTask(Tasks task) {
    tableTask.add(task);
    notifyListeners(); // Notifica que a lista foi alterada
  }

  List<Tasks> getTasks() {
    return List.from(tableTask); // Retorna uma cópia da lista
  }

  void removeTask(Tasks task) {
    tableTask.remove(task);
    notifyListeners(); // Notifica que a lista foi alterada
  }

  void updateTask(Tasks task) {
    int index = tableTask.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tableTask[index] = task;
      notifyListeners(); // Notifica que a lista foi alterada
    }
  }

  Tasks findTaskById(int id) {
    return tableTask.firstWhere((task) => task.id == id, orElse: () {
      throw Exception("A tarefa '$id' não foi encontrada.");
    });
  }

  void sortByName() {
    if (!isSorted) {
      tableTask.sort((Tasks a, Tasks b) => a.name.compareTo(b.name));
      isSorted = true;
    } else {
      tableTask.sort((Tasks a, Tasks b) => a.name.compareTo(b.name));
      tableTask = tableTask.reversed.toList();
      isSorted = false;
    }

    notifyListeners();
    // Notifica que a lista foi alterada
  }

  List<Tasks> findTasksByName(String name) {
    return tableTask
        .where((task) => task.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }
}
