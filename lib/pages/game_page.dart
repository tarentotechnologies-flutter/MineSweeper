import 'package:flutter/material.dart';
import 'package:Minesweeper/pages/profile_page.dart';
import 'package:Minesweeper/widget/game_board.dart';
import 'package:Minesweeper/widget/leaderboard_icon.dart';
import 'package:Minesweeper/widget/profile_icon.dart';
import 'package:Minesweeper/pages/playScreen.dart';

//covered tile = un-opened tile
enum TileState { covered, blown, open, flagged, revealed }

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Minesweeper"),
          actions: <Widget>[
//            LeaderboardIcon(),
//            ProfileIcon(),
          ],
        ),
//        body: GameBoard(),
        body: RunScreen(),
      ),
    );
  }
}
