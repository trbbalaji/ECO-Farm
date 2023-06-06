import 'package:ecofarms/ForgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  GlobalKey<FormState> forgotpaswordkey = GlobalKey<FormState>();
  final mobilecontroller = TextEditingController();
  String otpno = "";
  @override
  void initState() {
    // TODO: implement initState
    otpMobileNo();
    super.initState();
  }

  void otpMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    otpno = prefs.getString("OTPM")!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: HexColor("9196A5"),
                    )),
              ],
            ),
            Container(
              // width: MediaQuery.of(context).copyWith().size.width * 0.6,
              child: Center(
                child: Text(
                  "Enter OTP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 25,
                    color: HexColor("344D67"),
                  ),
                ),
              ),
            ),
            Container(
              child: Image.asset(
                "assets/images/otplogo.jpg",
                height: MediaQuery.of(context).copyWith().size.height * 0.3,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Center(
                child: Text(
                  "We have sent the code \n verification to your mobile",
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
              height: 10,
            ),
            Container(
              child: Center(
                child: Text(
                  otpno,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 17,
                    color: HexColor("FF0060"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 0.9,
              child: Form(
                  key: forgotpaswordkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: mobilecontroller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: "OTP",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* OTP is Required"),
                          MinLengthValidator(6,
                              errorText: "Please Enter 6 Digit OTP Required"),
                          MaxLengthValidator(6,
                              errorText: "Please Enter Vallid OTP")
                        ]),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
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
                  "Resend OTP",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lexend',
                      color: HexColor("9196A5")),
                ),
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("01937C"),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        elevation: 20,
                      ),
                      onPressed: () {
                        if (forgotpaswordkey.currentState!.validate()) {
                          String mobile = mobilecontroller.text;

                          //login(email,password);
                        }

                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (content) => OTP()));
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 18,
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
