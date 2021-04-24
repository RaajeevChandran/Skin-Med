import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:lottie/lottie.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  Position initPos;
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition().then((value) => {print(value)});
    super.initState();
  }

  var googlePlace = GooglePlace('AIzaSyBXvdv5ERqDG3Me5XkKsEldWfPP3prOvsE');
  List<Uint8List> images = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Image.asset("assets/icon.png", fit: BoxFit.fitHeight),
        //   centerTitle: true,
        //   backgroundColor: Color(0xFFEFF0F4),
        // ),
        backgroundColor: Color(0xFFFf2f6fe),
        body: Container(
          child: FutureBuilder(
              future: determinePosition(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: Lottie.asset("assets/loading.json"));
                  case ConnectionState.done:
                    return FutureBuilder(
                        future: googlePlace.search.getNearBySearch(
                            Location(
                                lat: snapshot.data.latitude,
                                lng: snapshot.data.longitude),
                            20000,
                            type: "hospital",
                            keyword: "skin"),
                        builder: (context, snap) {
                          switch (snap.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                  child: Lottie.asset("assets/loading.json"));
                            case ConnectionState.done:
                              return ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    //getUint8List(snapshot.data.results[index].photos[index].photoReference);
                                    if (index < 3) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Color(0xFFfdba9d)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Image.network(
                                                    'https://image.shutterstock.com/image-vector/no-image-available-sign-absence-260nw-373244122.jpg',
                                                    scale: 4),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        snap.data.results[index]
                                                            .name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(snap
                                                          .data
                                                          .results[index]
                                                          .vicinity)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Icon(Icons.phone)
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Image.network(
                                                    'https://image.shutterstock.com/image-vector/no-image-available-sign-absence-260nw-373244122.jpg',
                                                    scale: 4),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        snap.data.results[index]
                                                            .name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(snap
                                                          .data
                                                          .results[index]
                                                          .vicinity)
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Icon(Icons.phone)
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  });
                            default:
                              return Center(
                                  child: Lottie.asset("assets/loading.json"));
                          }
                        });
                  default:
                    return Center(child: Lottie.asset("assets/loading.json"));
                }
              }),
        ));
  }

  Future<void> getUint8List(String photoReference) async {
    var result = await this.googlePlace.photos.get(photoReference, null, 400);
    // print(result);
    if (result != null && mounted) {
      setState(() {
        images.add(result);
      });
    }
  }
}
