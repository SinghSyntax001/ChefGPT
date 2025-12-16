import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // ✅ centers + scroll safe
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // ✅ center vertically
            children: [
              // ✅ Profile Image
              CircleAvatar(
                radius: 55,
                backgroundColor: cs.primary.withOpacity(0.15),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 18),

              // ✅ User name
              Text(
                user?.displayName ?? "User",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // ✅ Email
              Text(
                user?.email ?? "No email",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 25),

              // ✅ Edit Name Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade100,
                  foregroundColor: Colors.teal.shade900,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Edit Name"),
              ),

              const SizedBox(height: 15),

              // ✅ Saved Recipes
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, "/saved_recipes");
                },
                icon: const Icon(Icons.bookmark),
                label: const Text("My Saved Recipes"),
                style: OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // ✅ Logout button at bottom
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade100,
                  foregroundColor: Colors.teal.shade900,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
