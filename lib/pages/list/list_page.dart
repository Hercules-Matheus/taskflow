import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/models/list.dart';
import 'package:taskflow/pages/list/list_add_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskflow/pages/task/task_page.dart';
import 'package:taskflow/repository/list_repository.dart';
import 'package:taskflow/repository/tasks_repository.dart';

class ListPage extends StatefulWidget {
  static String tag = 'list_page';

  const ListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Lists> tasklist;
  List<Lists> filteredLists = [];
  late TasksRepository tasksRepository;
  final ScrollController _scrollController = ScrollController();
  int? highlightedListIndex;

  @override
  void initState() {
    super.initState();
    tasklist = ListRepository.getList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tasklist = ListRepository.getList();
    filteredLists = tasklist;
    tasksRepository = Provider.of<TasksRepository>(context);
    if (_searchController.text.isEmpty) {
      _clearSearch();
    }
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
              onChanged: _scrollToList,
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

  void _scrollToList(String query) {
    int index = tasklist.indexWhere(
      (list) => list.name.toLowerCase().contains(
            query.toLowerCase(),
          ),
    );

    if (index != -1) {
      setState(() {
        highlightedListIndex = index;
      });
      _scrollController.animateTo(
        index * 72,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  showListTitle(index) {
    if (filteredLists[index].date.isNotEmpty &&
        filteredLists[index].name.length > 25) {
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
                  width: 230,
                  child: Marquee(
                    text: filteredLists[index].name,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.0,
                      color: AppColors.primaryBlackColor,
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
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  filteredLists[index].date,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.0,
                    color: AppColors.primaryBlackColor,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    } else if (filteredLists[index].date.isEmpty &&
        filteredLists[index].name.length > 25) {
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
                  width: 230,
                  child: Marquee(
                    text: filteredLists[index].name,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.0,
                      color: AppColors.primaryBlackColor,
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
            ),
          ],
        ),
      );
    } else if (filteredLists[index].date.isNotEmpty &&
        filteredLists[index].name.length <= 25) {
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
                  filteredLists[index].name,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.0,
                    color: AppColors.primaryBlackColor,
                  ),
                ),
              ],
            ),
            Row(
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  filteredLists[index].date,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.0,
                    color: AppColors.primaryBlackColor,
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
                  filteredLists[index].name,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.0,
                    color: AppColors.primaryBlackColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void _clearSearch() {
    setState(() {
      // Atualiza a lista de tarefas filtradas para mostrar todas as tarefas
      filteredLists = tasklist;
      highlightedListIndex = null;
      _searchController.clear(); // Limpa o campo de busca
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Lists> taskList = tasklist;

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
            height: 560,
            child: Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredLists.length,
                itemBuilder: (context, index) {
                  bool isHighLighted = index == highlightedListIndex;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskPage(
                            taskListId: taskList[index].id,
                          ),
                        ),
                      );
                      _clearSearch();
                    },
                    child: Card(
                      color: AppColors.secondaryWhiteColor,
                      shape: isHighLighted
                          ? RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: AppColors.primaryGreenColor,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                      child: SizedBox(
                        height: 72,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: ListTile(
                            textColor: AppColors.primaryBlackColor,
                            title: showListTitle(index),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  iconSize: 28,
                                  onPressed: () {
                                    _toggleCheckbox(index);
                                  },
                                  icon: Icon(
                                    taskList[index].isChecked
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
                    ),
                  );
                },
              ),
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
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _showSearchDialog();
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
