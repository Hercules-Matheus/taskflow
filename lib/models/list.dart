import 'package:uuid/uuid.dart';

class Lists {
  final String id = const Uuid().v4();
  String name;
  String date;
  String isChecked;

  Lists({
    required this.name,
    required this.date,
    required this.isChecked,
  });
}
