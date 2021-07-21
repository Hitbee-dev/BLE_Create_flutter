import 'dart:async';
import 'package:BleGenerator/home/setting.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uuid = "39ED98FF-2900-441A-802F-9C398FC199D2";
  String uuid_buffer = "39ED98FF-2900-441A-802F-9C398FC199D2";
  int major = 1;
  int major_buffer = 1;
  int minor = 2;
  int minor_buffer = 2;
  int txpower = -30;
  int txpower_buffer = -30;
  String identifier = 'com.hitbee.dev';
  AdvertiseMode advertiseMode = AdvertiseMode.lowLatency;
  String layout = BeaconBroadcast.ALTBEACON_LAYOUT;
  int manufacturerId = 0x0118;
  List<int> extraData = [100];
  int starting_ble = 0;
  int logCount = 1;
  String logData = "";
  MethodChannel _testMethod =
      MethodChannel('pl.pszklarska.beaconbroadcast/beacon_state');
  static int counter = 0;

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  StreamSubscription<bool> _isAdvertisingSubscription;
  bool _isAdvertising = false;

  @override
  void initState() {
    super.initState();
    beaconBroadcast
        .checkTransmissionSupported()
        .then((isTransmissionSupported) {
      setState(() {
        // _isTransmissionSupported = isTransmissionSupported;
      });
    });

    _isAdvertisingSubscription =
        beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
      setState(() {
        _isAdvertising = isAdvertising;
      });
    });
    _StateWindows();
  }

  @override
  void dispose() {
    super.dispose();
    if (_isAdvertisingSubscription != null) {
      _isAdvertisingSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _StateWindows(),
              _SetUUID(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_SetMajor(), _SetMinor(), _SetTxPower()],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_SettingButton(), _StartButton(), _StopButton()],
              ),
              _Monitoring(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _StateWindows() {
    int state = 0;
    (_isAdvertising == false) ? state = 0 : state = 1;
    final statename = ["waiting...", "ble transmission!"];
    final stateicon = [Icons.bluetooth_disabled, Icons.bluetooth_audio];
    final statecolor = [Colors.red, Colors.green];
    final statefontcolor = [Colors.grey[600], Colors.black];

    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        children: [
          SizedBox(
            child: Container(
              width: 5,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "State : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Icon(stateicon[state], color: statecolor[state], size: 20),
          ]),
          SizedBox(
            child: Container(
              width: 5,
            ),
          ),
          Text(
            statename[state],
            style: TextStyle(fontSize: 15, color: statefontcolor[state]),
          ),
        ],
      ),
    );
  }

  Widget _SetUUID() {
    (counter == 0)
        ? uuid_buffer = uuid
        : uuid_buffer = (Get.arguments as SettingData).uuid;
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Text("UUID : ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${uuid_buffer}", style: TextStyle(fontSize: 12)),
          ],
        ));
  }

  Widget _SetMajor() {
    (counter == 0)
        ? major_buffer = major
        : major_buffer = int.parse((Get.arguments as SettingData).major);
    return Container(
        margin: const EdgeInsets.only(left: 15, bottom: 20),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Text("Major : ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text("${major_buffer}", style: TextStyle(fontSize: 11))
          ],
        ));
  }

  Widget _SetMinor() {
    (counter == 0)
        ? minor_buffer = minor
        : minor_buffer = int.parse((Get.arguments as SettingData).minor);
    return Container(
        margin: const EdgeInsets.only(left: 13, right: 13, bottom: 20),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Text("Minor : ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text("${minor_buffer}", style: TextStyle(fontSize: 11))
          ],
        ));
  }

  Widget _SetTxPower() {
    (counter == 0)
        ? txpower_buffer = txpower
        : txpower_buffer = int.parse((Get.arguments as SettingData).txpower);
    return Container(
        margin: const EdgeInsets.only(right: 15, bottom: 20),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Text("TxPower : ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text("${txpower_buffer}", style: TextStyle(fontSize: 11))
          ],
        ));
  }

  Widget _SettingButton() {
    return RaisedButton(
      onPressed: () {
        Get.offNamed("/setting");
        counter = 1;
      },
      child: Text('Setting'),
    );
  }

  Widget _StartButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            _beaconTrans();
            (starting_ble == 0) ? logData += "-----Beacon_start-----\n" : null;
            starting_ble = 1;
            logData += "${logCount}. Sending..\n";
            logCount++;
          });
        },
        child: Text('START'),
      ),
    );
  }

  Widget _StopButton() {
    return RaisedButton(
      onPressed: () {
        beaconBroadcast.stop();
        setState(() {
          starting_ble = 0;
          logData += "-----Beacon_cancle-----\n";
        });
      },
      child: Text('STOP'),
    );
  }

  Widget _Monitoring() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 25.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10),
              width: 300,
              child: Text(
                "Log Terminal",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
          Container(
            width: 100,
            margin: EdgeInsets.only(bottom: 10),
            height: 2,
            color: Colors.black,
          ),
          Container(
            width: 300,
            height: 400,
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("${logData}", style: TextStyle(fontSize: 15)),
              ),
            ),
          )
        ]),
      ),
    );
  }

  _beaconTrans() async {
    return await beaconBroadcast
        .setUUID(uuid_buffer)
        .setMajorId(major_buffer)
        .setMinorId(minor_buffer)
        .setTransmissionPower(txpower_buffer)
        .setAdvertiseMode(advertiseMode)
        .setLayout(layout)
        // .setIdentifier(identifier)
        .setManufacturerId(manufacturerId)
        // .setExtraData(extraData)
        .start();
  }
}
