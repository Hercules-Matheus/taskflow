import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/models/list.dart';
import 'package:taskflow/pages/list_add/list_add_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskflow/pages/task/task_page.dart';
import 'package:taskflow/repository/list_repository.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home_page';

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late List<Lists> tasklist;

  @override
  void initState() {
    super.initState();
    tasklist = ListRepository.getList();
  }

  void _toggleCheckbox(int index) {
    setState(() {
      tasklist[index].isChecked = !tasklist[index].isChecked;
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação de Exclusão'),
          content: Text(
            'Você tem certeza que deseja excluir a lista: "${tasklist[index].name}"?',
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
                if (tasklist.isNotEmpty && index < tasklist.length) {
                  tasklist.removeAt(index);
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
    List<Lists> taskListName = tasklist;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryWhiteColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // const transition = Hero(
    //   tag: 'home',
    //   child: Padding(
    //     padding: EdgeInsets.all(16.0),
    //     child: Text('Bem Vindo'),
    //   ),
    // );

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
            child: Expanded(
              child: ListView.builder(
                itemCount: taskListName.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskPage(
                            taskListName: taskListName[index].name,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: AppColors.secondaryWhiteColor,
                      child: SizedBox(
                        height: 72,
                        child: ListTile(
                          title: Text(taskListName[index].name),
                          subtitle: Text(taskListName[index].date),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                iconSize: 28,
                                onPressed: () {
                                  _toggleCheckbox(index);
                                },
                                icon: Icon(
                                  taskListName[index].isChecked
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: AppColors.primaryGreenColor,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Deletar',
                                iconSize: 28,
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, index);
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
                    debugPrint('clicado');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListAddPage(),
                      ),
                    );
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
        toolbarHeight: 64,
        backgroundColor: AppColors.primaryGreenColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: AppColors.primaryWhiteColor,
              ),
            );
          },
        ),
        centerTitle: true,
        title: SvgPicture.asset(
          'lib/assets/images/logo-vertical.svg',
          width: 100,
          height: 54,
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 16.0,
              backgroundImage:
                  AssetImage('lib/assets/images/generic-avatar.png'),
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: body,
      backgroundColor: AppColors.primaryWhiteColor,
    );
  }
}
