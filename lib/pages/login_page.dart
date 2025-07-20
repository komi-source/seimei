import 'package:flutter/material.dart';
import 'package:seimei_social_app/services/auth/auth_service.dart';
import 'package:seimei_social_app/components/my_button.dart';
import 'package:seimei_social_app/components/my_textfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            "There's no account like this or you have bad internet connection. Please try again.",
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
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
            : buildLoginForm(),
      ),
    );
  }

  Widget buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.message, size: 60, color: Colors.black),
        const SizedBox(height: 50),
        Text(
          "Welcome back, you've been missed!",
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
        const SizedBox(height: 25),
        MyButton(text: "Login", onTap: login),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Not a member? ", style: TextStyle(color: Color(0xFFB57873))),
            GestureDetector(
              onTap: widget.onTap,
              child: Text(
                "Register now",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB57873),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
