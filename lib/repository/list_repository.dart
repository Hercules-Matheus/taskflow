import 'package:taskflow/models/list.dart';

class ListRepository {
  static List<Lists> tableList = [];

  static void addList(Lists tasklist) {
    tableList.add(tasklist);
  }

  static List<Lists> getList() {
    return tableList;
  }

  static void removeList(Lists tasklist) {
    tableList.remove(tasklist);
  }
}
