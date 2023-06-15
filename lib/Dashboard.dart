import 'package:ecofarms/User.dart';
import 'package:ecofarms/UserInfo.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User.dart';
import 'Loading.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User userdata = User();
  logout() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove("LoginStatus");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Loading()));
  }

  @override
  void initState() {
    // TODO: implement initState
    //  otpMobileNo();
    super.initState();
  }

  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    var mobile = prefs.getString("userid");
    UserInfo u = UserInfo();
    print(await u.getData(mobile));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          getdata();
                        },
                        icon: Icon(
                          Icons.sort,
                          color: Colors.black,
                        )),
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "ECO",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Lexend',
                              color: HexColor("1B9C85"))),
                      TextSpan(
                          text: " Farm",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Lexend',
                              color: HexColor("4C4C6D"))),
                    ])),
                    IconButton(
                        onPressed: () {
                          // logout();
                        },
                        icon: Icon(
                          Icons.power_settings_new_rounded,
                          color: Colors.black,
                        )),
                  ],
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: HexColor("FFFFFF"),
                automaticallyImplyLeading: false)
            /* body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.3,
            width: MediaQuery.of(context).copyWith().size.width,
            color: HexColor("1B9C85"),
            child: Column(
              children: [
                Text("Hi"),
                Row(
                  children: [Text("welcome")],
                )
              ],
            ),
          )
        ],
      ),
    )*/

            ));
  }
}
/*
 Scaffold(
            appBar: AppBar(
                title: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.sort,
                          color: Colors.black,
                        ))
                  ],
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: HexColor("FFFFFF"),
                automaticallyImplyLeading: false),
            body: SingleChildScrollView())

 */