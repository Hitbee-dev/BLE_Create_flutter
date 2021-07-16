import 'dart:async';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String uuid = '39ED98FF-2900-441A-802F-9C398FC199D2';
  static const int majorId = 1;
  static const int minorId = 100;
  static const int transmissionPower = -59;
  static const String identifier = 'com.hitbee.dev';
  static const AdvertiseMode advertiseMode = AdvertiseMode.lowLatency;
  static const String layout = BeaconBroadcast.ALTBEACON_LAYOUT;
  static const int manufacturerId = 0x0118;
  static const List<int> extraData = [100];
  int starting_ble = 0;

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();
  StreamSubscription<bool> _isAdvertisingSubscription;
  BeaconStatus _isTransmissionSupported;
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
        // _isAdvertising = isAdvertising;
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
    int check = 0;
    (starting_ble == 0) ? check = 0 : check = 1;
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
            Icon(stateicon[check], color: statecolor[check], size: 20),
          ]),
          SizedBox(
            child: Container(
              width: 5,
            ),
          ),
          Text(
            statename[check],
            style: TextStyle(fontSize: 15, color: statefontcolor[check]),
          ),
        ],
      ),
    );
  }

  Widget _SetUUID() {
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Text("UUID : ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${uuid}", style: TextStyle(fontSize: 12))
          ],
        ));
  }

  Widget _SetMajor() {
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
            Text("${majorId}", style: TextStyle(fontSize: 11))
          ],
        ));
  }

  Widget _SetMinor() {
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
            Text("${minorId}", style: TextStyle(fontSize: 11))
          ],
        ));
  }

  Widget _SetTxPower() {
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
            Text("${transmissionPower}", style: TextStyle(fontSize: 11))
          ],
        ));
  }

  Widget _SettingButton() {
    return RaisedButton(
      onPressed: () {
        Get.toNamed("/setting");
      },
      child: Text('Setting'),
    );
  }

  Widget _StartButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: RaisedButton(
        onPressed: () {
          beaconBroadcast
              .setUUID(uuid)
              .setMajorId(majorId)
              .setMinorId(minorId)
              .setTransmissionPower(transmissionPower)
              .setAdvertiseMode(advertiseMode)
              .setIdentifier(identifier)
              .setLayout(layout)
              .setManufacturerId(manufacturerId)
              .setExtraData(extraData)
              .start();
          starting_ble = 1;
        },
        child: Text('START'),
      ),
    );
  }

  Widget _StopButton() {
    return RaisedButton(
      onPressed: () {
        beaconBroadcast.stop();
        starting_ble = 0;
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
                child: Text(
                    "test\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\ntest\n",
                    style: TextStyle(fontSize: 15)),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
