import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';

import 'Login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final mobilecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontrol = TextEditingController();
  bool buttonenabled = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: MediaQuery.of(context).copyWith().size.height * 0.2,
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
            Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.1,
              child: Center(
                child: Text(
                  "Register your Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 24,
                    color: HexColor("344D67"),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 0.9,
              child: Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: mobilecontroller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: "Name",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Name is Required"),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailcontroller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Email is Required"),
                          EmailValidator(errorText: "Invalid Email Id")
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                              //   login(mobile, password);
                            }
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 18,
                                wordSpacing: 15),
                          )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login();
                  }));
                },
                // ignore: sort_child_properties_last
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Have an account ?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Lexend',
                          color: HexColor("9196A5"))),
                  TextSpan(
                      text: " Login",
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
      ),
    ));
  }
}
