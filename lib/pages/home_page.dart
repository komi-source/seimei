import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:SEIMEI/components/my_drawer.dart';
import 'package:SEIMEI/components/user_tile.dart';
import 'package:SEIMEI/pages/chat_page.dart';
import 'package:SEIMEI/services/auth/auth_service.dart';
import 'package:SEIMEI/services/chat/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() => _authService.signOut();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A4A),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFBFAF8F)),
        backgroundColor: Color.fromARGB(255, 17, 17, 43),
        elevation: 0,
        title: const Text(
          "SEIMEI Users",
          style: TextStyle(color: Color(0xFFBFAF8F)),
        ),
      ),
      drawer: MyDrawer(),

      // 🎨 Слой с фоном + списком
      body: Stack(children: [_buildUserList(context)]),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "User list error",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // 🔧 Показываем анимацию, пока идет загрузка
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: Color(0xFFE94B35),
              rightDotColor: Color(0xFFBFAF8F),
              size: 60,
            ),
          );
        }

        // 📋 Когда пользователи загружены, строим список
        final List users = snapshot.data ?? [];

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 12),
          children: users.map<Widget>((userData) {
            if (userData is Map<String, dynamic>) {
              final email = userData["email"];
              final uid = userData["uid"];

              if (email != null &&
                  uid != null &&
                  email != _authService.getCurrentUser()?.email) {
                return UserTile(
                  text: email,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(recieverEmail: email, receiverID: uid),
                      ),
                    );
                  },
                );
              }
            }
            return const SizedBox.shrink(); // если данные некорректны
          }).toList(),
        );
      },
    );
  }
}
