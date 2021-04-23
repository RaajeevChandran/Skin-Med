import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFFf2f6fe),
          body: Column(
            children: [
              Container(
                height: 50,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Color(0xFFFe9eaff),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.menu, color: Color(0xFFF9fa2fc)),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset("assets/icon.png")),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          foregroundImage: AssetImage("assets/profile.png"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFFF585ce5),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Welcome to SkinMed!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 29,
                              fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Text(
                            "Let's check your skin health with us.Care with your health from now on to get better!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w300)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .7,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF54c1fb),
                          ),
                          child: Center(
                            child: Text("Know your skin disease",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
