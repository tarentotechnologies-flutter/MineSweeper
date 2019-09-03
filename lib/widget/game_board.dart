import 'dart:async';
import 'package:Minesweeper/pages/dbHelper.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:Minesweeper/pages/game_page.dart';
import 'package:Minesweeper/widget/tiles/game_board_covered_mine_tile.dart';
import 'package:Minesweeper/widget/tiles/game_board_open_mine_tile.dart';
import 'package:Minesweeper/widget/game_board.dart';
import 'package:Minesweeper/widget/tiles/game_board_tile.dart';
import 'dart:math';
import 'package:gradient_text/gradient_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:Minesweeper/model/highscoremodal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

enum GameResult { WON, LOST, TIME_LIMIT_EXCEEDED }
const String testDevice = "37376FFF466C63E06DABDCB2BAA5B58F";
//AdRequest.Builder.addTestDevice("37376FFF466C63E06DABDCB2BAA5B58F")
class GameBoard extends StatefulWidget {
  var Level;
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  GameBoard({Key key, this.Level}) : super(key: key);
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game', 'Mario'],
  );
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/2934735716',
//        'ca-app-pub-4513385978792761/8978372017',
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  Future<void> _testSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Game BoardPage',
      screenClassOverride: 'AnalyticsDemo',
    );
  }
  Future<void> _sendAnalytics() async {
    await analytics.logEvent(
      name: 'Flag_Action',
      parameters: <String, dynamic>{
      },
    );
  }
  var Level;

  final int timeLimit = 999;

  int numOfRows;
  int numOfColumns;
  int numOfMines;

  List<List<TileState>> gameTilesState;
  List<List<bool>> gameTilesMineStatus;

  bool isUserAlive;
  bool hasUserWonGame;
  int minesFound;
  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  SharedPreferences sharedPreferences;
  int BestScore;

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
//    myBanner?.dispose();
    timer?.cancel();
    super.dispose();
  }


  void reset() {
    setState(() {
      _GameBoardState();

    });
    isUserAlive = true;
    hasUserWonGame = false;
    minesFound = 0;
    stopwatch.reset();
    _stopGameTimer();
    //the callback method just invokes setState() because we want the time to update
    //every second

    timer = Timer.periodic(
      Duration(seconds: 1),
          (timer) {
        setState(() {});
      },
    );

    //2D list for tile status (covered/blown/open/flagged/revealed)
    gameTilesState = List<List<TileState>>.generate(numOfRows, (row) {
      return List<TileState>.filled(numOfColumns, TileState.covered);
    });

    //2D list for tile mine status (true for mine, false for normal)
    gameTilesMineStatus = List<List<bool>>.generate(numOfRows, (row) {
      return List<bool>.filled(numOfColumns, false);
    });

    //logic to place mines on the game board
    Random random = Random();
    int remainingNumOfMines = numOfMines;

    while (remainingNumOfMines > 0) {
      int positionOfMine = random.nextInt(numOfRows * numOfColumns);
      int rowIndexOfMine = positionOfMine ~/ numOfRows;
      int columnIndexOfMine = positionOfMine % numOfColumns;

      //check if new position doesn't have a mine already
      if (!gameTilesMineStatus[rowIndexOfMine][columnIndexOfMine]) {
        gameTilesMineStatus[rowIndexOfMine][columnIndexOfMine] = true;
        remainingNumOfMines--;
      }
    }
  }
  @override
  void initState() {
    _testSetCurrentScreen();
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    prefs.then(
            (pref) {
          BestScore = pref.getInt('score');
          if(BestScore == null){
            BestScore = 0;
          }
          print(BestScore);
        });

    print(widget.Level);
    switch (widget.Level) {
      case "Easy":
        {
          numOfRows = 5;
          numOfColumns = 5;
          numOfMines = 7;
        }
        break;
      case "Medium":
        {
          numOfRows = 7;
          numOfColumns = 7;
          numOfMines = 9;
        }
        break;
      case "Hard":
        {
          numOfRows = 9;
          numOfColumns = 9;
          numOfMines = 14;
        }
        break;
      default:
        {
          numOfRows = 9;
          numOfColumns = 9;
          numOfMines = 14;
        }
        break;
    }
    reset();
    super.initState();
  }
  Widget _buildBoard() {
    //covered tile = un-opened tile
    bool doesBoardHaveACoveredTile = false;

    List<Row> gameBoardRow = <Row>[];

    for (int y = 0; y < numOfRows; y++) {
      List<Widget> rowChildren = <Widget>[];

      for (int x = 0; x < numOfColumns; x++) {
        TileState tileState = gameTilesState[y][x];
        int minesNearMeCount = surroundingMinesCount(x, y);

        //reveal all mines if user has clicked on a mine
        if (!isUserAlive) {
          if (tileState != TileState.blown)
            //if the current tile has a mine, reveal it, else let it be
            tileState =
            gameTilesMineStatus[y][x] ? TileState.revealed : tileState;
        }
        if (tileState == TileState.covered || tileState == TileState.flagged) {
          rowChildren.add(
            GestureDetector(
              onTap: () {
                setState(() {
                  analytics.logEvent(
                    name: 'PlayGame_Action',
                    parameters: <String, dynamic>{
                    },
                  );
                });

                //allow user to click a tile only if it is covered (so that
                //we can't click on flagged tiles)
                if (tileState == TileState.covered) tapTile(x, y);
              },
              onLongPress: () {
                setState(() {
                  analytics.logEvent(
                    name: 'FlagOnTap_Action',
                    parameters: <String, dynamic>{
                    },
                  );
                });
                flag(x, y);
              },
              child: Tile(
                child: CoveredMineTile(
                  flagged: tileState == TileState.flagged,
                  posX: y,
                  posY: x,
                ),
              ),
            ),
          );

          //if there are any tiles that are covered (haven't been opened or
          //revealed yet), then doesBoardHaveACoveredTile is true
          if (tileState == TileState.covered) {
            doesBoardHaveACoveredTile = true;
          }
        } else {
          rowChildren.add(
            OpenMineTile(
              state: tileState,
              surroundingMinesCount: minesNearMeCount,
            ),
          );
        }
      }
      gameBoardRow.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        key: ValueKey<int>(y),
      ));
    }
