import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/pages/list/list_page.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:taskflow/pages/login/login_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  AuthCheckState createState() => AuthCheckState();
}

class AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.localUser == null) {
      return const LoginPage();
    } else {
      return const ListPage();
    }
  }
}

loading() {
  return const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
