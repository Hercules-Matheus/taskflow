// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenColor,
      ),
      backgroundColor: AppColors.primaryWhiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 200),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.montserrat,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                      letterSpacing: -1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundImage:
                        AssetImage('lib/assets/images/generic-avatar.png'),
                    backgroundColor: Colors.transparent,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
