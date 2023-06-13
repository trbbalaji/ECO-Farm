import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Loading.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  logout() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Loading()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HexColor("01937C"),
                padding:
                    const EdgeInsets.symmetric(horizontal: 135, vertical: 15),
                elevation: 20,
              ),
              onPressed: () {
                logout();
              },
              child: const Text(
                "Login",
                style: TextStyle(
                    fontFamily: 'Lexend', fontSize: 18, wordSpacing: 15),
              )),
        ),
      ),
    ));
  }
}
