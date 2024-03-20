import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'ballon.dart';

class BubbleScreen extends StatefulWidget {
  const BubbleScreen({super.key});

  @override
  State<BubbleScreen> createState() => _BubbleScreenState();
}

class _BubbleScreenState extends State<BubbleScreen>
    with WidgetsBindingObserver {
  List<Color> colors_list = [
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

  void startGame() {
    timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (timer.isActive) {
        generateBubble();
      } else {
        timer.cancel();
      }
    });


    Future.delayed(const Duration(seconds: 60), () {
      if (timer.isActive) {
        timer.cancel();
        Future.delayed(const Duration(seconds: 1), endGame);
      }
    });
  }

  void generateBubble() {
    double left = random.nextDouble() * (size.width-150);
    setState(() {
      bubbles.add(Bubble(
        left: left,
        color: colors_list[random.nextInt(colors_list.length)],
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
      bubbles.clear();
    });
  }

  void restartGame() {
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
          : Center(
              child: Transform.scale(
                  scale: 1.5,
                  child: Text(
                    'You Scored \n $score',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
            onPressed: () {
              if (start) {
                restartGame();
              }
            },
            child: Text(start ? 'Restart' : 'Your Score: $score')),
      ),
    );
  }
}
