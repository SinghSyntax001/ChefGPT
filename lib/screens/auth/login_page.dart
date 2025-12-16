import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_book_app/widgets/fancy_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
    } catch (e) {
      _err(e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => loading = true);
    try {
      final gUser = await GoogleSignIn().signIn();
      if (gUser == null) return; // cancelled
      final gAuth = await gUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(cred);
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
              title: "Welcome Back!",
              subtitle: "Log in to your Recipe Book",
              emoji: "🍳",
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
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
                      onPressed: _login,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _loginWithGoogle,
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text("Sign in with Google"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup'),
                        child: Text(
                          "Don't have an account? Sign Up",
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
