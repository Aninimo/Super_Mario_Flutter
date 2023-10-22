import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mario/button.dart';
import 'package:mario/jumpingmario.dart';
import 'package:mario/mario.dart';
import 'package:mario/mushroom.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double marioX = 0;
  static double marioY = 1;
  double marioSize = 50;
  double mushroomX = 0.5;
  double mushroomY = 1;
  double time = 0;
  double height = 0;
  double initalHeight = marioY;
  String direction = 'right';
  bool midrun = false;
  bool midjump = false;
  var gameFont = GoogleFonts.pressStart2p(
    textStyle: TextStyle(color: Colors.white, fontSize: 20),
  );

  void checkIfAteMushroom() {
    if ((marioX - mushroomX).abs() < 0.05 &&
        (marioY - mushroomY).abs() < 0.05) {
      setState(() {
        marioSize = 100;
        mushroomX = 2;
      });
    }
  }

  void preJump() {
    time = 0;
    initalHeight = marioY;
  }

  void jump() {
    if (!midjump) {
      midjump = true;
      preJump();
      Timer.periodic(Duration(milliseconds: 50), (timer) {
        time += 0.05;
        height = -4.9 * time * time + 5 * time;

        if (initalHeight - height > 1) {
          midjump = false;
          timer.cancel();
          setState(() {
            marioY = 1;
          });
        } else {
          setState(() {
            marioY = initalHeight - height;
          });
        }
      });
    }
  }

  void moveRight() {
    direction = 'right';

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkIfAteMushroom();
      if (MyButton().userIsHoldingButton() == true && marioX + 0.02 < 1) {
        setState(() {
          marioX += 0.02;
          midrun = !midrun;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void moveLeft() {
    checkIfAteMushroom();
    direction = 'left';

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      checkIfAteMushroom();
      if (MyButton().userIsHoldingButton() == true && marioX - 0.02 > -1) {
        setState(() {
          marioX -= 0.02;
          midrun = !midrun;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Container(
                  color: Colors.blue,
                  child: AnimatedContainer(
                    alignment: Alignment(marioX, marioY),
                    duration: Duration(milliseconds: 0),
                    child: midjump
                        ? JumpingMario(
                            direction: direction,
                            size: marioSize,
                          )
                        : MyMario(
                            direction: direction,
                            midrun: midrun,
                            size: marioSize,
                          ),
                  ),
                ),
                Container(
                  alignment: Alignment(mushroomX, mushroomY),
                  child: Mushroom(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('MARIO', style: gameFont),
                          SizedBox(height: 10),
                          Text('0000', style: gameFont)
                        ],
                      ),
                      Column(
                        children: [
                          Text('WORLD', style: gameFont),
                          SizedBox(height: 10),
                          Text('1-1', style: gameFont)
                        ],
                      ),
                      Column(
                        children: [
                          Text('TIME', style: gameFont),
                          SizedBox(height: 10),
                          Text('9999', style: gameFont)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    child: Icon(Icons.arrow_back, color: Colors.white),
                    function: moveLeft,
                  ),
                  MyButton(
                    child: Icon(Icons.arrow_upward, color: Colors.white),
                    function: jump,
                  ),
                  MyButton(
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                    function: moveRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
