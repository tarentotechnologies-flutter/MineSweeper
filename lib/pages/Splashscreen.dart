import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:Minesweeper/pages/playScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    Timer(
        Duration(seconds: 6),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => RunScreen())));
  }
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
  Widget _infoTile(String title, String subtitle, {TextStyle style}) {
    return ListTile(
      title: Text(title,textAlign: TextAlign.center,),
      subtitle: Text(subtitle ?? 'Not set',textAlign: TextAlign.center,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/giphy.gif'),
            Text("MINE SWIPEER",  style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 25,
            ),)
          ],
        ),
      ),
      bottomSheet:Container(
        color: Colors.white,
        // margin: const EdgeInsets.only(top: 0, left: 50, right: 50,bottom:0),
        height:145,
        child: Center(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
            child:Column(
              children: <Widget>[
                _infoTile('App version', _packageInfo.version),
                _infoTile('Powered by:','Tarento Technologies',style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: 05,
                )),
              ],
            )
        ),
      ),
    );
  }
}