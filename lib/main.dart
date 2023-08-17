import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_taking_app/views/loginViews.dart';
import 'package:notes_taking_app/views/registerViews.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Note Taking App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Colors.greenAccent, // Set the desired AppBar color here
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;
            // if (user!.emailVerified) {
            // } else {
            //   return const VerifyEmailView();
            // }
            // return const Text('Done');
            return const LoginView();
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}