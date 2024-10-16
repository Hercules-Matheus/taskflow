import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/models/list.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/repository/list_repository.dart';
import 'package:taskflow/repository/tasks_repository.dart';

class TaskAddPage extends StatefulWidget {
  static String tag = 'task_add_page';

  const TaskAddPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TaskAddPageState();
  }
}

class TaskAddPageState extends State<TaskAddPage> {
  late List<Tasks> tasks;
  late List<Lists> tasklist;

  @override
  void initState() {
    super.initState();
    tasks = TasksRepository.getTasks();
    tasklist = ListRepository.getList();
  }

  void _toggleCheckbox(int index) {
    setState(() {
      tasks[index].isChecked = !tasks[index].isChecked;
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
                  tasks.removeAt(index);
                  setState(() {});
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
    List<Tasks> taskName = tasks;
    List<Lists> listName = tasklist;

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
                  'Listas',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: AppColors.primaryBlackColor,
                    fontFamily: AppFonts.montserrat,
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 320,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: taskName.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskAddPage(),
                            ),
                          );
                        },
                        child: Card(
                          color: AppColors.secondaryWhiteColor,
                          child: SizedBox(
                            height: 72,
                            child: ListTile(
                              title: Text(taskName[index].name),
                              subtitle: Text(taskName[index].date),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    iconSize: 28,
                                    onPressed: () {
                                      _toggleCheckbox(index);
                                    },
                                    icon: Icon(
                                      taskName[index].isChecked
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: AppColors.primaryGreenColor,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Deletar',
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Row(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Tarefas de hoje',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      color: AppColors.primaryBlackColor,
                      fontFamily: AppFonts.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 200,
            child: Row(),
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
                    // debugPrint('clicado');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListAddPage(),
                    //   ),
                    // );
                  },
                  label: const Text(
                    'Nova Lista',
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
              ElevatedButton(
                onPressed: () {
                  debugPrint('Cliquei');
                },
                style: const ButtonStyle(
                  elevation: WidgetStatePropertyAll(5.0),
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
                child: const Icon(
                  Icons.search,
                  color: AppColors.primaryWhiteColor,
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
        title: const Text(
          'Title',
          style: TextStyle(
            fontFamily: AppFonts.montserrat,
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryWhiteColor,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      size: 30,
                      color: AppColors.primaryWhiteColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: body,
      backgroundColor: AppColors.primaryWhiteColor,
    );
  }
}
