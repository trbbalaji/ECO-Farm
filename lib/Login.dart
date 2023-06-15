// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:io';

import 'package:ecofarms/LocationPage.dart';
import 'package:ecofarms/Register.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';
import 'ForgotPassword.dart';
import 'package:flutter/services.dart';
import 'User.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final mobilecontroller = TextEditingController();
  final passwordcontrol = TextEditingController();
  bool buttonenabled = false;

  login(String mobile, String password) async {
    const base_url = 'http://192.168.43.160:3000/api';
    try {
      const base_url = 'http://192.168.43.160:3000/api';
      Map<String, String> JsonBody = {'mobile': mobile, 'password': password};

      var res = await http.post(
        Uri.parse("$base_url/login"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonResponse = jsonDecode(res.body);

      if (res.statusCode == 200) {
        //messageBar(color: HexColor("01937C"), msg: "Successfully Login");
        var resforuser = await getData(mobile);
        print("hir $resforuser");
        final prefs = await SharedPreferences.getInstance();

        prefs.setString("userid", mobile);

        setState(() {
          buttonenabled = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    resforuser ? Dashboard() : LocationPage()));
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
  void initState() {
    // TODO: implement initState
    //  otpMobileNo();
    super.initState();
  }

  getData(mobile) async {
    var status = false;
    try {
      const base_url = 'http://192.168.43.160:3000/api';
      Map<String, String> JsonBody = {'mobile': mobile};

      var res = await http.post(
        Uri.parse("$base_url/user"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(status);
      var jsonResponse = jsonDecode(res.body);
      if (res.statusCode == 200) {
        //  print(jsonResponse["locationStatus"]);
        //   return jsonResponse["locationStatus"];
        status = jsonResponse["locationStatus"];

        //    userdata.setPincode = jsonResponse["pincode"];
      }
    } on HttpException {
      return "Serever Error";
    }

//    print(status);
    return status;
  }

  void otpMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    // print(prefs.getString("OTPM"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(children: [
      Container(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 180,
              ),
            ),
            Center(
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
              TextSpan(
                  text: "Welcome to",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lexend',
                      color: HexColor("9196A5"))),
              TextSpan(
                  text: " ECO-Farm",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lexend',
                      color: HexColor("01937C"))),
            ]))),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 0.9,
              child: Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: passwordcontrol,
                          obscureText: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 10.0),
                            border: OutlineInputBorder(),
                            labelText: "Password",
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "*Password is Required"),
                            MinLengthValidator(8,
                                errorText:
                                    "Password should be atleast 8 characters"),
                          ]))
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 1.9,
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
                                horizontal: 135, vertical: 15),
                            elevation: 20,
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              String mobile = mobilecontroller.text;
                              String password = passwordcontrol.text;
                              setState(() {
                                buttonenabled = true;
                              });
                              login(mobile, password);
                            }
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 18,
                                wordSpacing: 15),
                          ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                // ignore: sort_child_properties_last ForgotPassword()
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      color: HexColor("01937C")),
                ),
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Register();
                  }));
                },
                // ignore: sort_child_properties_last
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Don't have an account ?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lexend',
                          color: HexColor("9196A5"))),
                  TextSpan(
                      text: " Register",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Lexend',
                        color: HexColor("01937C"),
                      )),
                ])),
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
              ),
            )
          ],
        ),
      )
    ]))));
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
