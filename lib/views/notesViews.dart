import 'package:flutter/material.dart';
import 'package:notes_taking_app/service/auth/authService.dart';
import '../enums/menuAction.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key}); // Constructor for NotesView widget

  @override
  State<NotesView> createState() => _NotesViewState(); // Creates state for NotesView
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Notes'), // AppBar with a title 'Take Notes'
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    // Calls AuthService to perform logout and navigates to the login screen
                    await AuthService.firebase().logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (route) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'), // Popup menu item for logout action
                ),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello Flutter'), // Displays 'Hello Flutter' text in the body
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'), // Dialog title
        content: const Text('Are you sure you want to sign out?'), // Dialog content
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Closes the dialog with false value (cancel)
            },
            child: const Text('Cancel'), // Cancel button text
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Closes the dialog with true value (logout)
            },
            child: const Text('Logout'), // Logout button text
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}