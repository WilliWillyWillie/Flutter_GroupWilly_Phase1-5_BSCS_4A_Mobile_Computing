import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final String difficulty;
  final int wordLength;

  const GameScreen({super.key, required this.difficulty, required this.wordLength});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late String targetWord;
  List<List<String>> guesses = List.generate(6, (_) => List.filled(0, '', growable: true));
  List<List<Color>> gridColors = List.generate(6, (_) => List.filled(0, Colors.transparent, growable: true));
  int currentRow = 0;
  int currentCol = 0;

  @override
  void initState() {
    super.initState();
    targetWord = generateWord(widget.wordLength).toLowerCase();
    print("Target Word: $targetWord"); // Debugging
  }

  String generateWord(int length) {
    final random = Random();

    // Filter words by the desired length
    final filteredWords = all.where((word) => word.length == length).toList();

    // If no words match the length, return a default message
    if (filteredWords.isEmpty) {
      return 'No word found of length $length';
    }

    // Return a random word from the filtered list
    return filteredWords[random.nextInt(filteredWords.length)];
  }

  void handleLetterInput(String letter) {
    if (currentCol < widget.wordLength) {
      setState(() {
        guesses[currentRow].add(letter);
        currentCol++;
      });
    }
  }

  void handleDelete() {
    if (currentCol > 0) {
      setState(() {
        guesses[currentRow].removeLast();
        currentCol--;
      });
    }
  }

  void handleEnter() {
    final currentGuess = guesses[currentRow].join().toLowerCase();
    print(currentCol ==  widget.wordLength);
    if (currentCol == widget.wordLength) {
      // Evaluate the current guess and provide feedback
      setState(() {
        gridColors[currentRow] = List.generate(widget.wordLength, (index) {
          if (targetWord[index] == currentGuess[index]) {
            return Colors.green; // Correct position
          } else if (targetWord.contains(currentGuess[index])) {
            return Colors.yellow; // Wrong position
          } else {
            return Colors.grey; // Incorrect letter
          }
        });

        // Move to the next row or end the game if the guess is correct
        if (currentGuess == targetWord) {
          _showEndGameDialog("Congratulations!", "You guessed the word: $targetWord");
        } else if (currentRow == 5) {
          _showEndGameDialog("Game Over", "The correct word was: $targetWord");
        } else {
          currentRow++;
          currentCol = 0;
        }
      });
    }
  }

  void _showEndGameDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                targetWord = generateWord(widget.wordLength).toLowerCase();
                guesses = List.generate(6, (_) => List.filled(0, '', growable: true));
                gridColors = List.generate(6, (_) => List.filled(0, Colors.transparent, growable: true));
                currentRow = 0;
                currentCol = 0;
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeSurfaceColor = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      appBar: AppBar(
        leading: BackButton(color: themeSurfaceColor),
        title: Text('${widget.difficulty} Difficulty',
          style: TextStyle(color: themeSurfaceColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Game Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6 * widget.wordLength,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.wordLength,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ widget.wordLength;
                int col = index % widget.wordLength;

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: gridColors[row].length > col ? gridColors[row][col] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    guesses[row].length > col ? guesses[row][col].toUpperCase() : '',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          // Keyboard
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: 'abcdefghijklmnopqrstuvwxyz'.split('').map((letter) {
              return ElevatedButton(
                onPressed: () => handleLetterInput(letter),
                child: Text(letter.toUpperCase()),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            }).toList(),
          ),
          // Action Buttons (Delete & Enter)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: handleDelete,
                child: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: handleEnter,
                child: const Text('Enter'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
