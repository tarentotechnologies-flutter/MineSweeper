import 'package:Minesweeper/pages/Settings.dart';
import 'package:Minesweeper/widget/game_board.dart';
import 'package:Minesweeper/widget/leaderboard_icon.dart';
import 'package:Minesweeper/widget/profile_icon.dart';
import 'package:flutter/material.dart';
//import 'package:social_login/social_login.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'dart:async';
//final facebookLogin = FacebookLogin();

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
  bool isLoggedin = false;
  Map userProfile;
  var Choice;

  var name;
  var email;

   var url;

  // Instantiate it
//  final socialLogin = SocialLogin();

//Before calling any methods, set the configuration

  @override
  void initState() {
    //Before calling any methods, set the configuration
//    socialLogin.setConfig(SocialConfig(
//      facebookAppId: '340530816825687',
//    ),

//    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Minesweeper"),
        actions: <Widget>[
          LeaderboardIcon(),
          ProfileIcon(),
        ],
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
//    final FacebookUser facebookUser = await socialLogin.logInFacebookWithPermissions(FacebookPermissions.DEFAULT);
//    print(facebookUser);
    return Container(
      height: 120.0,
      width: 90.0,
//      padding: EdgeInsets.only(right: 40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: isLoggedin ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(userProfile["picture"]["data"]["url"], height: 50.0, width: 50.0,),
              Text(userProfile["name"]),
              OutlineButton( child: Text("Logout"), onPressed: (){
                _logout();
              },)
            ],
          ): OutlineButton(child: Text('Login With Facebook'),
              onPressed: (){
//                _loginWithFB();
              }),
//          child: new Image(
//              image: new AssetImage('assets/images/facebook.png'),
//              color: null, width: 100, height: 100)
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

  void _logout() {
//    facebookLogin.logOut();
    setState(() {
      isLoggedin = false;
    });
  }

//  void _loginWithFB() async {
//    final result = await facebookLogin.logInWithReadPermissions(['email']);
//
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        final token = result.accessToken.token;
//        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
//        final profile = JSON.jsonDecode(graphResponse.body);
//        print(profile);
//        setState(() {
//          userProfile = profile;
//          name = userProfile['name'];
//          email = userProfile['email'];
//          url = userProfile["picture"]["data"]["url"].toString();
//          print(url);
//          isLoggedin = true;
//        });
//        break;
//
//      case FacebookLoginStatus.cancelledByUser:
//        setState(() => isLoggedin = false );
//        break;
//      case FacebookLoginStatus.error:
//        setState(() => isLoggedin = false );
//        break;
//    }
//  }
}