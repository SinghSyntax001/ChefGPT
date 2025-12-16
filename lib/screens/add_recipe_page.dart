import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AiRecipePage extends StatelessWidget {
  final String title;
  final String content;

  const AiRecipePage({super.key, required this.title, required this.content});

  Future<void> saveRecipe(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to save recipes.")),
      );
      return;
    }

    final uid = user.uid;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('saved_recipes')
        .doc();

    await ref.set({
      'title': title,
      'full_text': content,
      'created_at': DateTime.now(),
      'source': 'ai',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Recipe saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => saveRecipe(context),
            icon: const Icon(Icons.bookmark_add_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16.5, height: 1.45),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => saveRecipe(context),
        backgroundColor: cs.primary,
        icon: const Icon(Icons.bookmark),
        label: const Text("Save"),
      ),
    );
  }
}
