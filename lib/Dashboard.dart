import 'package:ecofarms/User.dart';
import 'package:ecofarms/UserInfo.dart';
import 'package:ecofarms/WeatherReport.dart';
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
    getdata();
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
                    Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                    /* Builder(
                  builder: (context) => IconButton(
                      onPressed: () {
                        // getdata();
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.sort,
                        color: Colors.black,
                      ))),*/
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
                          logout();
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
                automaticallyImplyLeading: false),

            /*drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Abhishek Mishra"),
              accountEmail: Text("abhishekm977@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text("Contact Us"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),*/
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    // height: MediaQuery.of(context).copyWith().size.height * 0.4,
                    child: Column(
                      children: [
                        Text("Hi",
                            style: TextStyle(
                              fontSize: 26,
                              fontFamily: 'Lexend',

                              //    color: HexColor("9196A5")
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 20.0, right: 25.0, left: 25.0),
                    child: Container(
                        width: double.infinity,
                        height: 350.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0.0, 3.0),
                                  blurRadius: 15.0)
                            ]),
                        child: Column(children: <Widget>[
                          /*  SizedBox(
                          height: 15,
                        ),
                  Container(
  
                margin: EdgeInsets.symmetric(horizontal:35),
          
                   
               child: Row(
                children: [
    //   Text("Digital Service Dashboard",
              Text("Category",
      
             style: GoogleFonts.robotoMono(
             fontSize: 18,
             color: Colors.grey[700],
             fontWeight: FontWeight.bold
     
       ),
       
       ),
      ],
    ),
   
  ),*/
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 40.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(children: <Widget>[
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.cyan.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.storage),
                                          color: Colors.cyan,
                                          iconSize: 35.0,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WeatherReport()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('JRDC/SWDC',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Column(children: <Widget>[
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.green.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.phone_iphone),
                                          color: Colors.green,
                                          iconSize: 35.0,
                                          onPressed: () {
                                            //      Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoard()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(' LPS ',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Column(children: <Widget>[
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.purple.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.storage),
                                          color: Colors.purple,
                                          iconSize: 35.0,
                                          onPressed: () {
                                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=>QRDC()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('QRDC/GTDC',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ])),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28.0, vertical: 0.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(children: <Widget>[
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.orange.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.inventory_outlined),
                                          color: Colors.orange,
                                          iconSize: 35.0,
                                          onPressed: () {
                                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>JRDCTable()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('JRDC Report',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Column(children: <Widget>[
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color:
                                            Colors.redAccent.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.running_with_errors),
                                          color: Colors.redAccent,
                                          iconSize: 35.0,
                                          onPressed: () {
                                            //       Navigator.push(context, MaterialPageRoute(builder: (context)=>Except()));
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('Exception',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Column(children: <Widget>[
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.teal.withOpacity(0.1),
                                        child: IconButton(
                                          padding: EdgeInsets.all(15.0),
                                          icon: Icon(Icons.inventory_outlined),
                                          color: Colors.teal,
                                          iconSize: 35.0,
                                          onPressed: () {},
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text('QRDC Report',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ]))

                          /*  */
                        ])),
                  ),
                ],
              ),
            )));
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
