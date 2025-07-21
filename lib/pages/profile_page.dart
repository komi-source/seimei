import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A4A),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 17, 17, 43),
        title: Text("Profile", style: TextStyle(color: Color(0xFFD3C9A1))),
      ),
      body: ListView(
        children: [
          //profile pic
          SizedBox(height: 50),
          Icon(Icons.person, size: 72, color: Color(0xFFD3C9A1)),

          //email name
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFD3C9A1), fontSize: 20),
          ),

          //user details

          //username

          //bio

          //user posts
        ],
      ),
    );
  }
}
