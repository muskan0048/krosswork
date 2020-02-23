import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:package_info/package_info.dart';
import 'package:splash/activities/MainActivity.dart';
import 'package:splash/activities/UpdateAppActivity.dart';
import 'package:splash/res/AppColors.dart';
import 'package:splash/util/Constants.dart';

import 'activities/LoginActivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studdy Buuddy',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        backgroundColor: colorPrimary,
        body: new SplashActivity(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashActivity extends StatelessWidget {
  String error;

  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  bool _permission = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Location _location = new Location();

  void firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() async {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    //getAddress(context);

    getState(context);

    firebaseCloudMessaging_Listeners();

    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.black,
//        elevation: 0.0,
//        brightness: Brightness.dark,
//        title: LinearProgressIndicator(
//          backgroundColor: Colors.black,
//          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//        ),
//      ),
      body: Container(
          // Add box decoration
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: AssetImage("splash1.jpg"),
//            NetworkImage(
//                    "https://sweetcsdesigns.com/wp-content/uploads/2018/09/the-best-chinese-chicken-salad-recipe.jpg"),
//                "https://healthyfitnessmeals.com/wp-content/uploads/2018/01/asian-chopped-chicken-salad-4-683x1024.jpg"),
//                    "https://poshjournal.com/wp-content/uploads/2017/05/asian-chopped-salad-sesame-ginger-dressing-recipe-lunch-ideas-02b.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "Studdy",
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 40.0,
                                fontFamily: "GoogleSansRegular",
                              ),
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Study with ur Buddy",
//                              "Auribises Technologies",

                              textAlign: TextAlign.center,

                              style: new TextStyle(
                                color: colorPrimary,
                                fontSize: 20.0,
                                fontFamily: "GoogleSansRegular",
                              ),
                            ),
                          ],
                        )))
              ],
            ),
          )),
    );
  }

  getState(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print("App deatils " +
        appName +
        " " +
        packageName +
        " " +
        version +
        " " +
        buildNumber);

    Firestore.instance
        .collection(appData)
        .document(appData)
        .get()
        .then((value) {
      if (!value.exists) {
        return;
      }

      String versionConst = "";
      if (Platform.isAndroid) {
        versionConst = 'androidVersion';
      } else if (Platform.isIOS) {
        versionConst = 'iosVersion';
      }

      print(
          "App Latest Version ${double.tryParse(value.data[versionConst].toString())}");

      if (double.tryParse(value.data[versionConst].toString()) >
          double.tryParse(buildNumber)) {
        Navigator.pushReplacement(context,
            new CupertinoPageRoute(builder: (context) => UpdateAppActivity()));
      } else {
        getUser(context);
      }
    }).catchError((error) {
      print("error " + error.toString());
    });
  }

  void getUser(context) async {
    FirebaseAuth.instance.currentUser().then((onValue) {
      debugPrint("hello" + onValue.toString());

      if (onValue != null && onValue.uid != null) {
        Navigator.pushReplacement(context,
            new MaterialPageRoute(builder: (context) => MainActivity()));
      } else {
        Navigator.pushReplacement(
            context, new MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  void getAddress(context) async {
    print("i am called");
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();

      location = await _location.getLocation();

      _startLocation = location;

      print("Location Detected " + location.toString());

//      getAddress(location['latitude'], location['longitude']);

      error = null;
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';

        location = await _location.getLocation();
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      } else {
        error = e.toString();
      }

      print(error);

      getState(context);

      location = null;
    }
  }
}
