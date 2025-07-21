import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SEIMEI/themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Проверка тёмной темы
    final bool isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;

    // Явно определяем цвет пузыря
    final Color bubbleColor = isCurrentUser
        ? (isDarkMode
              ? const Color.fromARGB(
                  255,
                  118,
                  14,
                  49,
                ) // сообщение пользователя в тёмной теме
              : Color.fromARGB(255, 103, 32, 23)) // сообщение пользователя в светлой теме
        : (isDarkMode
              ? const Color.fromARGB(
                  255,
                  55,
                  77,
                  87,
                ) // сообщение собеседника в тёмной теме
              : Color.fromARGB(
                  255,
                  17,
                  17,
                  43,
                )); // сообщение собеседника в светлой теме

    // Цвет текста
    final Color textColor = isDarkMode ? Colors.white : Color(0xFFBFAF8F);

    return Container(
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(message, style: TextStyle(color: textColor)),
    );
  }
}
