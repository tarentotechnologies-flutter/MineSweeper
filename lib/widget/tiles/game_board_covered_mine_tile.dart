import 'package:flutter/material.dart';
import 'package:Minesweeper/widget/tiles/game_board_inner_tile.dart';
import 'package:Minesweeper/widget/tiles/game_board_tile.dart';

/*
CoveredMineTile = Flagged Tile or Un-flagged tile, both un-opened
 */
class CoveredMineTile extends StatelessWidget {
  final bool flagged;
  final int posX;
  final int posY;

  CoveredMineTile({this.flagged, this.posX, this.posY});

  @override
  Widget build(BuildContext context) {
    return Tile(
      child: InnerTile(
        child: flagged
            ? Center(
            child:Image.asset(
          'assets/images/flag.png',
          fit: BoxFit.cover,
        )

//                RichText(
//                  textAlign: TextAlign.center,
//                  text: TextSpan(
//                    text: "\u2690",
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                ),
              )
            : InnerTile(),
      ),
    );
  }
}
