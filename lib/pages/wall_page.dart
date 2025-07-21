import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:SEIMEI/components/my_textfield.dart';
import 'package:SEIMEI/components/wall_post.dart';
import 'package:SEIMEI/helper/helper_methods.dart';

class WallPage extends StatefulWidget {
  WallPage({super.key});

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void postMessage() {
    if (textController.text.trim().isNotEmpty) {
      FirebaseFirestore.instance.collection("User posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text.trim(),
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
      textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7CCAE),
      appBar: AppBar(
        backgroundColor: Color(0xFFC0AF99),
        title: const Text("Wall"),
      ),
      body: Column(
        children: [
          // посты
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User posts")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading posts"));
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: Color(0xFFB57873), // насыщенный, уютный
                      rightDotColor: Color(0xFFCFB4AB), // пастельная нежность
                      size: 60,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data!.docs[index];
                    return WallPost(
                      message: post['Message'],
                      user: post['UserEmail'],
                      postId: post.id,
                      likes: List<String>.from(post['Likes'] ?? []),
                      time: FormatDate(post['TimeStamp']),
                    );
                  },
                );
              },
            ),
          ),

          // форма ввода и кнопка
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Row(
              children: [
                // поле ввода
                Expanded(
                  child: MyTextField(
                    hintText: "Insert your idea..",
                    obscuretext: false,
                    controller: textController,
                  ),
                ),
                const SizedBox(width: 10),
                // кнопка отправки справа
                IconButton(
                  onPressed: postMessage,
                  icon: Icon(Icons.arrow_circle_up, color: Color(0xFFB57873)),
                  color: Theme.of(context).colorScheme.primary,
                  iconSize: 32,
                ),
              ],
            ),
          ),

          // логин
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              "Logged in as: ${currentUser.email}",
              style: const TextStyle(color: Color(0xFFB57873)),
            ),
          ),
        ],
      ),
    );
  }
}
