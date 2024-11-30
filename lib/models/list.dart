import 'package:uuid/uuid.dart';

class Lists {
  final String id;
  String name;
  String date;
  String isChecked;

  Lists({
    String? id,
    required this.name,
    required this.date,
    required this.isChecked,
  }) : id = id ?? const Uuid().v4();
}
