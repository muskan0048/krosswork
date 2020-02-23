import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:splash/res/AppColors.dart';

class UpdateAppActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateAppState();
  }
}

class UpdateAppState extends State<UpdateAppActivity> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          // Add box decoration
          color: Colors.white,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Image.asset(
                          'update.png',
                          width: MediaQuery.of(context).size.width,
                          height: 200.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 15.0, right: 15.0),
                          child: Text(
                            "Update for a faster, better Krosswork",
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: "GoogleSansRegular",
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 15.0, right: 15.0),
                          child: Text(
                            "An Update is available with new features, a faster experience,fixes and more. It typically takes less than 1 minute.",
                            style: new TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 16.0,
                                fontFamily: "GoogleSansRegular",
                                wordSpacing: 1.3),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ],
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MaterialButton(
                              color: colorPrimary,
                              onPressed: () {
                                LaunchReview.launch();
                              },
                              child: Text(
                                "Update",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontFamily: "GoogleSansRegular",
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                            ),
                            GestureDetector(
                              onTap: () {
                                exit(0);
                              },
                              child: Text(
                                "NOT NOW",
//                              "Auribises Technologies",

                                textAlign: TextAlign.center,

                                style: new TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 16.0,
                                  fontFamily: "GoogleSansRegular",
                                ),
                              ),
                            ),
                          ],
                        )))
              ],
            ),
          )),
    );
  }
}