//    //the user can win the game only when you've opened all the tiles and
//    //marked all mine tiles as flagged

    if (!doesBoardHaveACoveredTile) {
      if ((minesFound == numOfMines) && isUserAlive) {
        hasUserWonGame = true;
        isUserAlive = false;
        _stopGameTimer();
        analytics.logEvent(
          name: 'GameComplete_Action',
          parameters: <String, dynamic>{
          },
        );
        final overlay = Overlay.of(context);
        WidgetsBinding.instance.addPostFrameCallback(
                (_) => overlay.insert(_showGameStatusDialog(GameResult.WON)));
      }
    }
    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: gameBoardRow,
      ),
    );
  }

  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4513385978792761~3994881913');
//        'ca-app-pub-4513385978792761~3994881913');
//    'ca-app-pub-2197846689758151~3496597584'
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show(
        anchorType: AnchorType.top,
        anchorOffset: 80.0,
      );

    int timeElapsed = stopwatch.elapsedMilliseconds ~/ 1000;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.black //change your color here
        ),

        title: GradientText("MINDSWEEPER",
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end:Alignment.center ,
                //end: Alignment.bottomCenter,
                colors: [Colors.deepOrange[500], Colors.yellow[100], Colors.deepOrange]
            ),
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center),

      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0,5, 0 ,0),
            //padding: EdgeInsets.all(5),
            child: Image.asset(
              'assets/images/river.jpg',
              width: 600,
              height: 100,
              fit: BoxFit.cover,

            ),

          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[

                  _buildMinesFoundCountWidget(),
                  _buildBestScoreWidget(),
                  _buildTimerWidget(timeElapsed),
                ],

              ),
            ),

          ),
          _buildBoard(),
        ],
      ),
      bottomSheet:Container(
        color: Colors.white,
        height:70,
        child: Center(
            child: SizedBox(
              height: 60,
              child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),side: BorderSide(color: Colors.green)),
                onPressed: () {
                  analytics.logEvent(
                    name: 'ResetGame_Action',
                    parameters: <String, dynamic>{
                    },
                  );
                reset();
              },
//                onPressed: () =>
//
//                    reset(),
                child: Image.asset('assets/images/bomb.png'),
              ),
            )
        ),
      ),
    );
  }
  bool isInBoard(int x, int y) =>
      x >= 0 && x < numOfColumns && y >= 0 && y < numOfRows;

  int isAMine(int x, int y) =>
      isInBoard(x, y) && gameTilesMineStatus[y][x] ? 1 : 0;

  int surroundingMinesCount(int x, int y) {
    int count = 0;

    count += isAMine(x - 1, y - 1);
    count += isAMine(x - 1, y);
    count += isAMine(x - 1, y + 1);

    //check same column
    count += isAMine(x, y - 1);
    count += isAMine(x, y + 1);

    //check right column
    count += isAMine(x + 1, y - 1);
    count += isAMine(x + 1, y);
    count += isAMine(x + 1, y + 1);

    return count;
  }

  void flag(int x, int y) {
    if (!isUserAlive) {
      return;
    }

    setState(() {
      if (gameTilesState[y][x] == TileState.flagged) {
        gameTilesState[y][x] = TileState.covered;
        minesFound--;
      } else {
        gameTilesState[y][x] = TileState.flagged;
        minesFound++;
      }
    });
  }

  void openTile(int x, int y) {
    //if the user clicks outside the board
    if (!isInBoard(x, y)) {
      return;
    }

    //if the user clicks an already opened tile
    if (gameTilesState[y][x] == TileState.open) {
      return;
    }

    //if the user had flagged this tile previously, reduce the flagged count
    if (gameTilesState[y][x] == TileState.flagged) minesFound--;

    gameTilesState[y][x] = TileState.open;

    //if you click a tile that has a number, the game would only open that tile.
    //But if you click an empty tile, then we want to open all tiles nearby
    // until we hit a tile that has a number
    if (surroundingMinesCount(x, y) > 0) {
      return;
    }

    //left column
    openTile(x - 1, y + 1);
    openTile(x - 1, y);
    openTile(x - 1, y - 1);

    //same column
    openTile(x, y + 1);
    openTile(x, y - 1);

    //right column
    openTile(x + 1, y + 1);
    openTile(x + 1, y);
    openTile(x + 1, y - 1);
  }

  void tapTile(int x, int y) {
    if (!isUserAlive) {
      return;
    }

    if (gameTilesState[y][x] == TileState.flagged) {
      return;
    }

    setState(() {
      if (gameTilesMineStatus[y][x]) {
        gameTilesState[y][x] = TileState.blown;
        isUserAlive = false;
        _stopGameTimer();
        analytics.logEvent(
          name: 'GameLost_Action',
          parameters: <String, dynamic>{
          },
        );
        _showGameStatusDialog(GameResult.LOST);
      } else {
        openTile(x, y);
        if (!stopwatch.isRunning) {
          stopwatch.start();
        }
      }
    });
  }

  _buildTimerWidget(int timeElapsed) {
    int unitsDigit = timeElapsed % 10;
    int hundredsDigit = timeElapsed ~/ 100;
    int tensDigit = (timeElapsed - (hundredsDigit * 100)) ~/ 10;

    if (timeElapsed > timeLimit) {
      _stopGameTimer();
      isUserAlive = false;
      final overlay = Overlay.of(context);
      WidgetsBinding.instance.addPostFrameCallback((_) => overlay
          .insert(_showGameStatusDialog(GameResult.TIME_LIMIT_EXCEEDED)));
//      _showGameStatusDialog(GameResult.TIME_LIMIT_EXCEEDED);
    }
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: timeElapsed > timeLimit
          ? Text(
        "∞",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      )
          : Row(
        children: <Widget>[
          _buildDigitContainer(hundredsDigit),
          _buildDigitContainer(tensDigit),
          _buildDigitContainer(unitsDigit),
          Text("Sec",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),),
        ],
      ),
    );
  }
  _buildMinesFoundCountWidget() {
    return Container(
      child: Center(
        child: Text(
          //"$minesFound",
          '$minesFound/$numOfMines',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
      ),
    );
  }
  _showGameStatusDialog(gameResult) async {
    print(gameResult);
    await showDialog(
        context: context,
        builder: (context) {
          return _gameStatusDialog(gameResult);
        });
  }
  _gameStatusDialog(gameResult) {
    int timeElasped = stopwatch.elapsedMilliseconds ~/ 1000;
    String resultText = "You lost in $timeElasped Sec";
    switch (gameResult) {
      case GameResult.WON:
        resultText = "Congratulations... You win $timeElasped Sec";
        break;
      case GameResult.TIME_LIMIT_EXCEEDED:
        resultText = "Time up. You lost. in $timeElasped Sec";
        break;
      default:
    }
    return AlertDialog(
      contentPadding: const EdgeInsets.all(12.0),
      content: Text(
        resultText,
        textAlign: TextAlign.center,
      ),
    );
  }
  _buildDigitContainer(int digit) {
    return Container(
      // width: .0,
      child: Center(
        child: Text(
          "$digit",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
      ),
    );
  }
  _stopGameTimer() {
    stopwatch.stop();
    timer?.cancel();
  }
  void fristinsert(int finalscore) async {

    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    if(BestScore < finalscore){
      prefs.then(
              (pref) {
            pref.setInt("score", finalscore);
          }
      );
    }


  }

  _buildBestScoreWidget() {
    return Container(
//      width: .0,
      child: Center(
        child: Text(
          BestScore.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

