import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'balloon.dart';

class BubbleScreen extends StatefulWidget {
  const BubbleScreen({super.key});

  @override
  State<BubbleScreen> createState() => _BubbleScreenState();
}

class _BubbleScreenState extends State<BubbleScreen>
    with WidgetsBindingObserver {
  var colorsList = <Color>[
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.grey,
  ];
  int totalBolloons = 0;
  late Timer timer;

  // late Timer colorTimer;
  List<Bubble> bubbles = [];
  Random random = Random();
  int score = 0;
  late Size size;
  bool start = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    startGame();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (timer.isActive) {
        timer.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      restartGame();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  int _start = 120;
  String _remainingTime = '2:00';

  void startGame() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        endGame();
      } else {
        _start--;
        Duration remainingTime = Duration(seconds: _start);
        _remainingTime =
            '${remainingTime.inMinutes}:${(remainingTime.inSeconds - remainingTime.inMinutes * 60).toString().padLeft(2, '0')}';
        // print('Remaining time: $_remainingTime, Score: $score, Total Ballons: ${bubbles.length}');
        generateBubble();
      }
    });
  }

  void generateBubble() {
    double left = random.nextDouble() * (size.width - 150);
    setState(() {
      bubbles.add(Bubble(
        left: left,
        color: colorsList[random.nextInt(colorsList.length)],
        pop: pop,
        // selectColor: color,
      ));
    });
  }

  void pop() {
    setState(() {
      score++;
    });
  }

  void endGame() {
    setState(() {
      start = true;
      totalBolloons = bubbles.length;
      bubbles.clear();
    });
  }

  void restartGame() {
    totalBolloons = bubbles.length;
    bubbles.clear();
    score = 0;
    start = false;
    startGame();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: !start
          ? Stack(children: [
              for (int i = 0; i < bubbles.length; i++) bubbles[i],
            ])
          : Container(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 220),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber,
        ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                Text(
                  'Score Board',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,),
                ),
                Divider(
                  thickness:2,
                  color: Colors.white,
                ),
                Text(
                  'Balloons Popped: $score',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,),
                ),
                Text(
                  'Balloons Missed: ${totalBolloons - score}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'You Score',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Text(
                    '${score*2 - (totalBolloons-score)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(255,94,247,1), Color.fromRGBO(2,245,255,1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: TextButton(
          onPressed: () {
            if (start) {
              restartGame();
            }
          },
          child: Text(
            start ? 'Restart' : 'Remaining Time: $_remainingTime',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
