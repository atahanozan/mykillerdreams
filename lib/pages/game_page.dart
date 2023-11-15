import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mykillerdreams/components/mykillerdreams_game.dart';

class GamePage extends StatelessWidget {
  GamePage({super.key});

  final MyKillerDreamsGame game = MyKillerDreamsGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: GameWidget(game: game),
      ),
    );
  }
}
