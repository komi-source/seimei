import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seimei_social_app/themes/theme_provider.dart';

class ChatBuble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBuble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    //light vs dark mode for correct bubble colors
    bool isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode
                  ? const Color.fromARGB(255, 118, 14, 49)
                  : Colors.pink)
            : (isDarkMode
                  ? const Color.fromARGB(255, 55, 77, 87)
                  : Colors.blueGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(message, style: TextStyle(color: Colors.white)),
    );
  }
}
