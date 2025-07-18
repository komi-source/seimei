import 'package:flutter/material.dart';
import 'package:seimei_social_app/services/auth/auth_service.dart';
import 'package:seimei_social_app/components/my_button.dart';
import 'package:seimei_social_app/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  //tap to go to register page
  final void Function()? onTap;

  RegisterPage({super.key, this.onTap});

  void register(BuildContext context) {
    //get auth service
    final _auth = AuthService();

    //passwords math -> create user
    if (_pwController.text == _confirmController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
          _confirmController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    }
    //passwords don't match  -> shoow error to user
    else {
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
      backgroundColor: Theme.of(context).colorScheme.background,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            //welcome back message
            const SizedBox(height: 50),
            Text(
              "Let's create an account for you",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 25),

            //email textf
            MyTextField(
              hintText: "example@gmail.com",
              obscuretext: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            //pw textf
            MyTextField(
              hintText: "Password..",
              obscuretext: true,
              controller: _pwController,
            ),

            SizedBox(height: 10),

            //conform pw textf
            MyTextField(
              hintText: "Confirm password..",
              obscuretext: true,
              controller: _confirmController,
            ),

            SizedBox(height: 25),
            //login button
            MyButton(text: "Register", onTap: () => register(context)),

            SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),

            //register now
          ],
        ),
      ),
    );
  }
}
