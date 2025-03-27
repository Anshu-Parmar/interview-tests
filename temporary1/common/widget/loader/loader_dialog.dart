import 'package:flutter/material.dart';

class LoaderDialog {
  LoaderDialog._privateConstructor();

  static final LoaderDialog _instance = LoaderDialog._privateConstructor();

  static LoaderDialog get instance => _instance;

  static BuildContext? _dialogContext;

  static final AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.all(20.0),
    insetPadding: EdgeInsets.all(20.0),
    content: Row(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(width: 10),
        const Text("Loading..."),
      ],
    ),
  );

  static void show(BuildContext context) {
    if (_dialogContext == null) {
      _dialogContext = context;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => alert,
      );
    }
  }

  static void close() {
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
      _dialogContext = null;
    }
  }
}
