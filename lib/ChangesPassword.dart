import 'package:ecofarms/Login.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangesPassword extends StatefulWidget {
  const ChangesPassword({super.key});

  @override
  State<ChangesPassword> createState() => _ChangesPasswordState();
}

class _ChangesPasswordState extends State<ChangesPassword> {
  GlobalKey<FormState> changepasswordkey = GlobalKey<FormState>();
  final passwordcontrol = TextEditingController();
  final confirmpasswordcontrol = TextEditingController();
  bool buttonenabled = false;
  String mobileNO = "";
  String password = "";
  String confirmpassword = "";
  @override
  void initState() {
    // TODO: implement initState
    otpMobileNo();
    super.initState();
  }

  void otpMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNO = prefs.getString("OTPM")!;
    print(mobileNO);
  }

  changePasswordfun(String mobile, String password) async {
    try {
      const base_url = 'http://192.168.43.160:3000/api';
      Map<String, String> JsonBody = {'mobile': mobile, 'password': password};

      var res = await http.post(
        Uri.parse("$base_url/changePassword"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonResponse = jsonDecode(res.body);

      if (res.statusCode == 200) {
        messageBar(color: HexColor("01937C"), msg: jsonResponse["msg"]);

        setState(() {
          buttonenabled = true;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Login();
        }));

        setState(() {
          buttonenabled = false;
        });
        messageBar(color: HexColor("01937C"), msg: "Please Login your Account");
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            // width: MediaQuery.of(context).copyWith().size.width * 0.6,
            child: Center(
              child: Text(
                "Create new Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 25,
                  color: HexColor("344D67"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(
              child: Text(
                "Your new password must be different \n from previous used password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 17,
                  color: HexColor("01937C"),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).copyWith().size.width * 0.9,
            child: Form(
                key: changepasswordkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: passwordcontrol,
                        obscureText: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: "Pasword",
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                        validator: MultiValidator([
                          RequiredValidator(errorText: "*Password is Required"),
                          MinLengthValidator(8,
                              errorText:
                                  "Password should be at least 8 characters"),
                        ])),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                        controller: confirmpasswordcontrol,
                        obscureText: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: "Confirm Password",
                        ),
                        onChanged: (value) {
                          confirmpassword = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "*Confirm Password is Required";
                          }
                          if (value != password) {
                            return "*Password do not match";
                          }
                        })
                  ],
                )),
          ),
          SizedBox(
            height: 40,
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
                              horizontal: 100, vertical: 15),
                          elevation: 20,
                        ),
                        onPressed: () {
                          if (changepasswordkey.currentState!.validate()) {
                            String password = passwordcontrol.text;
                            String mobile = mobileNO;
                            setState(() {
                              buttonenabled = true;
                            });

                            changePasswordfun(mobile, password);
                          }

                          // Navigator.pushReplacement(context,
                          //     MaterialPageRoute(builder: (content) => OTP()));
                        },
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 18,
                          ),
                        ))
              ],
            ),
          ),
        ])),
      ),
    );
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
