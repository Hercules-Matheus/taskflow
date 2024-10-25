class Tasks {
  static int _idCounter = 0;
  final int id = _idCounter++;
  String name;
  String date;
  bool isChecked;
  int taskListId;

  Tasks({
    required this.name,
    required this.date,
    required this.isChecked,
    required this.taskListId,
  });
}
