import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/fab_button/fab_menu_button.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/pages/list/list_edit_page.dart';
import 'package:taskflow/pages/task/task_add_page.dart';
import 'package:taskflow/pages/task/task_edit_page.dart';
import 'package:taskflow/repository/tasks_repository.dart';

class TaskPage extends StatefulWidget {
  static String tag = 'task_page';
  final String taskListName;
  final int taskListId;

  const TaskPage(
      {super.key, required this.taskListName, required this.taskListId});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  late List<Tasks> tasks;
  late String listName;
  final TextEditingController _searchController = TextEditingController();
  late TasksRepository tasksRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tasksRepository = Provider.of<TasksRepository>(context);
    tasks = tasksRepository.getTasks();
  }

  @override
  void initState() {
    super.initState();
  }

  void _toggleCheckbox(int index) {
    setState(
      () {
        tasks[index].isChecked = !tasks[index].isChecked;
      },
    );
  }

  void _showSearchDialog() {
    const Spacer();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            TextField(
              controller: _searchController,
              cursorColor: AppColors.secondaryGreenColor,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryGreenColor,
                  ),
                ),
                hintText: 'Buscar tarefas',
                hintStyle: const TextStyle(
                  fontFamily: AppFonts.montserrat,
                  fontSize: 14.0,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  color: AppColors.secondaryGreenColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void sortByAlpha() {
    tasksRepository.sortByName();
    setState(() {
      tasks = tasksRepository.getTasks();
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação de Exclusão'),
          content: Text(
            'Você tem certeza que deseja excluir a tarefa: "${tasks[index].name}"?',
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.primaryGreenColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Primeira verificacao para garantir que a tarefa existe
                if (tasks.isNotEmpty && index < tasks.length) {
                  tasksRepository.removeTask(tasks[index]);
                  setState(() {
                    tasks.removeAt(index);
                  });
                }
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text(
                'Excluir',
                style: TextStyle(
                  color: AppColors.primaryGreenColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryGreenColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    final body = Container(
      color: AppColors.primaryWhiteColor,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
      child: Column(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          const Row(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Tarefas',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: AppColors.primaryBlackColor,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 560,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: AppColors.secondaryWhiteColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 72,
                              child: Center(
                                child: ListTile(
                                  leading: IconButton(
                                    alignment: Alignment.center,
                                    iconSize: 28,
                                    onPressed: () {
                                      _toggleCheckbox(index);
                                    },
                                    icon: Icon(
                                      tasks[index].isChecked
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: AppColors.primaryGreenColor,
                                    ),
                                  ),
                                  title: Text(tasks[index].name),
                                  subtitle: Text(tasks[index].date),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        alignment: Alignment.center,
                                        iconSize: 28,
                                        onPressed: () {
                                          _showDeleteConfirmationDialog(
                                              context, index);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: AppColors.primaryGreenColor,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Deletar',
                                        iconSize: 28,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskEditPage(
                                                taskId: tasks[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: AppColors.primaryGreenColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    debugPrint('clicado');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskAddPage(),
                      ),
                    );
                  },
                  label: const Text(
                    'Nova Tarefa',
                    style: TextStyle(
                      color: AppColors.primaryWhiteColor,
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(5.0),
                    iconColor:
                        WidgetStatePropertyAll(AppColors.primaryWhiteColor),
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.primaryGreenColor),
                    padding: WidgetStatePropertyAll(EdgeInsets.all(16.0)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     _showSearchDialog();
              //   },
              //   style: const ButtonStyle(
              //     elevation: WidgetStatePropertyAll(5.0),
              //     backgroundColor:
              //         WidgetStatePropertyAll(AppColors.primaryGreenColor),
              //     padding: WidgetStatePropertyAll(EdgeInsets.all(16.0)),
              //     shape: WidgetStatePropertyAll(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(16.0),
              //         ),
              //       ),
              //     ),
              //   ),
              //   child: const Icon(
              //     Icons.search,
              //     color: AppColors.primaryWhiteColor,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenColor,
        toolbarHeight: 64,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
            size: 30,
            color: AppColors.primaryWhiteColor,
          ),
        ),
        centerTitle: false,
        title: Text(
          widget.taskListName,
          style: const TextStyle(
            fontFamily: AppFonts.montserrat,
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryWhiteColor,
          ),
        ),
      ),
      floatingActionButton: FabMenuButton(
        taskListName: widget.taskListName,
        taskListId: widget.taskListId,
        onSortByAlpha: sortByAlpha,
      ),
      body: body,
      backgroundColor: AppColors.primaryWhiteColor,
    );
  }
}
