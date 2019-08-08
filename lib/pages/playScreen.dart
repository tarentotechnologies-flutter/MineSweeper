import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:Minesweeper/pages/Settings.dart';
import 'package:Minesweeper/widget/game_board.dart';

void main() {
  runApp(MaterialApp(
    home: RunScreen(),
  ));
}


class RunScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return RunScreenState();
  }
}

class RunScreenState extends State<RunScreen> {
 var Choice = 'Medium';
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }


  onDoneLoading() async {
//    Navigator.of(context).pushReplacement(
//        MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 85.0,
                  child: IconButton(
                    icon: Icon(Icons.play_circle_filled, size: 50.0, color: Colors.deepOrange),
                      onPressed: () {
                      setState(() {
                        Navigator.push(
                         context,
                          MaterialPageRoute(
                          builder: (context) => GameBoard(Level: Choice),
                        )
                        );
                      });
                      }
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                Text(
                  'Play Mine Sweeper',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100.0),
                ),
                Row(
                  children: <Widget>[
                    _ShareFacebook(),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    _SharewhatsApp(),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    _ShareTwitter(),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    _Settings(),
                  ],

                )
              ],
            ),
          ]
      ),
    );
  }


  _ShareFacebook() {
    return Container(
      height: 60.0,
      width: 60.0,
//      padding: EdgeInsets.only(right: 40.0),
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: new Image(
              image: new AssetImage('assets/images/facebook_circle.png'),
              color: null, width: 100, height: 100)
      ),
    );
  }

  _SharewhatsApp() {
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
//        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: new Image(image: new AssetImage('assets/images/twitter.png'),
              color: null, width: 100, height: 100)
      ),
    );
  }

  _Settings() {
    return Container(

      height: 70.0,
      width: 70.0,
      decoration: BoxDecoration(
//      color: Colors.green,
        shape: BoxShape.circle,

//        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: GestureDetector(
          onTap: () => SettingsPageNav(),
            child: new Image(image: new AssetImage('assets/images/settings.png'),
              color: null, width: 100, height: 100)
      ),
    );
  }
  _ShareTwitter() {
    return Container(
      height: 80.0,
      width: 80.0,
      decoration: BoxDecoration(
//      color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: new Image(image: new AssetImage('assets/images/whatsapp.png'),
              color: null, width: 100, height: 100)
      ),
    );
  }



  SettingsPageNav() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Settings(),
      ),
    );
  }
}

//class HomeScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(
//        child: Text('Welcome to Homescreen', style: TextStyle(fontSize: 24.0),),
//      ),
//    );
//  }
//}
