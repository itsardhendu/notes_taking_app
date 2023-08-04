import 'package:flutter/material.dart';
import 'package:notes_taking_app/views/loginViews.dart';
import 'package:notes_taking_app/views/registerViews.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'Flutter Note Taking App',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.greenAccent, // Set the desired AppBar color here
            ),
          useMaterial3: true,
        ),
        home: const RegisterView(),
      ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: TextButton(
        onPressed:  () {

        }, child: const Text('Register'),
      ),
    );
  }
}
