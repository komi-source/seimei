import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;

  const MyButton({super.key, required this.text, this.onTap});

  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1A1A4A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFFBFAF8F), // твой красноватый акцентный цвет
            width: 1.0, // ширина границы
          ),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 25),

        child: Center(
          child: Text(text, style: TextStyle(color: Color(0xFFBFAF8F), fontSize: 30)),
        ),
      ),
    );
  }
}
