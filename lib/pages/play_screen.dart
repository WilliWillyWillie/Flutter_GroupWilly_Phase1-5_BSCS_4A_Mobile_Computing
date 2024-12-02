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

  Widget buildKeyboard() {
    const rows = [
      'QWERTYUIOP',
      'ASDFGHJKL',
      'ZXCVBNM'
    ];

    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.split('').map((char) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () => handleLetterInput(char),
                child: Text(char),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(45, 45),
                ),
              ),
            );
          }).toList(),
        );
      }).toList()
        ..add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: handleDelete,
                child: const Icon(Icons.backspace),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(45, 45)),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: handleEnter,
                child: const Text('Enter'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(90, 45)),
              ),
            ],
          ),
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
                childAspectRatio: 1.0, // Ensures square cells
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
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                );
              },
            ),
          ),
          buildKeyboard(),
          const SizedBox(
            height: 12,
          )// Keyboard
        ],
      ),
    );
  }
}
