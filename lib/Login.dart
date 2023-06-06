// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';
import 'ForgotPassword.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final mobilecontroller = TextEditingController();
  final passwordcontrol = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  child: Column(
                    children: <Widget>[
                      TextFormField(
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
                  ElevatedButton(
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
                          //login(email,password);
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
                // ignore: sort_child_properties_last
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
                onPressed: () {},
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
}
