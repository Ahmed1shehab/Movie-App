import 'package:flutter/material.dart';

Widget buildBackButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).pop(); // Navigate back
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(12, 16, 22, 1),
        borderRadius: BorderRadius.circular(14.0), // Rectangle with rounded corners
      ),
      child: const Text(
        'Back',
        style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontFamily: "NerkoOne"
        ),
      ),
    ),
  );
}
