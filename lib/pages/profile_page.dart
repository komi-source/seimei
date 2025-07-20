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
      backgroundColor: Color(0xFFD7CCAE),
      appBar: AppBar(
        backgroundColor: Color(0xFFC0AF99),
        title: Text("Profile"),
      ),
      body: ListView(
        children: [
          //profile pic
          SizedBox(height: 50),
          Icon(Icons.person, size: 72),

          //email name
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20),
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
