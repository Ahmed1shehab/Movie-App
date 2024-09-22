import 'package:flutter/material.dart';

Widget profileBtn({
  required String text,
  required Function() event,
  required icon,


}) {
  return MaterialButton(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(35.0),
    ),
    onPressed: event,
    child: ListTile(
      leading: Icon(icon, color: const Color.fromRGBO(1, 3, 16, 0.93)),
      title: Text(text, style: const TextStyle(color: Color.fromRGBO(1, 3, 16, 0.93))),
    )
  );
}
