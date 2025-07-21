import 'package:flutter/material.dart';
import 'package:SEIMEI/pages/profile_page.dart';
import 'package:SEIMEI/pages/wall_page.dart';
import 'package:SEIMEI/services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 17, 17, 43),
      child: Stack(
        children: [
          // 🌊 Картинка внизу
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

          // 📋 Контент меню
          Column(
            children: [
              DrawerHeader(
                child: Center(child: Image.asset('assets/logo_sun.png')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("HOME", style: TextStyle(color: Color(0xFFBFAF8F))),
                  leading: const Icon(Icons.home, color: Color(0xFFBFAF8F)),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("PROFILE", style: TextStyle(color: Color(0xFFBFAF8F))),
                  leading: const Icon(Icons.person, color: Color(0xFFBFAF8F)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("WALL", style: TextStyle(color: Color(0xFFBFAF8F))),
                  leading: const Icon(Icons.note, color: Color(0xFFBFAF8F)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => WallPage()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("LOGOUT", style: TextStyle(color: Color(0xFFE94B35))),
                  leading: const Icon(Icons.logout, color: Color(0xFFE94B35)),
                  onTap: logout,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
