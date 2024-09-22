import 'package:flutter/material.dart';


Widget buildActionButton({
  required BuildContext context,
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      width: 350,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(10, 75, 188, 1),
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              onPressed: onTap,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
          ],
        ),
      ),
    ),
  );
}
