import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home_page';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF06616E),
        systemNavigationBarIconBrightness: Brightness.light
      )
    );
    const transition = Hero(
      tag: 'home',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Bem Vindo'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF06616E),
        centerTitle: true,
        title: const Text(
          'Sera substituido pela logo',
          style: TextStyle(color: Color(0xFFE7EAEF)),
          ),
      ),
      body: Center(
        child: Text('Conteudo da tela aqui'),
      ),
      backgroundColor: Color(0xFFE7EAEF),
      
    );
  }
}