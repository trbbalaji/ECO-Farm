import 'package:ecofarms/Login.dart';
import 'package:ecofarms/OTP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> forgotpaswordkey = GlobalKey<FormState>();
  final mobilecontroller = TextEditingController();

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
                  key: forgotpaswordkey,
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("01937C"),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        elevation: 20,
                      ),
                      onPressed: () async {
                        if (forgotpaswordkey.currentState!.validate()) {
                          String mobile = mobilecontroller.text;
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("OTPM", mobile);
                          Future.delayed(Duration(seconds: 5)).then((value) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OTP())));

                          //login(email,password);
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
}
