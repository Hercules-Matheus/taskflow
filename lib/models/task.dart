import 'package:uuid/uuid.dart';

class Tasks {
  final String id = const Uuid().v4();
  String name;
  String date;
  bool isChecked;
  String taskListId;

  Tasks({
    required this.name,
    required this.date,
    required this.isChecked,
    required this.taskListId,
  });
}
