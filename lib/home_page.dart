import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/list_add/list_add_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home_page';

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
              )
            ],
          ),
          const SizedBox(
            height: 300,
            child: Row(),
          ),
          const Row(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Grupos',
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
            height: 300,
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 16.0,
              backgroundImage:
                  AssetImage('lib/assets/images/generic-avatar.png'),
              backgroundColor: Colors.transparent,
            ),
          )
        ],
      ),
      body: body,
      backgroundColor: AppColors.primaryWhiteColor,
    );
  }
}
