import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home/home.dart';
import 'home/setting.dart';

void main() {
  runApp(BLECreate());
}

class BLECreate extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BleGenerator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      getPages: [
        GetPage(
            name: "/",
            page: () => Home(),
            transition: Transition.rightToLeftWithFade),
        GetPage(
            name: "/setting",
            page: () => Setting(),
            transition: Transition.leftToRightWithFade),
      ],
    );
  }
}
