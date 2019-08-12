import 'package:Minesweeper/pages/Settings.dart';
import 'package:Minesweeper/widget/game_board.dart';
import 'package:flutter/material.dart';
import 'dart:async';
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Minesweeper"),
      ),
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundColor: Colors.black38,
                radius: 40.0,
                child:
                ButtonTheme(
                  buttonColor: Colors.black38,
                  // minWidth: 100.0,
                  height: 150.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>GameBoard(Level: Choice),
                            )
                        );
                      });
                    },
                    child: Image.asset('assets/images/playred.png'),
                  ),
                )
            ),
            // Image.asset('assets/giphy.gif'),
            Padding(
                padding: EdgeInsets.all(15),
                child: Text('Play Mine Sweeper',  style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  fontSize: 25,
                ),)
            )
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
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _ShareFacebook(),
                _SharewhatsApp(),
                _ShareTwitter(),
                _Settings(),
              ],
            )
        ),
      ),
    );
  }
  _ShareFacebook() {
    return Container(
      height: 70.0,
      width: 70.0,
//      padding: EdgeInsets.only(right: 40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: new Image(
              image: new AssetImage('assets/images/facebook.png'),
              color: null, width: 100, height: 100)
      ),
    );
  }
  _SharewhatsApp() {
    return Container(
      height: 70.0,
      width: 70.0,
      decoration: BoxDecoration(
//        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: new Image(image: new AssetImage('assets/images/whatapp.png'),
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
          child: new Image(image: new AssetImage('assets/images/setting.png'),
              color: null, width: 100, height: 100)
      ),
    );
  }
  _ShareTwitter() {
    return Container(
      height: 70.0,
      width: 70.0,
      decoration: BoxDecoration(
//      color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: new Image(image: new AssetImage('assets/images/twitter.png'),
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