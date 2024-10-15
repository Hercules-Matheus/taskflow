import 'package:taskflow/models/list.dart';

class ListRepository {
  static List<Lists> tableList = [];

  static void addTask(Lists tasklist) {
    tableList.add(tasklist);
  }

  static List<Lists> getTasks() {
    return tableList;
  }

  static void removeTask(Lists tasklist) {
    tableList.remove(tasklist);
  }
}
