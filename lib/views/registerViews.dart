import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_taking_app/utilities/showErrorDialog.dart';
import 'dart:developer' as devtools show log;

import 'package:notes_taking_app/views/const/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            // Email TextField
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            //Password TextField
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            inputFormatters: [],
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email,
                        password: password); //Firebase Create User
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showErrorDialog(context, 'Weak password');
                } else if (e.code == 'email-already-in-use') {
                  showErrorDialog(context, 'Email already in use');
                } else if (e.code == 'invalid-email') {
                  showErrorDialog(context, 'Invalid email');
                }
              }
              // Navigator.of(context).pushNamed(verifyRoute);
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
