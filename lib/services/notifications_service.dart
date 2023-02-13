import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showErrorSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 203, 72, 62),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showSuccessSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 13, 151, 59),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showPrimarySnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 18, 87, 176),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showCustomSnackbar({
    required String message,
    required Color color,
  }) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
