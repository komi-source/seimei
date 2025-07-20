import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seimei_social_app/components/my_drawer.dart';
import 'package:seimei_social_app/components/user_tile.dart';
import 'package:seimei_social_app/pages/chat_page.dart';
import 'package:seimei_social_app/services/auth/auth_service.dart';
import 'package:seimei_social_app/services/chat/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // chat and auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() => _authService.signOut();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7CCAE),
      appBar: AppBar(
        backgroundColor: Color(0xFFCFB4AB),
        elevation: 0,
        title: const Text("SEMEI Users"),
      ),
      drawer: MyDrawer(),
      body: _buildUserList(context),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Ошибка загрузки пользователей"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: Color(0xFFB57873), // насыщенный, уютный
              rightDotColor: Color(0xFFCFB4AB), // пастельная нежность
              size: 60,
            ),
          );
        }

        // полученные данные
        final List users = snapshot.data ?? [];

        // отображение списка
        return ListView(
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
