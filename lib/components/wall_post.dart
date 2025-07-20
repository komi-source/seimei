import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seimei_social_app/components/comment_button.dart';
import 'package:seimei_social_app/components/comments.dart';
import 'package:seimei_social_app/components/delete_button.dart';
import 'package:seimei_social_app/components/like_button.dart';
import 'package:seimei_social_app/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef = FirebaseFirestore.instance
        .collection('User posts')
        .doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  void addComment(String commentText) {
    if (commentText.trim().isEmpty) return;

    FirebaseFirestore.instance
        .collection("User posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
          'CommentText': commentText,
          'CommentedBy': currentUser.email,
          'CommentTime': Timestamp.now(),
        });

    _commentTextController.clear();
    Navigator.pop(context);
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete post"),
        content: Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final commentDocs = await FirebaseFirestore.instance
                  .collection("User posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }

              FirebaseFirestore.instance
                  .collection("User posts")
                  .doc(widget.postId)
                  .delete();

              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFC0AF99),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: message and delete
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          widget.user,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 36, 36, 36),
                          ),
                        ),
                        Text(
                          " • ",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 36, 36, 36),
                          ),
                        ),
                        Text(
                          widget.time,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 36, 36, 36),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost),
            ],
          ),
          SizedBox(height: 20),

          // Comments section
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: LoadingAnimationWidget.twistingDots(
                    leftDotColor: Color(0xFFB57873), // насыщенный, уютный
                    rightDotColor: Color(0xFFCFB4AB), // пастельная нежность
                    size: 60,
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final commentData =
                      docs[index].data() as Map<String, dynamic>;
                  return Comments(
                    text: commentData["CommentText"],
                    user: commentData["CommentedBy"],
                    time: FormatDate(commentData["CommentTime"]),
                  );
                },
              );
            },
          ),
          SizedBox(height: 20),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  SizedBox(height: 5),
                  Text(
                    "Comment",
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
