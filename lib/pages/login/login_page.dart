// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
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

  bool isLogin = true;
  late String title;
  late String actionBtn;
  late String toggleBtn;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
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

  setFormAction(bool action) {
    setState(() {
      isLogin = action;
      if (isLogin) {
        title = 'Bem vindo';
        actionBtn = 'Login';
        toggleBtn = 'Cadastre-se';
      } else {
        title = 'Crie sua conta';
        actionBtn = 'Cadastrar';
        toggleBtn = 'Voltar ao Login';
      }
    });
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
                          title,
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
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: SvgPicture.asset(
                          'lib/assets/images/logo.svg',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24),
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
                              labelStyle: TextStyle(
                                color: _isEmailFocused
                                    ? AppColors.secondaryGreenColor
                                    : AppColors.primaryBlackColor,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o email corretamente';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(24),
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
                                return 'Sua senha deve ter no mínimo 6 caracteres';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: SizedBox(
                          width: 210,
                          child: Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: AppColors.primaryGreenColor,
                                    ),
                                  ),
                                  iconColor: WidgetStatePropertyAll(
                                      AppColors.primaryWhiteColor),
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColors.primaryWhiteColor),
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
                                  "Login",
                                  style: TextStyle(
                                    color: AppColors.primaryGreenColor,
                                    fontFamily: AppFonts.montserrat,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                      AppColors.primaryWhiteColor),
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
                width: 250,
                height: 250,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
