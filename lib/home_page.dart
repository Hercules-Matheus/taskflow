import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TaskFlow/assets/fonts/app_fonts.dart';
import 'package:TaskFlow/assets/colors/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home_page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryGreenColor,
        systemNavigationBarIconBrightness: Brightness.light));
    const transition = Hero(
      tag: 'home',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Bem Vindo'),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
      child: Column(
        children: [
          Text(
            'Listas',
            style: TextStyle(
                fontFamily: AppFonts.montserrat,
                fontWeight: FontWeight.w500,
                fontSize: 24.0),
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
              icon: Icon(
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
        actions: [
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
