import 'package:flutter/material.dart';
import 'package:notes_taking_app/service/auth/authExceptions.dart';
import 'package:notes_taking_app/service/auth/authService.dart';
import 'package:notes_taking_app/utilities/showErrorDialog.dart';

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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                ); //Firebase Create User
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyRoute);
              } on WeakPasswordAuthExceptions {
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on EmailAlreadyInUseAuthExceptions {
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on InvalidEmailAuthExceptions {
                await showErrorDialog(
                  context,
                  'Invalid email',
                );
              } on GenericAuthExceptions {
                await showErrorDialog(
                  context,
                  'Falied to register',
                );
              }
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
