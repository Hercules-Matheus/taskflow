import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskflow/assets/fonts/app_fonts.dart';
import 'package:taskflow/assets/colors/app_colors.dart';

class ListAddPage extends StatelessWidget {
  static String tag = 'list_add_page';

  const ListAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primaryGreenColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenColor,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: AppColors.primaryWhiteColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      'lib/assets/images/logo.svg',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondaryWhiteColor,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondaryBlackColor.withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Text(
                          'Nome da lista',
                          style: TextStyle(
                            color: AppColors.primaryGreenColor,
                            fontFamily: AppFonts.montserrat,
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              cursorColor: AppColors.secondaryGreenColor,
                              style: const TextStyle(
                                color: AppColors.primaryBlackColor,
                                fontFamily: AppFonts.montserrat,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondaryGreenColor,
                                  ),
                                ),
                                hintText: 'Digite aqui',
                                hintStyle: TextStyle(
                                  color: AppColors.primaryBlackColor,
                                  fontFamily: AppFonts.montserrat,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InputDatePickerFormField(
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: AppColors.primaryGreenColor,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Lógica de salvar
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Salvar',
                            style: TextStyle(
                              color: AppColors.primaryGreenColor,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
