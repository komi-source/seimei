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
          color: Color(0xFFCFB4AB),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),

        child: Center(child: Text(text)),
      ),
    );
  }
}
