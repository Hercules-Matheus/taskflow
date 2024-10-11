import 'package:TaskFlow/assets/colors/app_colors.dart';
import 'package:TaskFlow/list_add/list_add_page.dart';
import 'package:flutter/material.dart';
import 'package:TaskFlow/home_page.dart';
import 'package:TaskFlow/list_add/list_add_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    HomePage.tag: (context) => const HomePage(),
    ListAddPage.tag: (context) => const ListAddPage(),
  };

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      theme: ThemeData(
        primaryColor: AppColors.primaryWhiteColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListAddPage(),
    );
  }
}
