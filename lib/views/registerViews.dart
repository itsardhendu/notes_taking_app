import 'package:flutter/material.dart';
import 'package:notes_taking_app/service/auth/authExceptions.dart';
import 'package:notes_taking_app/service/auth/authService.dart';
import 'package:notes_taking_app/utilities/showErrorDialog.dart';

import 'package:notes_taking_app/views/const/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key}); // Constructor for RegisterView widget

  @override
  State<RegisterView> createState() => _RegisterViewState(); // Creates state for RegisterView
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController(); // Initialize email controller
    _password = TextEditingController(); // Initialize password controller
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose(); // Dispose of email controller
    _password.dispose(); // Dispose of password controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'), // AppBar with a title 'Register'
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
              hintText: 'Enter your email here', // Hint text for email input
            ),
          ),
          TextField(
            // Password TextField
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            inputFormatters: [],
            decoration: const InputDecoration(
              hintText: 'Enter your password', // Hint text for password input
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                // Attempt to create a new user using AuthService
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                // Send email verification after successful registration
                AuthService.firebase().sendEmailVerification();
                // Navigate to the verification route
                Navigator.of(context).pushNamed(verifyRoute);
              } on WeakPasswordAuthExceptions {
                // Handle weak password exception during registration
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on EmailAlreadyInUseAuthExceptions {
                // Handle email already in use exception during registration
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on InvalidEmailAuthExceptions {
                // Handle invalid email exception during registration
                await showErrorDialog(
                  context,
                  'Invalid email',
                );
              } on GenericAuthExceptions {
                // Handle generic authentication exception during registration
                await showErrorDialog(
                  context,
                  'Failed to register',
                );
              }
            },
            child: const Text('Register'), // Register button text
          ),
          TextButton(
            onPressed: () {
              // Navigate to the login route
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here!'), // Login navigation text
          ),
        ],
      ),
    );
  }
}
