import 'package:flutter/material.dart';

Widget txtformfield({
  required String text,
  required icon, required TextEditingController controller,
})

{
return TextField(

decoration: InputDecoration(
labelText: text,
labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
prefixIcon: Icon(icon, color: Colors.white),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
enabledBorder: OutlineInputBorder(
borderSide: const BorderSide(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
focusedBorder: OutlineInputBorder(
borderSide: const BorderSide(color: Colors.white),
borderRadius: BorderRadius.circular(12),
),
),
style: const TextStyle(color: Colors.white, fontSize: 18),





);


}