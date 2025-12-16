import 'package:cloud_firestore/cloud_firestore.dart';

/// A class representing a single Recipe.
/// This is the "single source of truth" for our data structure.
class Recipe {
  final String? id; // Document ID from Firestore
  final String title;
  final String ingredients; // Stored as a single string
  final String instructions; // Stored as a single string
  final String language; // 'en' or 'hi'
  final DateTime createdAt;

  Recipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.language,
    required this.createdAt,
  });

  /// A helper function to format this recipe for the RAG prompt.
  /// We will use this in Phase 2.
  String toPromptString() {
    return '''
    Recipe Title: $title
    Language: $language
    Ingredients: $ingredients
    Instructions: $instructions
    ''';
  }

  /// Converts this Recipe object into a Map (JSON-like) for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'language': language,
      'createdAt': FieldValue.serverTimestamp(), // Good to know when added
    };
  }

  /// Creates a Recipe object from a Firestore DocumentSnapshot.
  /// This is how we read data from the database.
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      title: data['title'] ?? '',
      ingredients: data['ingredients'] ?? '',
      instructions: data['instructions'] ?? '',
      language: data['language'] ?? 'en',
      // Handle the timestamp from Firestore
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
