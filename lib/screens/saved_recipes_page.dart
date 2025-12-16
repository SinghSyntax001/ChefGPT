import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ai_recipe_page.dart';

class SavedRecipesPage extends StatelessWidget {
  const SavedRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Saved Recipes")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('saved_recipes')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No saved recipes yet"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;

              return Dismissible(
                key: ValueKey(doc.id),
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 18),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Delete recipe?"),
                      content: const Text("This action cannot be undone."),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel")),
                        FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete")),
                      ],
                    ),
                  ) ??
                      false;
                },
                onDismissed: (_) => doc.reference.delete(),
                child: Card(
                  child: ListTile(
                    title: Text(data['title'] ?? "Untitled"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AiRecipePage(
                            title: data['title'] ?? "Recipe",
                            content: data['full_text'] ?? "",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
