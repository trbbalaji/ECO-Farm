import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInfo {
  getData(mobile) async {
    var status;
    try {
      const base_url = 'http://192.168.43.160:3000/api';
      Map<String, String> JsonBody = {'mobile': mobile};

      var res = await http.post(
        Uri.parse("$base_url/user"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // print(status);
      var jsonResponse = jsonDecode(res.body);
      if (res.statusCode == 200) {
        //  print(jsonResponse["locationStatus"]);
        //   return jsonResponse["locationStatus"];
        status = jsonResponse;

        //    userdata.setPincode = jsonResponse["pincode"];
      }
    } on HttpException {
      return "Serever Error";
    }

//    print(status);
    return status;
  }
}
