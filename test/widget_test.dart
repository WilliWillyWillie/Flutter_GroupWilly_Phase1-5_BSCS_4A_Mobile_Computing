import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wurdil/main.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify the app displays the title and difficulty buttons.
    expect(find.text('Wurdil'), findsOneWidget); // Title of the app.
    expect(find.text('Easy'), findsOneWidget); // Difficulty buttons.
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
  });

  testWidgets('Navigate to game screen on Easy difficulty', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the Easy button.
    await tester.tap(find.text('Easy'));
    await tester.pumpAndSettle(); // Wait for the navigation animation to complete.

    // Verify the Easy game screen is loaded.
    expect(find.text('Easy Difficulty'), findsOneWidget); // AppBar title.
    expect(find.byType(GridView), findsOneWidget); // Game grid.
  });
}
