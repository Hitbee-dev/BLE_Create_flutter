import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
        // GetPage(
        //     name: "/first",
        //     page: () => FirstNamedHome(),
        //     transition: Transition.cupertino),
      ],
    );
  }
}
