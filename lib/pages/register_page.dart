import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seimei_social_app/services/auth/auth_service.dart';
import 'package:seimei_social_app/components/my_button.dart';
import 'package:seimei_social_app/components/my_textfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool isLoading = false;

  void register() async {
    final _auth = AuthService();

    // сбросим фокус клавиатуры
    FocusScope.of(context).unfocus();

    if (_pwController.text == _confirmController.text) {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
          _confirmController.text,
        );

        //after creating the user, create a new document in a firebase
        FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.email)
            .set({
              'username': _emailController.text.split('@')[0], //nn
              'bio': 'Empty bio..',
            });
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }

      setState(() {
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match! Please try again"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7CCAE),
      body: Center(
        child: isLoading
            ? LoadingAnimationWidget.twistingDots(
                leftDotColor: Color(0xFFB57873), // тёплый акцентный
                rightDotColor: Color(0xFFCFB4AB), // пастельный нюанс
                size: 60,
              )
            : buildForm(),
      ),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.message, size: 60),
          const SizedBox(height: 50),
          Text(
            "Let's create an account for you",
            style: TextStyle(fontSize: 20, color: Color(0xFFB57873)),
          ),
          const SizedBox(height: 25),
          MyTextField(
            hintText: "example@gmail.com",
            obscuretext: false,
            controller: _emailController,
          ),
          const SizedBox(height: 10),
          MyTextField(
            hintText: "Password..",
            obscuretext: true,
            controller: _pwController,
          ),
          const SizedBox(height: 10),
          MyTextField(
            hintText: "Confirm password..",
            obscuretext: true,
            controller: _confirmController,
          ),
          const SizedBox(height: 25),
          MyButton(text: "Register", onTap: register),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(color: Color(0xFFB57873)),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  "Login now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB57873),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
