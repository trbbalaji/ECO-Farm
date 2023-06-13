import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

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

  locationProcesss(locationData) async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString("userid"));
    setState(() {
      buttonenabled = false;
    });
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
              children: [
                SizedBox(
                  width: 15,
                ),
              ],
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
                            print("hhh");
                            print(buttonenabled);

                            if (location == "Null") {
                              setState(() {
                                buttonenabled = true;
                              });
                              Position position =
                                  await _getGeoLocationPosition();

                              location =
                                  "${position.latitude},${position.longitude}";
                            }
                            print(location);
                            if (location != "Null") {
                              // setState(() {
                              //   buttonenabled = false;
                              // });
                              location = "Null";
                              locationProcesss(location);
                            }
                          },
                          child: const Text(
                            "Get Location",
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
}
