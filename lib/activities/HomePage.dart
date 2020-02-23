import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:splash/activities/LoginActivity.dart';
import 'package:splash/activities/Offers.dart';
import 'package:splash/activities/WorkSpaces.dart';
import 'package:splash/helpers/MyAlertDialog.dart';
import 'package:splash/res/AppColors.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() {
    return HomePageState();
  }

  HomePage({Key key}) : super(key: key);
}

class HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String name = "", addressLine = "", addressTitle = "";

  //Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
  String error;

  static double heightList = 100.0;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        try {
          getAddress(result['latitude'], result['longitude']);
        } catch (error) {
          print("Error is " + error.toString());
        }

        _currentLocation = result;

        if (_currentLocation != null) {
          print("Current Location is " + _currentLocation.toString());
          _locationSubscription.cancel();
        }
      });
    });
  }

  initPlatformState() async {
    Map<String, double> location;

    try {
      _permission = await _location.hasPermission();

      location = await _location.getLocation();

//      _startLocation = location;

      getAddress(location['latitude'], location['longitude']);

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      } else {
        error = e.toString();
      }

      location = null;

      print(error);

//      initPlatformState();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;
  }

  void callback() {
    print(heightList);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Icon(
                    Icons.location_on,
                    size: 12.0,
                    color: Colors.grey,
                  ),
                  Text(
                    "Your Location",
                    style: TextStyle(
                        fontFamily: "GoogleSansRegular",
                        color: Colors.grey,
                        fontSize: 12.0),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          addressTitle.length < 0
                              ? "Location Not Available"
                              : addressTitle,
                          style: TextStyle(
                              fontFamily: "GoogleSansRegular",
                              color: Colors.black,
                              fontSize: 14.0),
                          softWrap: true,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          addressLine.length < 0
                              ? "Please check your gps connection and try again"
                              : addressLine,
                          style: TextStyle(
                              fontFamily: "GoogleSansRegular",
                              color: Colors.grey,
                              fontSize: 12.0),
                          softWrap: true,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      MyAlertDialog.showError("Coming Soon", context,
                          title: "Oops...");
                    },
                    child: new Icon(
                      Icons.filter_list,
                      color: Colors.black,
                      size: 20.0,
                    ),
                  )
                ],
              ),
            ],
          )),
      body: Container(
        decoration: new BoxDecoration(color: lightGrey),
        child: SingleChildScrollView(
            child: Row(
          children: <Widget>[
            Expanded(
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    height: height * 0.28,
                    child: OffersActivity("Offers", "offers", height, width),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        MyAlertDialog.showError("Coming Soon", context,
                            title: "Oops...");
                      },
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: Card(
                                        color: lightGrey,
                                        margin: EdgeInsets.all(10.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0)),
                                        child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                  size: 20.0,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.0),
                                                ),
                                                Text(
                                                  "Search for mentors here...",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            )))),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: _currentLocation != null
                                      ? WorkSpaces("WorkSpaces",
                                          _currentLocation, this.callback)
                                      : Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Text(
                                                "Location Error",
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: colorPrimary,
                                                    fontFamily:
                                                        "GoogleSansBold"),
                                              ),
                                              Text(
                                                "Please Check GPS Connection",
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontFamily:
                                                        "GoogleSansRegular"),
                                              )
                                            ],
                                          )),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              ]),
            )
          ],
        )),
      ),

//      Container(
//          decoration: new BoxDecoration(color: lightGrey),
//          child: SingleChildScrollView(
//              child: Column(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.all(5.0),
//                child: Container(
//                  height: height * 0.28,
//                  child: OffersActivity("Offers", "offers", height, width),
//                ),
//              ),
//              Padding(
//                padding: EdgeInsets.only(top: 10.0),
//                child: Container(
//                  decoration: new BoxDecoration(color: Colors.white),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    mainAxisSize: MainAxisSize.max,
//                    children: <Widget>[
//                      Row(
//                        mainAxisSize: MainAxisSize.max,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Expanded(
//                              child: Card(
//                                  color: lightGrey,
//                                  margin: EdgeInsets.all(10.0),
//                                  shape: RoundedRectangleBorder(
//                                      borderRadius:
//                                          BorderRadius.circular(12.0)),
//                                  child: Padding(
//                                      padding: EdgeInsets.all(10.0),
//                                      child: Row(
//                                        mainAxisSize: MainAxisSize.max,
//                                        children: <Widget>[
//                                          Icon(
//                                            Icons.search,
//                                            color: Colors.grey,
//                                            size: 20.0,
//                                          ),
//                                          Padding(
//                                            padding:
//                                                EdgeInsets.only(left: 20.0),
//                                          ),
//                                          Text(
//                                            "Search for workspaces here...",
//                                            style: TextStyle(
//                                                fontSize: 16.0,
//                                                color: Colors.grey),
//                                          ),
//                                        ],
//                                      )))),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Flexible(
//                fit: FlexFit.loose,
//                child: WorkSpaces("WorkSpaces"),
//              )
//            ],
//          ))),
    );
  }

  void getUserDetails() {
    FirebaseAuth.instance.currentUser().then((v) {
      if (v != null) {
        name = v.email;
      } else {
        name = "";
      }

      setState(() {});
    });
  }

  void logout() {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text("  Loging-Out...")
        ],
      ),
    ));

    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }).catchError((e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 20.0),
            child: Text("Error Occured " + e.toString(),
                style: TextStyle(fontStyle: FontStyle.italic)))
      ])));
    });
  }

  void getAddress(double lat, double lng) async {
    print("I am called");
    final coordinates = new Coordinates(lat, lng);
    List<Address> addresses =
        await Geocoder.google("AIzaSyAlVrEyOOalLJDd11N95KkvTxxRmpO6p0w").findAddressesFromCoordinates(coordinates);
    if (addresses.length > 0) {
      Address first = addresses.first;

      if (first.subLocality != null) {
        addressTitle = first.subLocality + ",";
      } else if (first.locality != null) {
        addressTitle = first.locality + ",";
      }

      if (first.subAdminArea != null) {
        addressTitle += first.subAdminArea + ",";
      }

      if (first.adminArea != null) {
        addressTitle += first.adminArea;
      }

      addressLine = first.addressLine;

      print("${first.featureName} : ${first.addressLine} " +
          first.toMap().toString());
    }

    updateLocation(lat, lng);

    setState(() {});
  }

  void updateLocation(double lat, double lng) async {
    FirebaseAuth.instance.currentUser().then((v) {
      Firestore.instance
          .collection("Users")
          .document(v.uid)
          .updateData({"lat": lat, "lng": lng, "lastSeen": DateTime.now()});
    });
  }
}
