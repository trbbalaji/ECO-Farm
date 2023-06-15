import 'package:ecofarms/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool buttonenabled = false;
  var location = "Null";
  String Address = 'search';

  @override
  void initState() {
    super.initState();
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  locationProcesss(double lat, double lon) async {
    print("Hi");
    print("$lat $lon");
    final prefs = await SharedPreferences.getInstance();
    var mobile = prefs.getString("userid");
    print(prefs.getString("userid"));
    print(double.parse(mobile!));

    try {
      const base_url = 'http://192.168.43.160:3000/location';
      // ignore: non_constant_identifier_names
      Map<String, double> JsonBody = {
        'mobile': double.parse(mobile!),
        'lat': lat,
        'lon': lon
      };

      var res = await http.post(
        Uri.parse("$base_url/locationSave"),
        body: jsonEncode(JsonBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var jsonResponse = jsonDecode(res.body);
      print(jsonResponse);
      if (res.statusCode == 200) {
        messageBar(color: HexColor("01937C"), msg: jsonResponse["msg"]);

        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('LocationStatus', true);
        // prefs.setString("userid", mobile);
        prefs.setBool('LoginStatus', true);
        setState(() {
          buttonenabled = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        }));
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
            SizedBox(
              height: MediaQuery.of(context).copyWith().size.height * 0.2,
            ),
            Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.1,
              child: Center(
                child: Text(
                  "Select Location",
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
                  "Please enable your GPS OR \n click the get Location Button\n Allow GPS Permission",
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
                "assets/images/map.png",
                height: MediaQuery.of(context).copyWith().size.height * 0.2,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 1.8,
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
                                horizontal: 75, vertical: 15),
                            elevation: 20,
                          ),
                          onPressed: () async {
                            double lat = 0;
                            double lon = 0;
                            if (location == "Null") {
                              setState(() {
                                buttonenabled = true;
                              });
                              Position position =
                                  await _getGeoLocationPosition();

                              location =
                                  "${position.latitude},${position.longitude}";

                              lat = position.latitude;
                              lon = position.longitude;
                            }

                            if (location != "Null") {
                              // setState(() {
                              //   buttonenabled = false;
                              // });
                              //
                              locationProcesss(lat, lon);
                              location = "Null";
                            }
                          },
                          child: const Text(
                            "Enable GPS",
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
