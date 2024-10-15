import 'package:taskflow/models/task.dart';

class TasksRepository {
  static List<Tasks> tableTask = [];

  static void addTask(Tasks task) {
    tableTask.add(task);
  }

  static List<Tasks> getTasks() {
    return tableTask;
  }

  static void removeTask(Tasks task) {
    tableTask.remove(task);
  }
}
