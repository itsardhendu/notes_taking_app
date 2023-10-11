import 'package:flutter/material.dart';
import 'package:notes_taking_app/service/auth/authService.dart';
import 'package:notes_taking_app/views/const/routes.dart';
import 'package:notes_taking_app/views/loginViews.dart';
import 'package:notes_taking_app/views/notesViews.dart';
import 'package:notes_taking_app/views/registerViews.dart';
import 'package:notes_taking_app/views/verifyEmailViews.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Note Taking App', // Title of the application
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor:
          Colors.greenAccent, // Set the desired AppBar color here
        ),
        useMaterial3: true,
      ),
      home: const HomePage(), // Set the home page to HomePage widget
      routes: {
        loginRoute: (context) => const LoginView(), // Route to LoginView widget
        registerRoute: (context) => const RegisterView(), // Route to RegisterView widget
        notesRoute: (context) => const NotesView(), // Route to NotesView widget
        verifyRoute: (context) => const VerifyEmailView(), // Route to VerifyEmailView widget
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(), // Initialize authentication service
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser; // Get current authenticated user
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView(); // If user is verified, show NotesView
              } else {
                return const VerifyEmailView(); // If email is not verified, show VerifyEmailView
              }
            } else {
              return const LoginView(); // If no user is logged in, show LoginView
            }
          default:
            return const Center(child: CircularProgressIndicator()); // Show loading indicator while initializing
        }
      },
    );
  }
}
