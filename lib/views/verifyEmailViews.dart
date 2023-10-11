import 'package:flutter/material.dart';
import 'package:notes_taking_app/service/auth/authService.dart';
import 'package:notes_taking_app/views/const/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key}); // Constructor for VerifyEmailView widget

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState(); // Creates state for VerifyEmailView
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'), // AppBar with a title 'Verify email'
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please verify your email."), // Information about email verification
          const Text(
              "If you haven't received a verification email yet, press the button below"), // Instruction for users
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Resend verification email'), // Button to resend verification email
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logout(); // Logout user
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false); // Navigate to the registration route
            },
            child: const Text('Restart'), // Button to restart the verification process
          ),
        ],
      ),
    );
  }
}
