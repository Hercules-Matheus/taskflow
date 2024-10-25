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
import 'package:taskflow/repository/list_repository.dart';
import 'package:taskflow/repository/tasks_repository.dart';

class TaskPage extends StatefulWidget {
  static String tag = 'task_page';

  final int taskListId;

  const TaskPage({super.key, required this.taskListId});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  late List<Tasks> tasks;
  late String listName;
  final TextEditingController _searchController = TextEditingController();
  List<Tasks> filteredTasks = [];
  late TasksRepository tasksRepository;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tasksRepository = Provider.of<TasksRepository>(context);
    _updateTasksList();
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
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _searchController,
              onChanged: _filterTasks,
              cursorColor: AppColors.secondaryGreenColor,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryGreenColor,
                  ),
                ),
                hintText: 'Buscar',
                hintStyle: const TextStyle(
                  fontFamily: AppFonts.montserrat,
                  fontSize: 14.0,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                  icon: const Icon(Icons.close),
                  color: AppColors.secondaryGreenColor,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      _clearSearch();
                    },
                    child: const Text(
                      "Limpar",
                      style: TextStyle(
                        color: AppColors.secondaryGreenColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _updateTasksList() {
    setState(() {
      // Atualiza a lista `filteredTasks` após mudanças
      tasks = tasksRepository.getTasks(widget.taskListId);
      filteredTasks = tasks;
    });
  }

  void _filterTasks(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _clearSearch(); // Limpa a pesquisa e mostra todas as tarefas
      } else {
        // Obtém todas as tarefas e filtra de acordo com o termo de busca
        tasks = tasksRepository.getTasks(widget.taskListId);
        filteredTasks = tasks
            .where(
                (task) => task.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _clearSearch() {
    setState(() {
      // Atualiza a lista de tarefas filtradas para mostrar todas as tarefas
      filteredTasks = tasks;
      _searchController.clear(); // Limpa o campo de busca
    });
  }

  void sortByAlpha() {
    tasksRepository.sortByName(widget.taskListId);
    setState(() {
      _updateTasksList();
    });
  }

  void listEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListEditPage(
          taskListId: widget.taskListId,
        ),
      ),
    ).then((_) {
      setState(() {
        _updateTasksList();
      });
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
    String appBarTitle = ListRepository.findListById(widget.taskListId).name;
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
                    itemCount: filteredTasks.length,
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
                                      filteredTasks[index].isChecked
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: AppColors.primaryGreenColor,
                                    ),
                                  ),
                                  title: Text(filteredTasks[index].name),
                                  titleTextStyle: const TextStyle(
                                      fontFamily: AppFonts.poppins,
                                      color: AppColors.primaryBlackColor),
                                  subtitle: Text(filteredTasks[index].date),
                                  subtitleTextStyle: const TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    color: AppColors.secondaryBlackColor,
                                  ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskAddPage(
                          taskListId: widget.taskListId,
                        ),
                      ),
                    ).then((_) {
                      _updateTasksList();
                    });
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
          appBarTitle,
          style: const TextStyle(
            fontFamily: AppFonts.montserrat,
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryWhiteColor,
          ),
        ),
      ),
      floatingActionButton: FabMenuButton(
        taskListId: widget.taskListId,
        onSortByAlpha: sortByAlpha,
        onListEdit: listEdit,
        onSearch: _showSearchDialog,
      ),
      body: body,
      backgroundColor: AppColors.primaryWhiteColor,
    );
  }
}
