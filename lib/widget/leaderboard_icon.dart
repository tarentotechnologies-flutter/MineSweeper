import 'package:flutter/material.dart';
import 'package:Minesweeper/pages/leaderboard_page.dart';
import 'package:Minesweeper/pages/profile_page.dart';

class LeaderboardIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.poll,
        color: Colors.white,
      ),
      onPressed: () {
        return Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LeaderboardPage(),
              ),
            );
      },
    );
  }
}
