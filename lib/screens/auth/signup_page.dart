import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/widgets/fancy_header.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  Future<void> _signup() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _err(e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _err(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const FancyHeader(
              title: "Create Account",
              subtitle: "Join Recipe Book today",
              emoji: "🥗",
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: loading ? 0.4 : 1,
              child: IgnorePointer(
                ignoring: loading,
                child: ListView(
                  padding:
                  const EdgeInsets.only(top: 240, left: 20, right: 20),
                  children: [
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passCtrl,
                      obscureText: obscure,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(obscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() => obscure = !obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton(
                      onPressed: _signup,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Sign Up"),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(color: cs.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (loading)
              const Center(child: CircularProgressIndicator(strokeWidth: 3)),
          ],
        ),
      ),
    );
  }
}
