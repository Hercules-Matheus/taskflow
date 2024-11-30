import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/pages/login/login_page.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecoverPassword createState() => _RecoverPassword();
}

class _RecoverPassword extends State<RecoverPassword> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
  }

  Future<void> _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: Transform.rotate(
                angle: 3.14 / 12,
                child: const Icon(
                  Icons.send,
                  size: 30,
                  color: AppColors.primaryGreenColor,
                ),
              ),
              title: const Text(
                "Email enviado",
                style: TextStyle(
                  fontFamily: AppFonts.montserrat,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: const Text(
                "Confira seu email e redefina sua senha",
                style: TextStyle(
                  fontFamily: AppFonts.montserrat,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: const ButtonStyle(
                      iconColor:
                          WidgetStatePropertyAll(AppColors.primaryWhiteColor),
                      overlayColor: WidgetStatePropertyAll(
                        AppColors.secondaryGreenColor,
                      ),
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primaryGreenColor),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Retornar ao login",
                      style: TextStyle(
                        fontFamily: AppFonts.montserrat,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Email de redefinição de senha enviado.'),
      //   ),
      // );
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: const Icon(
                Icons.report,
                size: 30,
                color: AppColors.primaryRedColor,
              ),
              title: const Text(
                "Ops...",
                style: TextStyle(
                  fontFamily: AppFonts.montserrat,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: const Text(
                "Erro ao enviar email de redefinição",
                style: TextStyle(
                  fontFamily: AppFonts.montserrat,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: const ButtonStyle(
                      iconColor:
                          WidgetStatePropertyAll(AppColors.primaryWhiteColor),
                      overlayColor: WidgetStatePropertyAll(
                        AppColors.primaryRedColor,
                      ),
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primaryGreenColor),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0, bottom: 15.0),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Fechar",
                      style: TextStyle(
                        fontFamily: AppFonts.montserrat,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Erro ao enviar email de redefinição de senha: $e'),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.primaryGreenColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: AppColors.primaryGreenColor,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.navigate_before,
            size: 30,
            color: AppColors.primaryWhiteColor,
          ),
        ),
      ),
      backgroundColor: AppColors.primaryWhiteColor,
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 200, bottom: 20),
                            child: Text(
                              'Redefinir senha',
                              style: TextStyle(
                                fontFamily: AppFonts.montserrat,
                                fontWeight: FontWeight.w500,
                                fontSize: 24.0,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10.0,
                            ),
                            child: SvgPicture.asset(
                              'lib/assets/images/logo.svg',
                              width: 70,
                              height: 70,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: 210,
                              child: TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                cursorColor: AppColors.secondaryGreenColor,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.secondaryWhiteColor,
                                  focusedBorder: const OutlineInputBorder(
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
                          const Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  right: 120.0,
                                  bottom: 35.0,
                                  left: 120.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                textDirection: TextDirection.ltr,
                                children: <Widget>[
                                  Text(
                                    'Preencha o campo acima com o email usado para realizar seu cadastro, caso o email exista e seja válido, você receberá uma mensagem com o link para redefinir a sua senha',
                                    style: TextStyle(
                                      fontFamily: AppFonts.montserrat,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryBlackColor,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    _sendPasswordResetEmail();
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
                                child: const Text(
                                  "Enviar",
                                  style: TextStyle(
                                    color: AppColors.primaryWhiteColor,
                                    fontFamily: AppFonts.montserrat,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
