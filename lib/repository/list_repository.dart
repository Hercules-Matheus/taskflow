import 'package:taskflow/models/list.dart';

class ListRepository {
  static List<Lists> table = [];

  static void addTask(Lists task) {
    table.add(task);
  }

  static List<Lists> getTasks() {
    return table;
  }
}
