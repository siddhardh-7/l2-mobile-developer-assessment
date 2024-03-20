import 'package:ballon_pop/bubble_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BubbleScreen(),
    );
  }
}
