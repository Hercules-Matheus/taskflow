import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
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

  final String listId;

  const TaskPage({super.key, required this.listId});

  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  late List<Tasks> tasks;
  late String listName;
  final TextEditingController _searchController = TextEditingController();
  List<Tasks> filteredTasks = [];
  late TasksRepository tasksRepository;
  late ListRepository listRepository;
  final ScrollController _scrollController = ScrollController();
  int? highlightedTaskIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listRepository = Provider.of<ListRepository>(context);
    tasksRepository = Provider.of<TasksRepository>(context);
    tasksRepository.addListener(_updateTasksList);
    _updateTasksList();
    if (_searchController.text.isEmpty) {
      _clearSearch();
    }
  }

  void _updateTasksList() {
    setState(() {
      tasks = tasksRepository.getTasks();
      filteredTasks = tasks;
    });
    debugPrint('on updateTaskList');
  }

  @override
  void dispose() {
    tasksRepository.removeListener(_updateTasksList);
    super.dispose();
  }

  showTaskTitle(index) {
    if (filteredTasks[index].date.isNotEmpty &&
        filteredTasks[index].name.length > 24) {
      return SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 24,
                  width: 165,
                  child: Marquee(
                    text: filteredTasks[index].name,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.0,
                      color: tasks[index].isChecked == 'true'
                          ? AppColors.primaryWhiteColor
                          : AppColors.primaryBlackColor,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20,
                    velocity: 100,
                    pauseAfterRound: const Duration(seconds: 1),
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  filteredTasks[index].date,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.0,
                    color: tasks[index].isChecked == 'true'
                        ? AppColors.primaryWhiteColor
                        : AppColors.primaryBlackColor,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    } else if (filteredTasks[index].date.isEmpty &&
        filteredTasks[index].name.length > 25) {
      return SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 24,
                  width: 165,
                  child: Marquee(
                    text: filteredTasks[index].name,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.0,
                      color: tasks[index].isChecked == 'true'
                          ? AppColors.primaryWhiteColor
                          : AppColors.primaryBlackColor,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20,
                    velocity: 100,
                    pauseAfterRound: const Duration(seconds: 1),
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (filteredTasks[index].date.isNotEmpty &&
        filteredTasks[index].name.length <= 25) {
      return SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  filteredTasks[index].name,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.0,
                    color: tasks[index].isChecked == 'true'
                        ? AppColors.primaryWhiteColor
                        : AppColors.primaryBlackColor,
                  ),
                ),
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  filteredTasks[index].date,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.0,
                    color: tasks[index].isChecked == 'true'
                        ? AppColors.primaryWhiteColor
                        : AppColors.primaryBlackColor,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  filteredTasks[index].name,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.0,
                    color: tasks[index].isChecked == 'true'
                        ? AppColors.primaryWhiteColor
                        : AppColors.primaryBlackColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  showListTitle() {
    String appBarTitle = listRepository.findListById(widget.listId).name;
    if (appBarTitle.length > 24) {
      return Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 32,
            width: 300,
            child: Marquee(
              text: appBarTitle,
              style: const TextStyle(
                fontFamily: AppFonts.montserrat,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryWhiteColor,
              ),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20,
              velocity: 100,
              pauseAfterRound: const Duration(seconds: 3),
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
        ],
      );
    } else {
      return Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 32,
            width: 300,
            child: Text(
              appBarTitle,
              style: const TextStyle(
                fontFamily: AppFonts.montserrat,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryWhiteColor,
              ),
            ),
          ),
        ],
      );
    }
  }

  void _toggleCheckbox(int index) {
    debugPrint(tasks[index].isChecked);
    setState(() {
      if (tasks[index].isChecked == 'false') {
        tasks[index].isChecked = 'true';
      } else if (tasks[index].isChecked == 'true') {
        tasks[index].isChecked = 'false';
      }
    });
    debugPrint(tasks[index].isChecked);
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
              onChanged: _scrollToTask,
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

  void _scrollToTask(String query) {
    int index = tasks.indexWhere(
      (task) => task.name.toLowerCase().contains(
            query.toLowerCase(),
          ),
    );

    if (index != -1) {
      setState(() {
        highlightedTaskIndex = index;
      });
      _scrollController.animateTo(
        index * 72.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _clearSearch() {
    setState(() {
      // Atualiza a lista de tarefas filtradas para mostrar todas as tarefas
      filteredTasks = tasks;
      highlightedTaskIndex = null;
      _searchController.clear(); // Limpa o campo de busca
    });
  }

  void sortByAlpha() {
    tasksRepository.sortByName(widget.listId);
    setState(() {
      _updateTasksList();
    });
  }

  void listEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListEditPage(
          listId: widget.listId,
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
                  setState(() {
                    tasksRepository.removeTask(tasks[index]);
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
                    controller: _scrollController,
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      bool isHighLighted = index == highlightedTaskIndex;
                      return Card(
                        color: tasks[index].isChecked == 'false'
                            ? AppColors.primaryWhiteColor
                            : AppColors.primaryGreenColor,
                        shape: isHighLighted
                            ? RoundedRectangleBorder(
                                side: BorderSide(
                                    color: tasks[index].isChecked == 'false'
                                        ? AppColors.primaryGreenColor
                                        : AppColors.secondaryGreenColor,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              )
                            : RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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
                                      setState(() {
                                        _toggleCheckbox(index);
                                        tasksRepository.updateTaskCompleted(
                                          tasks[index].id,
                                          tasks[index].isChecked,
                                        );
                                      });
                                    },
                                    icon: Icon(
                                      filteredTasks[index].isChecked == 'true'
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: tasks[index].isChecked == 'false'
                                          ? AppColors.primaryGreenColor
                                          : AppColors.primaryWhiteColor,
                                    ),
                                  ),
                                  title: showTaskTitle(index),
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
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color:
                                              tasks[index].isChecked == 'false'
                                                  ? AppColors.primaryGreenColor
                                                  : AppColors.primaryWhiteColor,
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
                                                  ChangeNotifierProvider.value(
                                                value: tasksRepository,
                                                child: TaskEditPage(
                                                  taskId: tasks[index].id,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color:
                                              tasks[index].isChecked == 'false'
                                                  ? AppColors.primaryGreenColor
                                                  : AppColors.primaryWhiteColor,
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
                        builder: (context) => ChangeNotifierProvider.value(
                          value: tasksRepository,
                          child: TaskAddPage(
                            listId: widget.listId,
                          ),
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
      resizeToAvoidBottomInset: false,
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
        title: showListTitle(),
      ),
      floatingActionButton: FabMenuButton(
        listId: widget.listId,
        onSortByAlpha: sortByAlpha,
        onListEdit: listEdit,
        onSearch: _showSearchDialog,
      ),
      body: body,
      backgroundColor: AppColors.primaryWhiteColor,
    );
  }
}
