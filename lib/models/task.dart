import 'package:uuid/uuid.dart';

class Tasks {
  final String id;
  String name;
  String date;
  String isChecked;
  String listId;

  Tasks({
    String? id,
    required this.name,
    required this.date,
    required this.isChecked,
    required this.listId,
  }) : id = id ?? const Uuid().v4();
}
