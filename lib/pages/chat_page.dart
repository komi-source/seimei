import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:SEIMEI/components/chat_buble.dart';
import 'package:SEIMEI/components/my_textfield.dart';
import 'package:SEIMEI/services/auth/auth_service.dart';
import 'package:SEIMEI/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String receiverID;

  ChatPage({super.key, required this.recieverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat and auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  //for textf focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //cause a delay so that keyboard has time to show up
        //then the amount pf remaining space will be calculated
        //then scroll down
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    //wait a bit for listview to be built, then scroll to bottom
    Future.delayed(Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message
  void sendMessage() async {
    //if there is smth inside the textfield
    if (_messageController.text.isNotEmpty) {
      //send the message
      await _chatService.sendMessage(
        widget.receiverID,
        _messageController.text,
      );

      //clear text controller
      _messageController.clear();

      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7CCAE),
      appBar: AppBar(
        backgroundColor: Color(0xFFC0AF99),
        title: Text(
          widget.recieverEmail,
          style: TextStyle(color: const Color.fromARGB(255, 216, 216, 216)),
        ),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()),

          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return Text("Error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: Color(0xFFB57873), // насыщенный, уютный
              rightDotColor: Color(0xFFCFB4AB), // пастельная нежность
              size: 60,
            ),
          );
        }

        //return list
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //align message to the right if sender is the current user, otherwise left
    var alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield should take up most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscuretext: false,
              focusNode: myFocusNode,
            ),
          ),

          //send button
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFB57873),
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.send),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
