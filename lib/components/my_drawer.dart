import 'package:flutter/material.dart';
import 'package:SEIMEI/pages/profile_page.dart';
import 'package:SEIMEI/pages/wall_page.dart';
import 'package:SEIMEI/services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    //get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFC0AF99),
      child: Column(
        children: [
          Column(
            children: [
              //logo
              DrawerHeader(
                child: Center(child: Image.asset('assets/logo.png')),
              ),

              //home list
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("HOME"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("PROFILE"),
                  leading: Icon(Icons.person),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);

                    //navigate to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ),

              //settings list
              // Padding(
              //   padding: const EdgeInsets.only(left: 25.0),
              //   child: ListTile(
              //     title: Text("SETTINGS"),
              //     leading: Icon(Icons.settings),
              //     onTap: () {
              //       //pop the drawer
              //       Navigator.pop(context);

              //       //navigate to settings page
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => SettingsPage()),
              //       );
              //     },
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("WALL"),
                  leading: Icon(Icons.note),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);

                    //navigate to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WallPage()),
                    );
                  },
                ),
              ),
              //logout
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("LOGOUT"),
                  leading: Icon(Icons.logout),
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
