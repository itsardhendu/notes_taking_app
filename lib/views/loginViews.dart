import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_taking_app/views/const/routes.dart';
import '../utilities/showErrorDialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _email.text;
    final password = _password.text;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        await showErrorDialog(context, 'User not found');
      } else if (e.code == 'wrong-password') {
        await showErrorDialog(context, 'Wrong credentials');
      } else {
        await showErrorDialog(context, 'Error: ${e.code}');
      }
    } catch (e) {
      await showErrorDialog(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
