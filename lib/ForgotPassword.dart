// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:ecofarms/Login.dart';
import 'package:ecofarms/OTP.dart';
import 'package:ecofarms/PasswordOTP.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> forgotpaswordkey = GlobalKey<FormState>();
  final mobilecontroller = TextEditingController();
  bool buttonenabled = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  generateOTP(String mobile) async {
    try {
      const base_url = 'http://192.168.43.160:3000/api';
      Map<String, String> JsonBody = {'mobile': mobile};

      print(mobile);
      var res = await http.post(
        Uri.parse("$base_url/ForgetOTP"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonResponse = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final mobilekey = await SharedPreferences.getInstance();

        prefs.setString("OTPM", mobile);

        prefs.setString("mobilekey", "true");

        messageBar(color: HexColor("01937C"), msg: jsonResponse["msg"]);

        setState(() {
          buttonenabled = true;
        });

        Future.delayed(Duration(seconds: 1)).then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => PasswordOTP())));

        setState(() {
          buttonenabled = false;
        });
      } else if (res.statusCode == 400) {
        setState(() {
          buttonenabled = false;
        });
        messageBar(color: HexColor("B70404"), msg: jsonResponse["msg"]);
      } else if (res.statusCode == 404) {
        setState(() {
          buttonenabled = false;
        });
        print(res.body);
      }
    } on HttpException {
      setState(() {
        buttonenabled = false;
      });
      messageBar(color: HexColor("B70404"), msg: "Serever Error");
    } on SocketException {
      setState(() {
        buttonenabled = false;
      });
      messageBar(color: HexColor("B70404"), msg: "No Internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    String mobile;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: HexColor("9196A5"),
                    )),
              ],
            ),
            Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.1,
              child: Center(
                child: Text(
                  "Forgot Password",
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
                  "Please enter your mobile number to request a password reset",
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
            Container(
              child: Image.asset(
                "assets/images/rotation-lock.png",
                height: MediaQuery.of(context).copyWith().size.height * 0.2,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 0.9,
              child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: forgotpaswordkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        controller: mobilecontroller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: "Mobile No",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Mobile No Required"),
                          MinLengthValidator(10,
                              errorText: "10 Digit Mobile No Required"),
                          MaxLengthValidator(10,
                              errorText: "Please Enter Vallid Mobile No")
                        ]),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Column(
                children: [
                  buttonenabled == true
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("01937C"),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 15),
                            elevation: 20,
                          ),
                          onPressed: () {
                            if (forgotpaswordkey.currentState!.validate()) {
                              mobile = mobilecontroller.text;
                              setState(() {
                                buttonenabled = true;
                              });
                              generateOTP(mobile);
                            }
                          },
                          child: const Text(
                            "Request OTP",
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 18,
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> messageBar(
          {required String msg, required Color color}) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: EdgeInsets.all(16),
          height: 55,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(
            msg,
            style: TextStyle(fontFamily: 'Lexend', fontSize: 15),
          ),
        ),
      ));
}
