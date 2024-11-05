import 'package:flutter/material.dart';
import 'package:taskflow/models/task.dart';

class TasksRepository extends ChangeNotifier {
  List<Tasks> tableTask = [];
  bool isSorted = false;

  void addTask(Tasks task) {
    tableTask.add(task);
    notifyListeners(); // Notifica que a lista foi alterada
  }

  List<Tasks> getTasks(String taskListId) {
    // Filtra as tarefas pelo taskListId
    return tableTask.where((task) => task.taskListId == taskListId).toList();
  }

  void removeTask(Tasks task) {
    tableTask.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  void updateTask(Tasks task) {
    int index = tableTask.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tableTask[index] = task;
      notifyListeners(); // Notifica que a lista foi alterada
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
        tableTask.where((task) => task.taskListId == taskListId).toList();

    if (!isSorted) {
      filteredTasks.sort((Tasks a, Tasks b) => a.name.compareTo(b.name));
      isSorted = true;
    } else {
      filteredTasks.sort((Tasks a, Tasks b) => a.name.compareTo(b.name));
      filteredTasks = filteredTasks.reversed.toList();
      isSorted = false;
    }

    // Atualiza a lista principal com as tarefas ordenadas
    tableTask.removeWhere((task) => task.taskListId == taskListId);
    tableTask.addAll(filteredTasks);

    notifyListeners(); // Notifica que a lista foi alterada
  }
}
