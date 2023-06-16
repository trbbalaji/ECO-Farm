// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ecofarms/Dashboard.dart';
import 'package:ecofarms/UserInfo.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class WeatherReport extends StatefulWidget {
  const WeatherReport({super.key});

  @override
  State<WeatherReport> createState() => _WeatherReportState();
}

class _WeatherReportState extends State<WeatherReport> {
  UserInfo u = UserInfo();
  String imgurl = "null";
  @override
  void initState() {
    // TODO: implement initState

    getdata();
  }

  var city = null;
  getdata() async {
    final prefs = await SharedPreferences.getInstance();
    var mobile = prefs.getString("userid");
    var res = await u.getData(mobile);
    city = res["city"];
  }

//int currYear = nowDate.year;
  int _selectedIndex = 0;

  Tomorrow() {
    var tomorrow = DateTime.now().add(Duration(days: 1));

    return DateFormat.yMMMEd().format(tomorrow);
  }

  WeatherData(day) async {
    try {
      const base_url = 'http://192.168.43.160:3000/location';
      print(city);
      Map<String, String> JsonBody = {"city": city, "day": day};

      var res = await http.post(
        Uri.parse("$base_url/weather"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonResponse = await jsonDecode(res.body);

      if (res.statusCode == 200) {
        imgurl = jsonResponse["imgurl"];

        print("imgurl");
        imgurl = imgurl.replaceAll('"', '');
        print("2@ $imgurl");
      } else if (res.statusCode == 400) {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 140, // Set this height
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
              color: HexColor("01937C"),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 28,
                            color: HexColor("FFFFFF"),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Center(
                        child: Text(
                          "Weather Condition",
                          style: const TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          _selectedIndex == 0
                              ? DateFormat.yMMMEd().format(DateTime.now())
                              : (_selectedIndex == 1
                                  ? Tomorrow()
                                  : "Weekly Report"),
                          style: const TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              )),
        ),
        body: Container(
          child: getPage(),
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: HexColor("FF0060"),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.today_outlined),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Tomorrow',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Next Week',
            ),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(_selectedIndex);
    _selectedIndex == 0
        ? WeatherData("today")
        : (_selectedIndex == 1 ? WeatherData("tomorrow") : "");
  }

  Widget getPage() {
    List<Widget> _widgetOptions = [
      Container(
          child: Column(
        children: [
          Row(
            children: [],
          )
        ],
      )),
      Container(
        alignment: Alignment.center,
        child: Text(
          "Users",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          "Messages",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    ];
    return IndexedStack(
      index: _selectedIndex,
      children: _widgetOptions,
    );
  }
}

//Widget WeatherLayer({required String date}) => Container();
