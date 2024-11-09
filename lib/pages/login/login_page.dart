// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/services/auth_service.dart';
import 'package:taskflow/services/social_login.dart';
import 'package:taskflow/pages/list/list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isPasswordFocused = false;
  bool _isEmailFocused = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
  }

  signin(BuildContext context) async {
    try {
      await context.read<AuthService>().signin(email.text, password.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  signup(BuildContext context) async {
    try {
      await context.read<AuthService>().signup(email.text, password.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.primaryGreenColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: AppColors.primaryGreenColor,
          statusBarBrightness: Brightness.light,
        ),
      ),
      backgroundColor: AppColors.primaryWhiteColor,
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 200, bottom: 20),
                        child: Text(
                          'Bem vindo',
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: SvgPicture.asset(
                          'lib/assets/images/logo.svg',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          width: 210,
                          child: TextFormField(
                            controller: email,
                            focusNode: _emailFocusNode,
                            cursorColor: AppColors.secondaryGreenColor,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.secondaryWhiteColor,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondaryGreenColor,
                                ),
                              ),
                              labelText: 'Email',
                              helperText: 'Digite seu email',
                              labelStyle: TextStyle(
                                color: _isEmailFocused
                                    ? AppColors.secondaryGreenColor
                                    : AppColors.primaryBlackColor,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o email corretamente.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: SizedBox(
                          width: 210,
                          child: TextFormField(
                            controller: password,
                            focusNode: _passwordFocusNode,
                            cursorColor: AppColors.secondaryGreenColor,
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.secondaryWhiteColor,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondaryGreenColor,
                                ),
                              ),
                              labelText: 'Senha',
                              helperText: 'Digite sua senha',
                              labelStyle: TextStyle(
                                color: _isPasswordFocused
                                    ? AppColors.secondaryGreenColor
                                    : AppColors.primaryBlackColor,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe sua senha!';
                              } else if (value.length < 6) {
                                return 'Mínimo de 6 caracteres.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: SizedBox(
                          width: 210,
                          child: Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    signin(context);
                                  }
                                },
                                style: const ButtonStyle(
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: AppColors.primaryGreenColor,
                                    ),
                                  ),
                                  iconColor: WidgetStatePropertyAll(
                                    AppColors.primaryWhiteColor,
                                  ),
                                  overlayColor: WidgetStatePropertyAll(
                                    AppColors.tertiaryGreenColor,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    AppColors.primaryWhiteColor,
                                  ),
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 15.0,
                                      bottom: 15.0,
                                    ),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: AppColors.primaryGreenColor,
                                    fontFamily: AppFonts.montserrat,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    signup(context);
                                  }
                                },
                                style: const ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                      AppColors.primaryWhiteColor),
                                  overlayColor: WidgetStatePropertyAll(
                                    AppColors.secondaryGreenColor,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColors.primaryGreenColor),
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 15.0,
                                        bottom: 15.0),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Cadastre-se",
                                  style: TextStyle(
                                    color: AppColors.primaryWhiteColor,
                                    fontFamily: AppFonts.montserrat,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          bottom: 10.0,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Esqueceu a senha?",
                            style: TextStyle(
                              fontFamily: AppFonts.montserrat,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                              color: AppColors.secondaryBlackColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              UserCredential userCredential =
                                  await signInWithGoogle();
                              // ignore: unnecessary_null_comparison
                              if (userCredential != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListPage(),
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint("Erro durante o login: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("Erro ao fazer login com Google."),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            elevation: WidgetStatePropertyAll(0.0),
                            shape: WidgetStatePropertyAll(CircleBorder()),
                            padding: WidgetStatePropertyAll(
                              EdgeInsets.all(8.0),
                            ),
                            overlayColor: WidgetStatePropertyAll(
                                AppColors.tertiaryGreenColor),
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                          ),
                          child: Image.asset(
                            "lib/assets/images/google.png",
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                'lib/assets/images/to_do_list.svg',
                width: 230,
                height: 230,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
