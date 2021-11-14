// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var countdown;
  int timeStep = 1;
  int timeMultuplier = 0;
  int focusTime = 0;
  int timeRemaining = 0;
  bool timerStarted = false;

  String buttonText = "";
  String messageText = "";

  int totalTrees = 0;
  bool treeGrew = false;
  int plantMaxLevel = 7;
  int plantLevel = 1;
  String plantImage = "";

  String dispTime(_time) {
    int timeInMins = (_time / 60).floor();
    int timeInSeconds = _time % 60;
    String timeInSecondsTwoDigits = timeInSeconds < 10
        ? "0" + timeInSeconds.toString()
        : timeInSeconds.toString();
    return timeInMins.toString() + ":" + timeInSecondsTwoDigits;
  }

  buttonPressed() {
    setState(() {
      if (treeGrew) {
        resetData();
      } else {
        if (!timerStarted) {
          timerStarted = true;
          buttonText = "Give Up!";
          countdown = Timer.periodic(Duration(milliseconds: 50), (timer) {
            manageTime();
          });
        } else {
          setState(() {
            countdown.cancel();
            resetData();
          });
        }
      }
    });
  }

  manageTime() {
    int timeElapsed = focusTime - timeRemaining;
    int timePeriod = ((plantLevel / plantMaxLevel) * focusTime).floor();

    setState(() {
      if (timerStarted) {
        timeRemaining--;
        if (timeElapsed > timePeriod && plantLevel < plantMaxLevel) {
          plantLevel++;
        }
      } else {
        timeRemaining = 0;
      }

      if (timeRemaining == 0) {
        countdown.cancel();
        totalTrees++;
        treeGrew = true;
        buttonText = "Plant again?";
        messageText = "Good Job!";
      }
    });
  }

  sliderChanged(int step) {
    setState(() {
      timeStep = step;
      resetData();
    });
  }

  resetData() {
    plantLevel = 1;
    plantMaxLevel = 7;
    treeGrew = false;

    buttonText = "Plant";
    messageText = "Plant a tree now";

    timeMultuplier = 5 * 60;
    focusTime = timeStep * timeMultuplier;
    timeRemaining = timeStep * timeMultuplier;
    timerStarted = false;
  }

  @override
  void initState() {
    resetData();
  }

  @override
  Widget build(BuildContext context) {
    plantImage = "lib/images/plant$plantLevel.png";
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.grass,
                    color: Colors.yellow,
                    size: 40,
                  ),
                  SizedBox(width: 10),
                  Text(
                    totalTrees.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100),
              Text(
                messageText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.yellow,
                    width: timerStarted ? 15.0 : 0.0,
                  ),
                ),
                child: timerStarted
                    ? CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(plantImage),
                      )
                    : SingleCircularSlider(
                        12,
                        1,
                        height: 230,
                        width: 230,
                        selectionColor: Colors.yellow,
                        onSelectionEnd: (a, b, c) => sliderChanged(b),
                      ),
              ),
              SizedBox(height: 60),
              Text(
                dispTime(timeRemaining),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  buttonPressed();
                },
                color: Colors.white,
                child: Text(
                  buttonText,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 150),
              Text(
                "",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
