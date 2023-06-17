import 'dart:io';

import 'package:ecofarms/DayWeather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherDay {
  DayWeather d = DayWeather();
  getData(city, day) async {
    var status;
    try {
      var res = await http.get(
        Uri.parse(
            "http://api.worldweatheronline.com/premium/v1/weather.ashx?key=b23bd781d9bd4239bab174141231006&q=$city&format=json&num_of_days=0&date=$day"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var jsonResponse = await jsonDecode(res.body);
      if (res.statusCode == 200) {
        var today_s = jsonResponse["data"]["current_condition"][0]
            ["weatherDesc"][0]["value"];
        String imgurl = "null";
        if (today_s.startsWith("Partly cloudy")) {
          imgurl = "assets/images/Partly-cloudy.png";
        } else if (today_s.startsWith("Cloudy")) {
          imgurl = "assets/images/cloudy.png";
        } else if (today_s.startsWith("Light Drizzle")) {
          imgurl = "assets/images/drizzle-1.png";
        } else if (today_s.startsWith("Mist")) {
          imgurl = "assets/images/mist.png";
        }

        d.setStatus = jsonResponse["data"]["current_condition"][0]
            ["weatherDesc"][0]["value"];
        d.tempc = jsonResponse["data"]["current_condition"][0]["temp_C"];
        d.h = jsonResponse["data"]["current_condition"][0]["humidity"];
        d.imgurl = imgurl;

        status = {
          "temp_c": jsonResponse["data"]["current_condition"][0]["temp_C"],
          "h": jsonResponse["data"]["current_condition"][0]["humidity"],
          "w": jsonResponse["data"]["current_condition"][0]["windspeedKmph"],
          "s": jsonResponse["data"]["current_condition"][0]["weatherDesc"][0]
              ["value"],
          "img": imgurl
        };
      }
    } on HttpException {
      return "Serever Error";
    }

//    print(status);
    return status;
  }
}
