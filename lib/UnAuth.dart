import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'Login.dart';

class UnAuth extends StatefulWidget {
  const UnAuth({super.key});

  @override
  State<UnAuth> createState() => _UnAuthState();
}

class _UnAuthState extends State<UnAuth> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              child: Image.asset(
                "assets/images/unavailable.png",
                height: MediaQuery.of(context).copyWith().size.height * 0.2,
                alignment: Alignment.center,
              ),
            ),
            Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.1,
              child: Center(
                child: Text(
                  "UnAuthorized Access",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 27,
                    color: HexColor("344D67"),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  "Please Login your Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 17,
                    color: HexColor("01937C"),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor("01937C"),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                  elevation: 20,
                ),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 18,
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
