import 'package:TaskFlow/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:TaskFlow/assets/fonts/app_fonts.dart';
import 'package:TaskFlow/assets/colors/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  './lib/assets/images/logo.svg',
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
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: EdgeInsets.all(10.0),
            width: 250,
            height: 200,
            child: Column(
              textDirection: TextDirection.ltr,
              children: <Widget>[
                Row(
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
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          // controller: listNameController,
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Digite aqui',
                            hintStyle: TextStyle(
                              color: AppColors.primaryBlackColor,
                              fontFamily: AppFonts.montserrat,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                            ),
                            hoverColor: AppColors.secondaryGreenColor,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: AppColors.secondaryGreenColor,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Lógica de salvar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          color: AppColors.secondaryGreenColor,
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
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                './lib/assets/images/to_do_list.svg',
                width: 200,
                height: 200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
