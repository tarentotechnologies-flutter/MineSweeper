import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
//import 'package:Minesweeper/pages/profile_page.dart';
import 'package:Minesweeper/widget/game_board.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:Minesweeper/main.dart';

import 'package:package_info/package_info.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:toast/toast.dart';


class Settings extends StatefulWidget {
//  get analytics => null;

  HomePage createState() => HomePage();
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}
class HomePage extends State<Settings> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);




  Future<void> _sendAnalytics() async {
    await analytics.logEvent(
      name: 'Playbutton Clicked',
      parameters: <String, dynamic>{
        'eventCategory': 'ButtonClick',
        'eventAction': 'ScreenInteraction',
        'eventLabel': 'Play',
        'fieldsObject': 'interaction',
      },
    );
  }

  Future<void> _testSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Settings PAge',
      screenClassOverride: 'AnalyticsDemo',
    );

  }

  Future<void> _testSetSessionTimeoutDuration() async {
    await analytics.android?.setSessionTimeoutDuration(1000);
  }

  PackageInfo _packageInfo = PackageInfo(
    //appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    // buildNumber: 'Unknown',
  );

  String _radioValue="Medium" ; //Initial definition of radio button value
  String choice='Medium';
  @override
  void initState() {

    setState(() {
      _initPackageInfo();
      _radioValue ="Medium";
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _testSetSessionTimeoutDuration();

    //this method not called when user press android back button or quit
    print('dispose');
  }

//  Future<Null> _currentScreen() async {
//    await widget.analytics.setCurrentScreen(
//        screenName: 'Settings', screenClassOverride: 'HomePage');
//  }


//  Future<Null> _sendAnalytics() async {
//    await widget.analytics
//        .logEvent(name: 'full_screen_tapped', parameters: <String, dynamic>{});
//  }

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
  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Easy':
          choice = value;
          break;
        case 'Medium':
          choice=value;
          break;
        case 'Hard':
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        body:
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(100,40, 100, 0),
                child: Image.asset(
                  'assets/images/bomb.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20,40, 20, 0),
                child: Image.asset(
                  'assets/images/mindsweeper-text.png',
                  //fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20,20, 20, 0),
    ),
              GestureDetector(
                  // tooltip: 'Increase volume by 10',
                    onTap: () {
                      setState(() {
                        print("MINE--------->");
                        print(analytics.toString());
                        analytics.logEvent(
                          name: 'PLAY_ACTION',
                          parameters: <String, dynamic>{

                          },
                        );

//                        _sendAnalytics();
//                        _testSetCurrentScreen();
                        if(choice != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameBoard(Level: choice),
                            ),
                          );
                        } else {
                          Toast.show("Please choose level", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER,);
                        }
                      }
                      );
                    },
                    child: new Image(image: new AssetImage('assets/images/play.png'),
                        height: 100
                    )
                ),
//              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),

                GradientText("Please select a level :",
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end:Alignment.center ,
                        //end: Alignment.bottomCenter,
                        colors: [Colors.deepOrange[500], Colors.deepOrange[100], Colors.deepOrange]
                    ),
                    style: TextStyle(fontSize:18),
                    textAlign: TextAlign.center),

              Padding(
                padding: EdgeInsets.all(20),
                child: Theme(
                  data: ThemeData.dark(),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Radio(
                      value: 'Easy',
                      activeColor: Colors.red,
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),
                    GradientText(
                      "Easy",
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end:Alignment.center ,
                          //end: Alignment.bottomCenter,
                          colors: [Colors.deepOrange[500],  Colors.deepOrange]
                      ),
                    ),
                    Radio(
                      activeColor: Colors.red,

                      value: 'Medium',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),
                    GradientText(
                      "Medium",
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end:Alignment.center ,
                          //end: Alignment.bottomCenter,
                          colors: [Colors.deepOrange[500],  Colors.deepOrange]
                      ),
                    ),
                    Radio(
                      activeColor: Colors.red,

                      value: 'Hard',
                      groupValue: _radioValue,
                      onChanged: radioButtonChanges,
                    ),
                    GradientText(
                      "Hard",
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end:Alignment.center ,
                          //end: Alignment.bottomCenter,
                          colors: [Colors.deepOrange[500],  Colors.deepOrange]
                      ),
                    ),
                  ],
                ),
                )
              ),
              Center(
                child: IconButton(
                  onPressed: (){
//                    _sendAnalytics;
                    _share();
                    },
                  icon: Icon(Icons.share, size: 35.0, color: Colors.deepOrange),
                  tooltip: 'Increase volume by 10',
                ),
              )
            ]
        ),
        bottomSheet:Container(
          color: Colors.white,
          height:52,
          child: Center(
              child:Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('App version'),
                          Text(_packageInfo.version.toString())
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Powered by:'),
                              Text('Tarento Technologies',style: TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                //fit: BoxFit.cover,
                                // letterSpacing: 0.5,
                                fontSize: 15,
                              ))
                            ]
                        ),
                      )

                    ],
                  )

                ],
              )
          ),
        ),
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
  void switchListener(bool val) {
  }

  void _share() {
    print('ehjfduyv');
    setState(() {
      analytics.logEvent(
        name: 'SocialShare_ACTION',
        parameters: <String, dynamic>{

        },
      );
    });

    Share.share('Welcome to Minesweeper Game');
  }


}