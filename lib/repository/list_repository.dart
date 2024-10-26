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

  static void updateList(Lists tasklist) {
    int index = tableList.indexWhere((t) => t.id == tasklist.id);
    if (index != -1) {
      tableList[index] = tasklist;
    }
  }

  static Lists findListById(String id) {
    return tableList.firstWhere((tasklist) => tasklist.id == id, orElse: () {
      throw Exception("A lista '$id' não foi encontrada.");
    });
  }
}
