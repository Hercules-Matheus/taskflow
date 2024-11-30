import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskflow/repository/list_repository.dart';
import 'package:taskflow/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:taskflow/pages/list/list_page.dart';
import 'package:taskflow/widget/auth_check.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taskflow/assets/colors/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('pt_BR', null);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, ListRepository>(
          create: (context) => ListRepository(
              authService: Provider.of<AuthService>(context, listen: false)),
          update: (context, authService, listRepository) =>
              listRepository!..update(authService),
        ),
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
      builder: (context) => GetMaterialApp(
          title: 'TaskFlow',
          color: AppColors.primaryWhiteColor,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: AppColors.primaryWhiteColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AuthCheck(),
          routes: routes,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('pt', 'BR'),
          ]),
    );
  }
}
