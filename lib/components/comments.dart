import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const Comments({
    super.key,
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD7CCAE),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(text, style: TextStyle(fontSize: 16)),
          SizedBox(height: 5),
          //user, time
          Row(
            children: [
              Text(
                user,
                style: TextStyle(
                  color: const Color.fromARGB(255, 36, 36, 36),
                  fontSize: 10,
                ),
              ),
              Text(
                "•",
                style: TextStyle(
                  color: const Color.fromARGB(255, 36, 36, 36),
                  fontSize: 10,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: const Color.fromARGB(255, 36, 36, 36),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
