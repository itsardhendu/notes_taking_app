import 'package:flutter/material.dart';
import 'package:notes_taking_app/service/auth/authExceptions.dart';
import 'package:notes_taking_app/service/auth/authService.dart';
import 'package:notes_taking_app/views/const/routes.dart';
import '../utilities/showErrorDialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controllers for email and password input fields
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Function to handle the login process
  Future<void> _login() async {
    final email = _email.text;
    final password = _password.text;
    try {
      // Attempt to log in using AuthService
      await AuthService.firebase().login(
        email: email,
        password: password,
      );
      // Retrieve the current user
      final user = AuthService.firebase().currentUser;
      // Check if the email is verified
      if (user?.isEmailVerified ?? false) {
        // Navigate to the 'notes' route if email is verified
        Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
      } else {
        // Navigate to the 'verify' route if email is not verified
        Navigator.of(context)
            .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
      }
    } on UserNotFoundAuthExceptions {
      // Handle exception when user is not found during login
      await showErrorDialog(
        context,
        'User not found',
      );
    } on WrongPasswordAuthExceptions {
      // Handle exception when wrong password is provided during login
      await showErrorDialog(
        context,
        'Wrong credentials',
      );
    } on GenericAuthExceptions {
      // Handle generic authentication exception
      await showErrorDialog(
        context,
        'Authentication error',
      );
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
          // Email input field
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
            ),
          ),
          // Password input field
          TextField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          // Login button
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          // Button to navigate to the registration view
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
