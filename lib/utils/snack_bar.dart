import 'package:flutter/material.dart';

void showMessage(
  BuildContext context,
  String message,
  Color color,
) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.black,
      ),
    ),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
