import 'package:flutter/material.dart';
import 'package:tap_tennis/colours.dart' as colours;
import '../components/tap_tennis_game.dart';

class Dashboard extends StatefulWidget {
  final TapTennisGame game;
  Dashboard({Key? key, required this.game}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool gamePaused = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(children: [
      Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.pause,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              setState(() {
                gamePaused = true;
              });
              widget.game.pauseEngine();
            },
          ),
        ],
      ),
      gamePaused == true
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: colours.Palette.charcoal,
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      top: height / 15,
                      left: width / 50,
                      right: width / 50,
                      bottom: height / 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Paused",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: height / 15,
                              left: height / 100,
                              right: height / 100),
                          child: Container(
                              height: height / 5,
                              width: width / 1.75,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          colours.Palette.playButtonGreen,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  onPressed: () {
                                    setState(() {
                                      gamePaused = false;
                                    });
                                    widget.game.resumeEngine();
                                  },
                                  child: Image.asset(
                                      "assets/images/icons/Play.png",
                                      scale: 25)))),
                      Padding(
                          padding: EdgeInsets.only(
                              top: height / 15,
                              left: height / 100,
                              right: height / 100),
                          child: Container(
                            height: height / 5,
                            width: width / 1.75,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      colours.Palette.quitButtonRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: Image.asset(
                                      "assets/images/icons/Close.png",
                                      scale: 25),
                            ),
                          ))
                    ],
                  )))
          : Container()
    ]);
  }
}