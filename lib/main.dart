import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/pages/list/list_page.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/repository/tasks_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TasksRepository()), // Adiciona o TasksRepository
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    ListPage.tag: (context) => const ListPage(),
  };

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      color: AppColors.primaryWhiteColor,
      theme: ThemeData(
        primaryColor: AppColors.primaryWhiteColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ListPage(),
      routes: routes,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
    );
  }
}
