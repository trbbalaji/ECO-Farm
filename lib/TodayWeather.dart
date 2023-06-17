import 'package:ecofarms/DayWeather.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserInfo.dart';

class TodayWeather extends StatefulWidget {
  const TodayWeather({super.key});

  @override
  State<TodayWeather> createState() => _TodayWeatherState();
}

class _TodayWeatherState extends State<TodayWeather> {
  UserInfo u = UserInfo();
  var cc;
  bool btnenble = true;
  DayWeather daysData = new DayWeather();
  WeatherToday(city, day) async {
    try {
      print("tod  $day");
      var res = await http.get(
        Uri.parse(
            "http://api.worldweatheronline.com/premium/v1/weather.ashx?key=5ab79e508bd240a7916103836231706&q=$city&format=json&num_of_days=0&date=$day"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonResponse = jsonDecode(res.body);
      print(jsonResponse);
      var tempC = jsonResponse["data"]["current_condition"][0]["temp_C"];
      var h = jsonResponse["data"]["current_condition"][0]["humidity"];
      var w = jsonResponse["data"]["current_condition"][0]["windspeedKmph"];
      var imgurl;
      cc = tempC;
      var status = jsonResponse["data"]["current_condition"][0]["weatherDesc"]
          [0]["value"];
      print("ss$status");
      if (status.startsWith("Partly cloudy")) {
        imgurl = "assets/images/partly-cloudy.png";
      } else if (status.startsWith("Cloudy")) {
        imgurl = "assets/images/cloudy.png";
      } else if (status.startsWith("Light Drizzle")) {
        imgurl = "assets/images/drizzle-1.png";
      } else if (status.startsWith("Mist")) {
        imgurl = "assets/images/mist.png";
      } else if (status.startsWith("Haze")) {
        imgurl = "assets/images/haze.png";
      } else {
        imgurl = "assets/images/cloudy.png";
      }

      daysData.setStatus = status;
      daysData.setImgurl = imgurl;
      daysData.setH = h;
      daysData.setWind = w;
      daysData.setTempc = tempC;
      setState(() {
        btnenble = false;
      });
    } catch (e) {}
  }

  Future getdata() async {
    var city;
    var datekey;
    final prefs = await SharedPreferences.getInstance();
    var mobile = prefs.getString("userid");
    var res = await u.getData(mobile);
    city = res["city"];
    var d = new DateFormat('yyyy-MM-dd');
    var today = DateTime.now();
    datekey = DateFormat("yyyy-MM-dd").format(today);
    print("p1 $city");
    WeatherToday(city, datekey);
  }

  @override
  void initState() {
    // TODO: implement initState

    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        child: FutureBuilder(
          builder: (context, snapshot) {
            return snapshot.hasError
                ? Container()
                : btnenble == true
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                            ),
                          )
                        ],
                      )
                    : Container(
                        child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                daysData.getImgurl,
                                height: 120,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                daysData.getStatus,
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  fontSize: 20,
                                  color: HexColor("344D67"),
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 13),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      "assets/images/hot.png",
                                      height: 70,
                                    ),
                                    Text(
                                      cc,
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 27,
                                        color: HexColor("344D67"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Image.asset(
                                      "assets/images/cloud.png",
                                      height: 70,
                                    ),
                                    Text(
                                      daysData.h,
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 27,
                                        color: HexColor("344D67"),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Temperature",
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 17,
                                        color: HexColor("344D67"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      "Humidity",
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 17,
                                        color: HexColor("344D67"),
                                      ),
                                    )
                                  ],
                                ),
                                /*1 row 2 */
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        "assets/images/wind.png",
                                        height: 70,
                                      ),
                                    ),
                                    Text(
                                      daysData.getWind,
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 27,
                                        color: HexColor("344D67"),
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Wind",
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 17,
                                        color: HexColor("344D67"),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(
                                      "",
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 17,
                                        color: HexColor("344D67"),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                          // Text(daysData.getStatus == null
                          //     ? CircularProgressIndicator(
                          //         valueColor: AlwaysStoppedAnimation(
                          //             Theme.of(context).primaryColor),
                          //       )
                          //     : daysData.getStatus)
                        ],
                      ));
          },
        ),
      ),
    ));
  }
}

class WeatherInfo {
  var temp_c;
  var h;
  var imgurl;
  var wind;
  var status;
  WeatherInfo(this.temp_c, this.h, this.imgurl, this.wind, this.status);
}
