class Lists {
  static int _idCounter = 0;
  final int id = _idCounter++;
  String name;
  String date;
  bool isChecked;

  Lists({
    required this.name,
    required this.date,
    required this.isChecked,
  });
}
