import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';

class Setting extends StatefulWidget {
  const Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String initUUID = "";
  String randomUUID = (Uuid()).v4();
  TextEditingController saved_uuid;
  TextEditingController saved_major;
  TextEditingController saved_minor;
  TextEditingController saved_txpower;

  @override
  void initState() {
    super.initState();
    this.saved_uuid = TextEditingController();
    this.saved_major = TextEditingController();
    this.saved_minor = TextEditingController();
    this.saved_txpower = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusManager.instance.primaryFocus?.unfocus(), //화면 아무데나 터치해서 내리기
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _UUIDLayout(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _MajorLayout(),
                  _MinorLayout(),
                  _TxPowerLayout()
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_RandomUUIDButton(), _SaveButton()]),
                _txpowerInfo()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _UUIDLayout() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 50,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          hintText: '00000000-0000-0000-0000-000000000000',
          hintStyle: TextStyle(fontSize: 13),
          labelText: 'UUID',
          labelStyle:
              TextStyle(color: Colors.black, decorationColor: Colors.black),
        ),
        keyboardType: TextInputType.datetime,
        controller: this.saved_uuid,
      ),
    );
  }

  Widget _MajorLayout() {
    return Container(
      height: 70,
      width: 100,
      padding: EdgeInsets.only(left: 5, top: 20),
      child: TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2)),
          hintText: '1 ~ 65535',
          hintStyle: TextStyle(fontSize: 13),
          labelText: 'Major',
          labelStyle:
              TextStyle(color: Colors.black, decorationColor: Colors.black),
        ),
        keyboardType: TextInputType.number,
        controller: saved_major,
      ),
    );
  }

  Widget _MinorLayout() {
    return Container(
      height: 70,
      width: 100,
      padding: EdgeInsets.only(left: 5, right: 5, top: 20),
      child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2)),
            hintText: '1 ~ 65535',
            hintStyle: TextStyle(fontSize: 13),
            labelText: 'Minor',
            labelStyle:
                TextStyle(color: Colors.black, decorationColor: Colors.black),
          ),
          keyboardType: TextInputType.number,
          controller: saved_minor),
    );
  }

  Widget _TxPowerLayout() {
    return Container(
      height: 70,
      width: 100,
      padding: EdgeInsets.only(right: 5, top: 20),
      child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2)),
            hintStyle: TextStyle(fontSize: 13),
            hintText: "-30",
            suffixText: "dBm",
            labelText: 'TxPower',
            labelStyle:
                TextStyle(color: Colors.black, decorationColor: Colors.black),
          ),
          keyboardType:
              TextInputType.numberWithOptions(decimal: true, signed: true),
          controller: saved_txpower),
    );
  }

  Widget _RandomUUIDButton() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 20, top: 20),
      child: RaisedButton(
          child: Text("Random UUID"),
          onPressed: () {
            setState(() {
              saved_uuid.text = randomUUID;
            });
          }),
    );
  }

  Widget _SaveButton() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 5, top: 20),
      child: RaisedButton(
          child: Text("Save"),
          onPressed: () {
            setState(() {
              if (saved_uuid.text == "") {
                SnackPrint("Please enter the value of uuid");
              } else if (saved_major.text == "") {
                SnackPrint("Please enter the value of major");
              } else if (saved_minor.text == "") {
                SnackPrint("Please enter the value of minor");
              } else if (saved_txpower.text == "") {
                SnackPrint("Please enter the value of txpower");
              } else {
                Get.offAllNamed("/",
                    arguments: SettingData(
                        uuid: saved_uuid.text,
                        major: saved_major.text,
                        minor: saved_minor.text,
                        txpower: saved_txpower.text));
              }
            });
          }),
    );
  }

  Widget _txpowerInfo() {
    return Container(
      margin: EdgeInsets.only(left: 50, right: 50, top: 40, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.black, width: 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 30, top: 20, bottom: 20),
            child: Column(children: [
              Text("TxPower",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                  padding: EdgeInsets.only(top: 20), child: Text("-30dBm")),
              Container(
                  padding: EdgeInsets.only(top: 20), child: Text("-20dBm")),
              Container(
                  padding: EdgeInsets.only(top: 20), child: Text("-16dBm")),
              Container(
                  padding: EdgeInsets.only(top: 20), child: Text("-12dBm")),
              Container(
                  padding: EdgeInsets.only(top: 20), child: Text("-8dBm")),
              Container(
                  padding: EdgeInsets.only(top: 20), child: Text("-4dBm")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("0dBm")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("4dBm")),
            ]),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, top: 20, bottom: 20),
            child: Column(children: [
              Text("Meter",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(padding: EdgeInsets.only(top: 20), child: Text("2M")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("4M")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("10M")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("20M")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("30M")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("40M")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("60M")),
              Container(padding: EdgeInsets.only(top: 20), child: Text("70M")),
            ]),
          )
        ],
      ),
    );
  }

  SnackPrint(String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Done',
        onPressed: () {},
      ),
    ));
  }
}

class SettingData {
  String uuid;
  String major;
  String minor;
  String txpower;

  SettingData({this.uuid, this.major, this.minor, this.txpower});
}
