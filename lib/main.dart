import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/pages/list/list_page.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/repository/list_repository.dart';
import 'package:taskflow/repository/tasks_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:taskflow/widget/auth_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('pt_BR', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => TasksRepository()),
        ChangeNotifierProvider(
          create: (context) => ListRepository(
            auth: context.read<AuthService>(),
          ),
        ), // Adiciona o TasksRepository
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
    return ShowCaseWidget(
      blurValue: 1,
      autoPlayDelay: const Duration(seconds: 2),
      builder: (context) => MaterialApp(
        title: 'TaskFlow',
        color: AppColors.primaryWhiteColor,
        theme: ThemeData(
          primaryColor: AppColors.primaryWhiteColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthCheck(),
        routes: routes,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
      ),
    );
  }
}
