import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:moroccan_explorer/model/db_connect.dart';
import 'package:moroccan_explorer/ui/pages/map.page.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin, pow, sin, pi;

// ignore: must_be_immutable
class BestPage extends StatefulWidget {
  final Place bestPlace;
  double? distanceKm = 0.0;

  BestPage({Key? key, required this.bestPlace, this.distanceKm})
      : super(key: key);

  @override
  State<BestPage> createState() => _BestPageState();
}

class _BestPageState extends State<BestPage> {
  @override
  initState() {
    // ignore: avoid_print
    _distance = 0.0;
    print("initState Called");
  }

  double _distance = 0.0;
  var lat, lat1, lon, lon1, _position, _placePosition;
  double calculatDistance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6372.8; // Earth radius in kilometers

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final lat1Radians = _toRadians(lat1);
    final lat2Radians = _toRadians(lat2);
    setState(() {
      _position = LatLng(lat1, lon1);
      _placePosition = LatLng(lat2, lon2);
    });

    final a =
        _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
    final c = 2 * asin(sqrt(a));
    setState(() {
      _distance = r * c;
    });
    return r * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  double _haversin(double radians) => pow(sin(radians / 2), 2) as double;

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  void getCurrentPosition(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _position = position;
    setState(() async {
      lat = position.latitude;
      lon = position.longitude;
    });
  }

  void getpd(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var c = _handleLocationPermission(context).then((value) async => {
          await Geocoder.local
              .findAddressesFromQuery(widget.bestPlace.nom)
              .then((value) => setState(() => _distance = calculatDistance(
                  position.latitude,
                  position.longitude,
                  value.first.coordinates.latitude!,
                  value.first.coordinates.longitude!)))
        });
  }

  @override
  void dispose() {
    _distance = 0.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getpd(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Morocco",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: AssetImage('images/m.jpg'),
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height,
              width: double.infinity,
              child: FittedBox(
                child: Image.asset("images/${widget.bestPlace.url}"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * .6,
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.topCenter,
                      stops: const [0, 1],
                      colors: [Colors.white, Colors.white.withOpacity(.03)])),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            width: size.width * .8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.bestPlace.nom!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'images/pin.png',
                            width: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'm, ',
                                style: TextStyle(
                                  color: Colors.black87.withOpacity(.5),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' (' +
                                        _distance.toStringAsFixed(2) +
                                        '0' +
                                        'km)',
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.bestPlace.description!,
                    style: const TextStyle(
                      color: Color(0xff686771),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              LatLng myCoords = _position;
                              LatLng placeCoords = _placePosition;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapPage(
                                    myCoords: myCoords,
                                    placeCoords: placeCoords,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff8f294f),
                              padding: EdgeInsets.all(9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Voir Le Trajet',
                              style: TextStyle(
                                color: Color(0xff090808),
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}