import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});

  Map<String, dynamic> toJson() => {'text': text, 'isUser': isUser};
  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(text: json['text'], isUser: json['isUser']);
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  bool isLoading = false;
  bool obscureText = false;
  String hintText = "Type to AI..";

  final String selectedModel = 'mistralai/mistral-7b-instruct';
  final String apiKey =
      'Bearer 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';

  @override
  void initState() {
    super.initState();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('chat_history') ?? [];
    setState(() {
      messages = raw.map((e) => Message.fromJson(jsonDecode(e))).toList();
    });

    await Future.delayed(Duration(milliseconds: 100));
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  Future<void> saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('chat_history', raw);
  }

  Future<void> clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() => messages.clear());
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    setState(() {
      messages.add(Message(text: content.trim(), isUser: true));
      isLoading = true;
    });

    controller.clear();
    await getAIResponse();
    await saveChatHistory();

    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 80,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    setState(() => isLoading = false);
  }

  Future<void> getAIResponse() async {
    try {
      final conversation = messages.map((msg) {
        return {"role": msg.isUser ? "user" : "assistant", "content": msg.text};
      }).toList();

      final response = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {'Authorization': apiKey, 'Content-Type': 'application/json'},
        body: jsonEncode({"model": selectedModel, "messages": conversation}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply =
            data["choices"]?[0]?["message"]?["content"] ?? "🤖 No answer";
        setState(() => messages.add(Message(text: reply, isUser: false)));
        await saveChatHistory();

        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 80,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      } else {
        setState(
          () => messages.add(
            Message(
              text: "💥 Error ${response.statusCode}: ${response.body}",
              isUser: false,
            ),
          ),
        );
      }
    } catch (e) {
      setState(
        () => messages.add(
          Message(text: "❌ Connection Error: $e", isUser: false),
        ),
      );
    }
  }

  String generateTranscript() {
    return messages
        .map((msg) => msg.isUser ? "You: ${msg.text}" : "AI: ${msg.text}")
        .join('\n\n');
  }

  void exportConversation() {
    final transcript = generateTranscript();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Conversation"),
        content: SingleChildScrollView(child: SelectableText(transcript)),
        actions: [
          TextButton(
            child: const Text("Copy"),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: transcript));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Conversation copied 📋")),
              );
            },
          ),
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  Widget buildMessageBubble(Message msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isUser
              ? const Color.fromARGB(255, 103, 32, 23)
              : const Color.fromARGB(255, 17, 17, 43),
          borderRadius: BorderRadius.circular(12),
        ),
        child: msg.isUser
            ? Text(msg.text, style: const TextStyle(color: Color(0xFFBFAF8F)))
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      msg.text,
                      style: const TextStyle(color: Color(0xFFBFAF8F)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      size: 18,
                      color: Color(0xFFBFAF8F),
                    ),
                    tooltip: "Copy",
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: msg.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Answer copied 💬")),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A4A),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFFBFAF8F)),
        backgroundColor: const Color.fromARGB(255, 17, 17, 43),
        title: const Text(
          "AI CHAT",
          style: TextStyle(color: Color(0xFFBFAF8F)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFE94B35)),
            tooltip: "Clear chat",
            onPressed: clearChatHistory,
          ),
          IconButton(
            icon: const Icon(Icons.email_outlined, color: Color(0xFFBFAF8F)),
            tooltip: "Export conversation",
            onPressed: exportConversation,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/wave2.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) =>
                      buildMessageBubble(messages[index]),
                ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: LoadingAnimationWidget.twistingDots(
                      leftDotColor: const Color(0xFFE94B35),
                      rightDotColor: const Color(0xFFBFAF8F),
                      size: 60,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          style: const TextStyle(color: Color(0xFFBFAF8F)),
                          obscureText: obscureText,
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFBFAF8F)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFBFAF8F)),
                            ),
                            fillColor: const Color(0xFF1A1A4A),
                            filled: true,
                            hintText: hintText,
                            hintStyle: const TextStyle(
                              color: Color(0xFFBFAF8F),
                            ),
                          ),
                          onSubmitted: sendMessage,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE94B35),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFFBFAF8F)),
                        onPressed: () => sendMessage(controller.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
