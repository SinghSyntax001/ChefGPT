// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_book_app/main.dart';

// Import the mock Firebase setup
import 'mock.dart';

void main() {
  // --- THIS IS THE FIX ---
  // We must set up the mocked Firebase services before running the test
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  // --- END OF FIX ---

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RecipeBookApp());

    // Verify that our app title is NOT present because we are on the home page.
    // The title is in the AppBar of the HomePage.
    expect(find.text('My Recipe Book'), findsOneWidget);


    // Verify that the add icon is present
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Use pumpAndSettle for navigation

    // After tapping, we should be on the 'Add New Recipe' page.
    expect(find.text('Add New Recipe'), findsOneWidget);
  });
}
