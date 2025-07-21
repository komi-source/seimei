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
      backgroundColor: Color(0xFF1A1A4A),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 17, 17, 43),
        title: const Text("Wall", style: TextStyle(color: Color(0xFFBFAF8F))),
      ),
      body: Stack(
        children: [
          // 🌊 Картинка внизу экрана
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/wave2.png', // замени на свою картинку
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
          ),

          // 📋 Контент стены поверх фона
          Column(
            children: [
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
                          leftDotColor: Color(0xFFE94B35),
                          rightDotColor: Color(0xFFBFAF8F),
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

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        hintText: "Insert your idea..",
                        obscuretext: false,
                        controller: textController,
                      ),
                    ),
                    // const SizedBox(width: 5),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE94B35),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: postMessage,
                        icon: Icon(
                          Icons.send,
                          color: Color(0xFFBFAF8F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  "Logged in as: ${currentUser.email}",
                  style: const TextStyle(color: Color(0xFFE94B35)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
