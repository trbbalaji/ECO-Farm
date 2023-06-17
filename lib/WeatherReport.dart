// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ecofarms/Dashboard.dart';
import 'package:ecofarms/DayWeather.dart';
import 'package:ecofarms/Model/WeatherModel.dart';
import 'package:ecofarms/TodayWeather.dart';
import 'package:ecofarms/TomorrowWeather.dart';

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
  String weatherDsc = "null";
  bool isLoading = false;

  bool btnenable = false;

  var city = null;
  var weatherBaseData;

//int currYear = nowDate.year;
  int _selectedIndex = 0;
  var cel;
  Tomorrow() {
    var tomorrow = DateTime.now().add(Duration(days: 1));

    return DateFormat.yMMMEd().format(tomorrow);
  }

  @override
  void initState() {}

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  //var _widgetOptions = [TodayWeather()];
  List _widgetOptions = [
    TodayWeather(),
    TomorrowWeather(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

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
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        // body: Container(child: getPage(context)),
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
  }
}
/*
*/

class WeatherInfo {
  var temp_c;
  var h;
  var imgurl;
  var wind;
  var status;
  WeatherInfo(this.temp_c, this.h, this.imgurl, this.wind, this.status);
}
