import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'Onboarding.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    call();

    /* Future.delayed(Duration(seconds: 5)).then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => Onboarding())));
  */
  }

  void call() async {
    final res = await getSettings();
    Future.delayed(Duration(seconds: 5)).then((value) => Navigator.push(context,
        MaterialPageRoute(builder: (context) => res ? Login() : Onboarding())));
  }

  static Future getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final showhome = prefs.getBool('showHome') ?? false;
    //print(showhome);
    return showhome;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ),
                Text(
                  'ECO-Farms',
                  style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 23,
                      color: HexColor("01937C")),
                ),
                const SizedBox(
                  height: 20,
                ),
                SpinKitRing(
                  color: HexColor("01937C"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
