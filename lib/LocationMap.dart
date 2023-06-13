import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final locationcontroller = TextEditingController();
  List<String> _data = [];
  bool buttonenabled = false;

  // final duplicateItems = List<String>.generate(10000, (i) => "$i");
  getLocation(String location) async {
    try {
      if (location.length > 3 && location != null) {
        setState(() {
          _data = [];
        });
        var res = await http.get(
          Uri.parse(
              "https://api.geoapify.com/v1/geocode/autocomplete?text='+$location+'&format=json&apiKey=84d83101ad254ed3a37a26f9d04503da"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        print('Empty1');
        var jsonResponse = jsonDecode(res.body);

        print(jsonResponse["results"].length);
        for (var i = 0; i < jsonResponse["results"].length; i++) {
          print(jsonResponse["results"][i]["formatted"]);
          setState(() {
            _data.add(jsonResponse["results"][i]["formatted"]);
          });
        }
      } else {
        print('Empty');
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

  void filterSearchResults(String query) {
    setState(() {
      _data = _data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String location = 'Null, Press Button';
  String Address = 'search';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              width: MediaQuery.of(context).copyWith().size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: HexColor("01937C"),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Select Location",
                    style: TextStyle(
                        color: HexColor("FFFFFF"),
                        fontFamily: 'Lexend',
                        fontSize: 21),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).copyWith().size.width * 0.9,
              child: Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: locationcontroller,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.near_me),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          border: OutlineInputBorder(),
                          labelText: "Location",
                        ),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "* Location is Required "),
                          MinLengthValidator(3,
                              errorText: "Minimum 3 Character is Required")
                        ]),
                        onChanged: (value) {
                          if (formkey.currentState!.validate()) {
                            //print("Hellow $value");
                            _data = [];
                            if (value != null) {
                              print("Hello");
                              // print("hhh$value");
                            }

                            // getLocation(value);
                          }
                          //
                        },
                        keyboardType: TextInputType.streetAddress,
                      ),

                      //  ListView.builder(itemBuilder: )
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   location,
                  //   style: TextStyle(color: Colors.black, fontSize: 16),
                  // ),
                  ElevatedButton(
                      onPressed: () async {
                        Position position = await _getGeoLocationPosition();
                        location =
                            'Lat: ${position.latitude} , Long: ${position.longitude}';
                      },
                      child: Text('Get Location'))
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: _data.length,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _data[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                    leading: Icon(Icons.location_on_outlined),
                  );
                },
              ),
            )

            // Container()
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
