import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/models/list.dart';
import 'package:taskflow/pages/list/list_add_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskflow/pages/login/login_page.dart';
import 'package:taskflow/pages/preview/preview_page.dart';
import 'package:taskflow/pages/task/task_page.dart';
import 'package:taskflow/repository/list_repository.dart';
import 'package:taskflow/repository/tasks_repository.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

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
  final TextEditingController _editUsernameController = TextEditingController();
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  late List<Lists> tasklist;
  List<Lists> filteredLists = [];
  late ListRepository listRepository;
  final ScrollController _scrollController = ScrollController();
  User? user = FirebaseAuth.instance.currentUser;
  int? highlightedListIndex;
  String? userName;
  late File userProfilePic;
  bool hasProfilePicUploaded = false;
  String uniquekey = '';

  @override
  void initState() {
    super.initState();
    _checkFirstAccess();
    _loadUserNameWithRetry();
    _loadUserProfilePic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listRepository = Provider.of<ListRepository>(context);
    listRepository.addListener(_updateTaskList);
    _updateTaskList();
    if (_searchController.text.isEmpty) {
      _clearSearch();
    }
  }

  @override
  void dispose() {
    listRepository.removeListener(_updateTaskList);
    _searchController.dispose();
    _editUsernameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateTaskList() {
    if (!mounted) return;
    setState(() {
      tasklist = listRepository.getList();
      filteredLists = tasklist;
    });
  }

  Future<void> _loadUserNameWithRetry() async {
    const retryDelay = Duration(seconds: 2);
    int retryCount = 0;

    while (true) {
      try {
        await _loadUserName();
        break;
      } on FirebaseException catch (e) {
        if (e.code == 'cloud_firestore/unavailable' && retryCount < 5) {
          retryCount++;
          await Future.delayed(retryDelay);
        } else {
          rethrow;
        }
      }
    }
  }

  Future<void> _checkFirstAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenShowcase = prefs.getBool('hasSeenShowcase') ?? false;

    if (!hasSeenShowcase) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _one,
          _two,
          _three,
          _four,
        ]);
      });
      await prefs.setBool('hasSeenShowcase', true);
    }
  }

  Future<void> _loadUserName() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['userName'];
        });
      }
    }
  }

  Future<void> _saveUserName() async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'userName': _editUsernameController.text,
      });
      setState(() {
        userName = _editUsernameController.text;
      });
    }
  }

  Future<void> _loadUserProfilePic() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/profile_pic.jpg';
      final file = File(filePath);
      if (await file.exists()) {
        setState(() {
          userProfilePic = file;
          hasProfilePicUploaded = true;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar a imagem: $e');
    }
  }

  showPreview(File file) async {
    final File? resultFile = await Get.to(() => PreviewPage(file: file));
    if (resultFile != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/profile_pic.jpg';
        final savedFile = await resultFile.copy(filePath);
        await FileImage(savedFile).evict();
        setState(() {
          userProfilePic = savedFile;
          hasProfilePicUploaded = true;
          uniquekey = DateTime.now().millisecondsSinceEpoch.toString();
        });
      } catch (e) {
        debugPrint('Erro ao salvar a imagem: $e');
      }
    } else {}
    Get.back();
  }

  void _toggleCheckbox(int index) {
    setState(() {
      if (tasklist[index].isChecked == 'false') {
        tasklist[index].isChecked = 'true';
      } else if (tasklist[index].isChecked == 'true') {
        tasklist[index].isChecked = 'false';
      }
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
                  listRepository.removeList(tasklist[index]);
                  // tasklist.removeAt(index);
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

  void _showNameEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _editUsernameController,
              cursorColor: AppColors.secondaryGreenColor,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryGreenColor,
                  ),
                ),
                hintText: 'Digite seu nome',
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _saveUserName();
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Salvar",
                      style: TextStyle(
                        color: AppColors.secondaryGreenColor,
                      ),
                    ),
                  ),
                ],
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
              height: 10,
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
            ),
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
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.0,
                      color: tasklist[index].isChecked == 'false'
                          ? AppColors.primaryBlackColor
                          : AppColors.primaryWhiteColor,
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
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.0,
                    color: tasklist[index].isChecked == 'false'
                        ? AppColors.primaryBlackColor
                        : AppColors.primaryWhiteColor,
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
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 16.0,
                      color: tasklist[index].isChecked == 'false'
                          ? AppColors.primaryBlackColor
                          : AppColors.primaryWhiteColor,
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
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.0,
                    color: tasklist[index].isChecked == 'false'
                        ? AppColors.primaryBlackColor
                        : AppColors.primaryWhiteColor,
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
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12.0,
                    color: tasklist[index].isChecked == 'false'
                        ? AppColors.primaryBlackColor
                        : AppColors.primaryWhiteColor,
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
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16.0,
                    color: tasklist[index].isChecked == 'false'
                        ? AppColors.primaryBlackColor
                        : AppColors.primaryWhiteColor,
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryWhiteColor,
        systemNavigationBarIconBrightness: Brightness.dark,
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
            height: 560,
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
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => TasksRepository(
                            listId: tasklist[index].id,
                          ),
                          child: TaskPage(
                            listId: tasklist[index].id,
                          ),
                        ),
                      ),
                    );
                    _clearSearch();
                  },
                  child: Card(
                    color: tasklist[index].isChecked == 'false'
                        ? AppColors.secondaryWhiteColor
                        : AppColors.primaryGreenColor,
                    shape: isHighLighted
                        ? RoundedRectangleBorder(
                            side: BorderSide(
                                color: tasklist[index].isChecked == 'false'
                                    ? AppColors.primaryGreenColor
                                    : AppColors.secondaryGreenColor,
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
                          title: showListTitle(index),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                iconSize: 28,
                                onPressed: () {
                                  _toggleCheckbox(index);
                                  listRepository.updateListCompleted(
                                    tasklist[index].id,
                                    tasklist[index].isChecked,
                                  );
                                },
                                icon: Icon(
                                  tasklist[index].isChecked == 'true'
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: tasklist[index].isChecked == 'false'
                                      ? AppColors.primaryGreenColor
                                      : AppColors.primaryWhiteColor,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Deletar',
                                iconSize: 28,
                                onPressed: () {
                                  _showDeleteConfirmationDialog(context, index);
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: tasklist[index].isChecked == 'false'
                                      ? AppColors.primaryGreenColor
                                      : AppColors.primaryWhiteColor,
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
          const Spacer(),
          Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Showcase(
                  key: _three,
                  description: 'Clique para adicionar uma lista',
                  targetPadding: const EdgeInsets.all(5),
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
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Showcase(
                  key: _four,
                  description: 'Busque por uma lista específica',
                  targetPadding: const EdgeInsets.all(5),
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
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: AppColors.primaryGreenColor,
        leading: Builder(
          builder: (context) {
            return Showcase(
              key: _one,
              description: 'Clique para abrir o menu lateral',
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  size: 30,
                  color: AppColors.primaryWhiteColor,
                ),
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
        actions: <Widget>[
          GestureDetector(
            onTap: () => Get.to(
              () => CameraCamera(
                onFile: (file) async {
                  await showPreview(file);
                  _loadUserProfilePic();
                },
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Showcase(
                key: _two,
                description: 'Adicione sua foto',
                child: CircleAvatar(
                  key: ValueKey(uniquekey),
                  radius: 20.0,
                  backgroundImage: hasProfilePicUploaded == true
                      ? FileImage(userProfilePic)
                      : const AssetImage(
                          'lib/assets/images/generic-avatar.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: SizedBox(
        width: 270,
        child: Drawer(
          child: Container(
            color: AppColors.primaryGreenColor,
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: const SizedBox(
                    height: 70,
                    child: Text(
                      'Seja bem vindo!',
                      style: TextStyle(
                        color: AppColors.primaryWhiteColor,
                        fontFamily: AppFonts.montserrat,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  accountEmail: Row(
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                      Text(
                        userName?.isNotEmpty == true
                            ? userName!
                            : 'Insira seu nome',
                        style: const TextStyle(
                          color: AppColors.primaryWhiteColor,
                          fontFamily: AppFonts.montserrat,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _showNameEditDialog();
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.primaryWhiteColor,
                          size: 24,
                        ),
                        splashColor: AppColors.secondaryGreenColor,
                      )
                    ],
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreenColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      color: AppColors.tertiaryGreenColor,
                      child: SizedBox(
                        width: 250,
                        child: ListTile(
                          splashColor: AppColors.primaryRedColor,
                          title: const Text(
                            'Sair',
                            style: TextStyle(
                              fontFamily: AppFonts.montserrat,
                              fontSize: 16.0,
                              color: AppColors.primaryWhiteColor,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.logout,
                            color: AppColors.primaryRedColor,
                          ),
                          onTap: () => setState(
                            () {
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                context.read<AuthService>().logout();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: body,
      backgroundColor: AppColors.primaryWhiteColor,
    );
  }
}
