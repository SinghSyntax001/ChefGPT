import 'package:flutter/material.dart';
import 'package:recipe_book_app/screens/recipe_detail_page.dart';
import '../services/groq_service.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchCtrl = TextEditingController();

  final trending = [
    {"name": "Butter Chicken", "emoji": "🍛"},
    {"name": "Paneer Tikka", "emoji": "🧀"},
    {"name": "Maggi Masala", "emoji": "🍜"},
    {"name": "Chicken Biryani", "emoji": "🍗"},
  ];

  void _getRecipe(String dish) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailPage(dishName: dish),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add_recipe'),
        icon: const Icon(Icons.add),
        label: const Text("Add Recipe"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Text(
                  "Welcome, Chef! 👩‍🍳",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                  icon: const CircleAvatar(child: Icon(Icons.person)),
                )
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: searchCtrl,
              onSubmitted: _getRecipe,
              decoration: InputDecoration(
                hintText: "Ask AI Chef…",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.tonalIcon(
              onPressed: () => Navigator.pushNamed(context, '/chat'),
              icon: const Icon(Icons.chat),
              label: const Text("Chat with AI Chef"),
            ),
            const SizedBox(height: 18),
            Text("🔥 Trending This Week",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: trending.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final r = trending[i];
                return GestureDetector(
                  onTap: () => _getRecipe(r["name"]!),
                  child: Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(r["emoji"]!, style: const TextStyle(fontSize: 42)),
                          const SizedBox(height: 8),
                          Text(
                            r["name"]!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
