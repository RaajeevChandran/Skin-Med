import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_place/google_place.dart';
import 'package:lottie/lottie.dart';
import 'package:skinmed/chatScreen.dart';

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
        backgroundColor: Color(0xFFFf2f6fe),
        body: SafeArea(
          child: Column(
            children: [
              buildAppBar(context),
              Expanded(
                child: Container(
                  child: FutureBuilder(
                      future: determinePosition(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(
                                child: Lottie.asset("assets/loading.json"));
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
                                          child: Lottie.asset(
                                              "assets/loading.json"));
                                    case ConnectionState.done:
                                      return ListView.builder(
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            // getUint8List(snap.data.results[0]
                                            //     .photos[0].photoReference);

                                            return Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Material(
                                                elevation: 3,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  height: 350,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    // color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    //
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 220,
                                                        width: double.infinity,
                                                        color: Colors.blue,
                                                        child: Image.asset(
                                                            "assets/profile.png"),
                                                      ),
                                                      Expanded(
                                                          child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        // color: Color(0xFFF5347e9),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                snap
                                                                    .data
                                                                    .results[
                                                                        index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17)),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                    snap
                                                                        .data
                                                                        .results[
                                                                            index]
                                                                        .vicinity,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w300)),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Material(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    clipBehavior:
                                                                        Clip.hardEdge,
                                                                    child: Ink(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .blue
                                                                            .shade300,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                      width:
                                                                          150,
                                                                      height:
                                                                          44,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {},
                                                                        child: Center(
                                                                            child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.phone,color: Colors.white,),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                "Call",
                                                                                style: TextStyle(fontSize: 19,color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                      ),
                                                                    )),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Material(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      clipBehavior: Clip.hardEdge,
                                                                      child: Ink(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .amber
                                                                              .shade100,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        width:
                                                                            150,
                                                                        height:
                                                                            44,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(context,
                                                                                MaterialPageRoute(builder: (context) => ChatPage(hospitalName:snap.data.results[index].name)));
                                                                          },
                                                                          child: Center(
                                                                              child: Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(Icons.message),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  "Chat",
                                                                                  style: TextStyle(fontSize: 19),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                        ),
                                                                      )),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    default:
                                      return Center(
                                          child: Lottie.asset(
                                              "assets/loading.json"));
                                  }
                                });
                          default:
                            return Center(
                                child: Lottie.asset("assets/loading.json"));
                        }
                      }),
                ),
              ),
            ],
          ),
        ));
    // body: SingleChildScrollView(
    //   child: Column(
    //       children: List.generate(3, (int index) {
    //     return Padding(
    //       padding: EdgeInsets.all(8.0),
    //       child: Container(
    //         height: 320,
    //         width: double.infinity,
    //         decoration: BoxDecoration(
    //           color: Colors.red,
    //         ),
    //         child: Column(
    //           children: [
    //             Container(
    //               height: 220,
    //               width: double.infinity,
    //               color: Colors.blue,
    //               child: Image.asset("assets/profile.png"),
    //             ),
    //             Expanded(
    //                 child: Container(
    //               width: double.infinity,
    //               height: double.infinity,
    //               color: Colors.amber,
    //               child: Column(
    //                 children: [
    //                   Text("HOSPITAL NAME "),
    //                   Text("Address"),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Material(
    //                           borderRadius: BorderRadius.circular(20),
    //                           clipBehavior: Clip.hardEdge,
    //                           child: Ink(
    //                             decoration: BoxDecoration(
    //                               color: Colors.greenAccent,
    //                               borderRadius: BorderRadius.circular(20),
    //                             ),
    //                             width: 150,
    //                             height: 44,
    //                             child: InkWell(
    //                               onTap: () {},
    //                               child: Center(
    //                                   child: Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.center,
    //                                 children: [
    //                                   Icon(Icons.phone),
    //                                   Padding(
    //                                     padding: const EdgeInsets.all(8.0),
    //                                     child: Text(
    //                                       "Call",
    //                                       style: TextStyle(fontSize: 19),
    //                                     ),
    //                                   ),
    //                                 ],
    //                               )),
    //                             ),
    //                           )),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Material(
    //                             borderRadius: BorderRadius.circular(20),
    //                             clipBehavior: Clip.hardEdge,
    //                             child: Ink(
    //                               decoration: BoxDecoration(
    //                                 color: Colors.greenAccent,
    //                                 borderRadius: BorderRadius.circular(20),
    //                               ),
    //                               width: 150,
    //                               height: 44,
    //                               child: InkWell(
    //                                 onTap: () {},
    //                                 child: Center(
    //                                     child: Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.center,
    //                                   children: [
    //                                     Icon(Icons.message),
    //                                     Padding(
    //                                       padding:
    //                                           const EdgeInsets.all(8.0),
    //                                       child: Text(
    //                                         "Chat",
    //                                         style: TextStyle(fontSize: 19),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 )),
    //                               ),
    //                             )),
    //                       )
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ))
    //           ],
    //         ),
    //       ),
    //     );
    //   })),
    // ));
  }

  Container buildAppBar(BuildContext context) {
    return Container(
      height: 60,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Text("Your Location's Nearby Dermatologists",
                  style: TextStyle(fontSize: 15)))
        ],
      ),
    );
  }

  Future<void> getUint8List(String photoReference) async {
    var result = await this.googlePlace.photos.get(photoReference, null, 400);
    print(result);
    if (result != null && mounted) {
      setState(() {
        images.add(result);
      });
    }
  }
}
