import 'package:flutter/material.dart';

// Function to display an error dialog with the given text
Future<void> showErrorDialog(
    BuildContext context,
    String text,
    ) {
  return showDialog(
    context: context,
    builder: (context) {
      // Create and return an AlertDialog widget
      return AlertDialog(
        title: const Text('An error occurred'), // Dialog title
        content: Text(text), // Error message text
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog when Ok button is pressed
            },
            child: const Text('Ok'), // Ok button text
          )
        ],
      );
    },
  );
}
