import 'package:ble_create_flutter/home/homebackup.dart';
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
      title: 'BLE_Create',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      getPages: [
        GetPage(
            name: "/",
            page: () => Home(),
            transition: Transition.cupertinoDialog),
        GetPage(
            name: "/setting",
            page: () => Setting(),
            transition: Transition.cupertino),
        GetPage(
            name: "/test",
            page: () => HomeBackUp(),
            transition: Transition.cupertino),
      ],
    );
  }
}
