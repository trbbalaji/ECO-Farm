import 'package:ecofarms/ForgotPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  GlobalKey<FormState> forgotpaswordkey = GlobalKey<FormState>();
  final otpcontroller = TextEditingController();
  String mobileNO = "";
  bool buttonenabled = false;
  @override
  void initState() {
    // TODO: implement initState
    otpMobileNo();
    super.initState();
  }

  void otpMobileNo() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNO = prefs.getString("OTPM")!;
    //print(mobileNO);
  }

  verifyOTP(String mobile, String otp) async {
    try {
      const base_url = 'http://192.168.43.160:3000/api';
      Map<String, String> JsonBody = {'mobile': mobile, 'otp': otp};

      print(mobile);
      var res = await http.post(
        Uri.parse("$base_url/verifyOTP"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonResponse = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("OTPM", mobile);

        messageBar(color: HexColor("01937C"), msg: jsonResponse["msg"]);

        setState(() {
          buttonenabled = true;
        });

        Future.delayed(Duration(seconds: 1)).then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login())));

        setState(() {
          buttonenabled = false;
        });
        messageBar(color: HexColor("01937C"), msg: "Please Login your Account");
        prefs.remove("OTPM");
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
                  mobileNO,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: forgotpaswordkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(6)],
                        controller: otpcontroller,
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
            /* OtpTextField(
              mainAxisAlignment: MainAxisAlignment.center,
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              keyboardType: TextInputType.number,
              onSubmit: (value) {},
            ),*/
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
                              String otp = otpcontroller.text;
                              String mobile = mobileNO;
                              setState(() {
                                buttonenabled = true;
                              });
                              verifyOTP(mobile, otp);
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
