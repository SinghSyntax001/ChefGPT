import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book_app/models/recipe_model.dart'; // Import our model

/// This class handles all communication with the Firestore database.
class DatabaseService {
  // Get a reference to the 'recipes' collection in Firestore
  final CollectionReference _recipeCollection =
  FirebaseFirestore.instance.collection('recipes');

  /// Adds a new recipe to Firestore.
  Future<void> addRecipe(Recipe recipe) {
    // .add() automatically creates a new document with a unique ID
    return _recipeCollection.add(recipe.toMap());
  }

  /// Updates an existing recipe in Firestore.
  Future<void> updateRecipe(Recipe recipe) {
    if (recipe.id == null) {
      throw Exception("Cannot update a recipe without an ID");
    }
    // .doc(recipe.id) targets the specific document
    return _recipeCollection.doc(recipe.id).update(recipe.toMap());
  }

  /// Deletes a recipe from Firestore.
  Future<void> deleteRecipe(String recipeId) {
    return _recipeCollection.doc(recipeId).delete();
  }

  /// Gets a real-time stream of all recipes.
  /// A Stream updates the UI automatically when data changes.
  Stream<List<Recipe>> getRecipes() {
    return _recipeCollection
        .orderBy('createdAt', descending: true) // Show newest first
        .snapshots() // This returns the stream
        .map((snapshot) {
      // This converts each Firestore document into a Recipe object
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }

  /// Searches for recipes in Firestore.
  /// This is the "R" (Retrieval) part of RAG for our database.
  Future<List<Recipe>> searchRecipes(String query) async {
    // A simple 'starts-with' search.
    // This search is case-sensitive.
    QuerySnapshot snapshot = await _recipeCollection
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }
}

