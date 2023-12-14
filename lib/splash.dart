import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lecture_1_app/login.dart';
import 'package:lecture_1_app/main.dart';
import 'package:lecture_1_app/service/service.dart';

class SplashScreen extends StatefulWidget {
  final AbstractService service;
  const SplashScreen(this.service, {Key? key}) : super(key: key);
  get isLogged async => await service.isLogged();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      if (widget.isLogged) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(widget.service)));
      }
    });
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            const Column(
              children: [
                Text('Flutter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
              ],
            ),
            Text('Бухалов Николай, 211-323', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)
          ],
        )
      )
    );
  }
}
