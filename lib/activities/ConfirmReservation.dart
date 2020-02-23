import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:splash/activities/MyReservationsActivity.dart';
import 'package:splash/activities/SubscribePlan.dart';
import 'package:splash/beans/Reservation.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/helpers/LoadingDialog.dart';
import 'package:splash/res/AppColors.dart';

class ConfirmReservation extends StatefulWidget {
  Reservation reservation;

  ConfirmReservation(this.reservation);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ConfirmReservationState(reservation);
  }
}

class ConfirmReservationState extends State<ConfirmReservation> {
  Reservation reservation;

  User user;

  ConfirmReservationState(this.reservation);
  var userListener;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userListener?.cancel();
  }

  void getUser() async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    userListener = Firestore.instance
        .collection("Users")
        .document(firebaseUser.uid)
        .snapshots()
        .listen((data) {
      user = User.mapToUser(data.data);

      reservation.userPhone = user.phoneNo;
      reservation.userId = user.uid;
      reservation.userName = user.name;
      reservation.userEmail = user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1.0,
          title: new Text(
            "Confirm Session",
            style: TextStyle(color: colorPrimary, fontFamily: "GoogleSansBold"),
          ),
          leading: MaterialButton(
            elevation: 0.0,
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
            child: Icon(
              Icons.arrow_back_ios,
              color: colorPrimary,
            ),
          ),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Text(
                  "Your Session ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "GoogleSansBold"),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  "on " +
                      new DateFormat('dd MMMM yyyy , hh:mm a')
                          .format(reservation.bookingDate),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: "GoogleSansRegular"),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                HorizontalDivider(Colors.grey, 2.0, 70.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              reservation.workSpace.picUrls.length > 0
                                  ? reservation.workSpace.picUrls.elementAt(0)
                                  : "https://res.cloudinary.com/myhq/image/upload/fl_lossy,f_auto,q_auto/space-images/58334a65e55b93643163ee1b/58334a65e55b93643163ee1b-5.jpg",
                            )))),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  reservation.workSpace.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontFamily: "GoogleSansRegular"),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text(
                  reservation.workSpace.address.locality +
                      " , " +
                      reservation.workSpace.address.city,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: "GoogleSansRegular"),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                ),
                RaisedButton(
                  onPressed: () {
                    showConfirmationDialog();
                  },
                  color: colorPrimary,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      "Confirm",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontFamily: "GoogleSansRegular"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void addTxnToFirestore() async {
//    _scaffoldKey.currentState.showSnackBar(new SnackBar(
//      duration: new Duration(seconds: 4),
//      content: new Row(
//        children: <Widget>[
//          new CircularProgressIndicator(),
//          new Text("  Processing Please Wait...")
//        ],
//      ),
//    ));
  }

  void addReservationToFirestore() {
    LoadingDialog.showLoadingDialog(context);

    Firestore.instance
        .collection("Reservations")
        .document(reservation.txnId)
        .setData(reservation.getMap())
        .then((result) {
      print("Session Confirmed");

      sendSMS();

      Firestore.instance
          .collection("Users")
          .document(user.uid)
          .updateData({"paidVisits": user.paidVisits - 1}).then((result) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
                builder: (context) => MyReservationsActivity(user.uid)));
      });
    }).catchError((error) {
      showError(error.toString(), context);
    });
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );
  }

  void showConfirmationDialog() {
    showDemoDialog<String>(
      context: context,
      child: CupertinoAlertDialog(
        title: const Text('Confirm Appointment?'),
        content: const Text('Are you Sure to Confirm?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context, 'Yes');

              if (user != null && user.paidVisits > 0) {
                addReservationToFirestore();
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubscribePlanActivity(user)));
              }
            },
          ),
        ],
      ),
    );
  }

  void showError(String error, BuildContext context) {
    showDemoDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text("Error",
              softWrap: true,
              style: TextStyle(fontSize: 14.0, fontFamily: "GoogleSansBold")),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Okay'),
            )
          ],
          content: Text(error.toString(),
              softWrap: true,
              style:
                  TextStyle(fontSize: 14.0, fontFamily: "GoogleSansRegular")),
        ));
  }

  void sendSMS() async {
    var msg = "Dear " +
        user.name +
        ". Your Appointment with " +
        reservation.workSpace.name +
        " on " +
        new DateFormat('dd MMMM yyyy , hh:mm a')
            .format(reservation.bookingDate) +
        ' is Confirmed. Have a Wonderfull experience Thank you, StudyBuddy.';

    msg = msg.replaceAll(" ", "%20");

    print(
        'http://api.msg91.com/api/sendhttp.php?sender=SPLASH&route=4&mobiles=' +
            user.phoneNo +
            '&authkey=201565A9xoadCI5aa0dd7c&country=91&message=' +
            msg);

    final response = await http.get(
        'http://api.msg91.com/api/sendhttp.php?sender=SPLASH&route=4&mobiles=' +
            user.phoneNo +
            '&authkey=201565A9xoadCI5aa0dd7c&country=91&message=' +
            msg);
    print("Response :" + response.body);
  }
}
