import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Wurdil',
              style: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            DifficultyButton(
              label: 'Easy',
              onPressed: () {
              print('Play button pressed');
              },
              color: Colors.lightGreen,
            ),
            const SizedBox(height: 18.0),
            DifficultyButton(
              label: 'Medium',
              onPressed: () {
                print('Play button pressed');
              },
              color: Colors.yellow
            ),
            const SizedBox(height: 18.0),
            DifficultyButton(
              label: 'Hard',
              onPressed: () {
                print('Play button pressed');
              },
              color: Colors.redAccent
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color; // Optional color parameter

  const DifficultyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color, // Accepting color as an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.lightGreen, // Use the provided color or default to light green
        foregroundColor: Colors.white, // Text color
        textStyle: const TextStyle(
          fontSize: 28, // Font size
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0), // Adjust padding
        minimumSize: const Size(200, 60), // Ensures uniform size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded edges with a boxy feel
        ),
      ),
      child: Text(label),
    );
  }
}
