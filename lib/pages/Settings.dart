import 'package:flutter/material.dart';
import 'package:Minesweeper/pages/profile_page.dart';
import 'package:Minesweeper/widget/game_board.dart';
import 'package:Minesweeper/widget/leaderboard_icon.dart';
import 'package:Minesweeper/widget/profile_icon.dart';
import 'package:Minesweeper/pages/playScreen.dart';
import 'package:toast/toast.dart';



class Settings extends StatefulWidget {
  HomePage createState() => HomePage();
}
class HomePage extends State<Settings> {

  String _radioValue = 'two'; //Initial definition of radio button value
  String choice;

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Easy':
          choice = value;
          break;
        case 'Medium':
          choice = value;
          break;
        case 'Hard':
          choice = value;
          break;
        default:
          choice = null;
      }
      debugPrint(choice);
      //Debug the choice in console
    });
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Settings"),
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        body: new Container(
//          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(20.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Please select a level :',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),

              Row(
                children: <Widget>[
                  Radio(
                    value: 'Easy',
                    groupValue: _radioValue,
                    onChanged: radioButtonChanges,
                  ),
                  new Text(
                    'Easy',
                    style: new TextStyle(
                        fontSize: 16.0),
                  ),
                  Radio(
                    value: 'Medium',
                    groupValue: _radioValue,
                    onChanged: radioButtonChanges,
                  ),
                  new Text(
                    'Medium',
                    style: new TextStyle(
                        fontSize: 16.0),
                  ),
                  Radio(
                    value: 'Hard',
                    groupValue: _radioValue,
                    onChanged: radioButtonChanges,
                  ),
                  new Text(
                    'Hard',
                    style: new TextStyle(
                        fontSize: 16.0),
                  ),
                  new Divider(
                height: 5.0,
                color: Colors.black,
              ),

//         new Icon(Icons.add),
//          onPressed: () { setState(); },


                ],
              ),
              new Divider(
                height: 50.0,
                color: Colors.black,
              ),
           Container(

        height: 70.0,
        width: 70.0,
            decoration: BoxDecoration(
//      color: Colors.green,
            shape: BoxShape.circle,
              color: Colors.black

        ),
             child: IconButton(
               icon: Icon(Icons.arrow_forward_ios, size: 30.0, color: Colors.white),
               tooltip: 'Increase volume by 10',
               onPressed: () {
                 setState(() {
                   if(choice != null) {
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => GameBoard(Level: choice),
                       ),
                     );
                   } else {
                     Toast.show("Please choose level", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                                 }
                 });
               },
             ),
           ),
            ],
          ),
        ),
      ),


    );
  }

  void switchListener(bool val) {

  }


}
