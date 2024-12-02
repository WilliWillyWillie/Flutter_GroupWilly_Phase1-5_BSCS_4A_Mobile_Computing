import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  final String difficulty;
  final int wordLength;

  const GameScreen({super.key, required this.difficulty, required this.wordLength});

  @override
  Widget build(BuildContext context) {
    final themeSurfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      appBar: AppBar(
        leading: BackButton(
            color: themeSurfaceColor
        ),
        title: Text('$difficulty Difficulty',
          style: TextStyle(
            color: themeSurfaceColor
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Text(
          'Welcome to the $difficulty game!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
