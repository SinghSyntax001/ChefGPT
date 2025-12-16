import 'package:flutter/material.dart';
import 'package:recipe_book_app/services/groq_service.dart';

class RecipeDetailPage extends StatefulWidget {
  final String dishName;
  const RecipeDetailPage({super.key, required this.dishName});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final _groq = GroqService();
  String _recipeText = "";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    final result = await _groq.generateRecipe(widget.dishName);
    setState(() {
      _recipeText = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dishName),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildFormattedRecipe(),
            ),
    );
  }

  Widget _buildFormattedRecipe() {
    final lines = _recipeText.split('\n');

    return ListView.builder(
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index].trim();

        if (line.isEmpty) {
          return const SizedBox(height: 6);
        }

        // ✅ Heading check (e.g., "Ingredients:", "Instructions:")
        if (line.endsWith(":")) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Text(
              line,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          );
        }

        // ✅ Bullet item ("•")
        if (line.startsWith("•")) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              line,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          );
        }

        // ✅ Numbered step ("1.", "2.")
        if (RegExp(r'^\d+\.').hasMatch(line)) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              line,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          );
        }

        // ✅ Default normal text
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            line,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        );
      },
    );
  }
}
