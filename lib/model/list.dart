class List {
  String title;
  DateTime actualData = DateTime.now();
  bool reminder;

  List({
    required this.title,
    required this.actualData,
    required this.reminder,
  });
}
