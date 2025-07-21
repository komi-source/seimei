import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscuretext;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscuretext,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(color: Color(0xFFBFAF8F)),
        obscureText: obscuretext,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBFAF8F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBFAF8F)),
          ),
          fillColor: Color(0xFF1A1A4A),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFFBFAF8F)),
        ),
      ),
    );
  }
}
