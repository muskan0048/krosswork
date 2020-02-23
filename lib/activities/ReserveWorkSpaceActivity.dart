import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splash/activities/ConfirmReservation.dart';
import 'package:splash/beans/Reservation.dart';
import 'package:splash/beans/WorkSpace.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

var selectedTime = null;

class ReserveWorkSpaceActivity extends StatefulWidget {
  WorkSpace workSpace;

  ReserveWorkSpaceActivity(this.workSpace);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Reserve(workSpace);
  }
}

class Reserve extends State<ReserveWorkSpaceActivity> {
  static const platform = const MethodChannel('flutter.appyflow.in.channel');

  WorkSpace workSpace;

  DateTime selectedDate;

  var formatter = new DateFormat('dd MMMM yyyy');
  DateTime date = new DateTime.now();
  DateTime lastDate, initialDate;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Reserve(this.workSpace);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialDate = date;
    selectedDate = date.add(new Duration(days: 1));
    lastDate = date.add(new Duration(days: 90));

    print("I am called dates" + initialDate.toString());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: Brightness.light,
          title: Text(
            "Subscribe to Mentor",
            style:
                TextStyle(color: colorPrimary, fontFamily: "GoogleSansRegular"),
          ),
          centerTitle: true,
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
          backgroundColor: Colors.white,
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Hero(
                          tag: workSpace.name,
                          child: WorkSpaceD(workSpace),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        Card(
                          child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Select Date ",
                                    style: TextStyle(
                                        fontFamily: "GoogleSansRegular",
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(1.0),
                                  ),
                                  HorizontalDivider(colorPrimary, 2.0, 50.0),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          firstDate: initialDate,
                                          lastDate: lastDate);

                                      if (selectedDate == null) {
                                        selectedDate =
                                            date.add(new Duration(days: 1));
                                      }
                                      print("Selected Date is " +
                                          selectedDate.toString());
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(12.0),
                                      decoration: new BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          color: Colors.white,
                                          border: new Border.all(
                                              color: colorPrimary)),
                                      child: Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          formatter.format(selectedDate),
                                          style: TextStyle(
                                              fontFamily: "GoogleSansRegular",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: colorPrimary),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                    ),
                                  )
                                ],
                              )),
                        ),
                        Card(
                          child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Select Time ",
                                    style: TextStyle(
                                        fontFamily: "GoogleSansRegular",
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(1.0),
                                  ),
                                  HorizontalDivider(colorPrimary, 2.0, 50.0),
                                  Container(
                                      height: 70.0, child: ATimes(workSpace)),
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: colorPrimary,
                  minWidth: MediaQuery.of(context).size.width,
                  textColor: Colors.white,
                  onPressed: () {
//                    addTxnToFirestore();

                    DateTime currentTime = new DateTime.now();
                    String txnId =
                        currentTime.millisecondsSinceEpoch.toString();
                    Reservation reservation = new Reservation();
                    reservation.txnId = txnId;
                    reservation.currentDate = currentTime;
                    reservation.workSpace = workSpace;

                    print(int.tryParse(selectedTime
                                .substring(selectedTime.indexOf(":") + 1))
                            .toString() +
                        "");

                    print(int.tryParse(
                        selectedTime.substring(0, selectedTime.indexOf(":"))));

                    reservation.bookingDate = new DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        int.tryParse(selectedTime.substring(
                            0, selectedTime.indexOf(":"))),
                        int.tryParse(selectedTime
                            .substring(selectedTime.indexOf(":") + 1)));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ConfirmReservation(reservation)));
                  },
                  child: Text(
                    "Schedule a Session",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "GoogleSansRegular",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )),
          ],
        ));
  }

  void addTxnToFirestore() async {
    print(new DateTime.now().millisecondsSinceEpoch);

    DateTime currentTime = new DateTime.now();
//    String txnId = currentTime.year.toString() +
//        "" +
//        currentTime.month.toString() +
//        "" +
//        currentTime.day.toString() +
//        "" +
//        currentTime.hour.toString() +
//        "" +
//        currentTime.month.toString() +
//        "" +
//        currentTime.second.toString() +
//        "";

    String txnId = new DateTime.now().millisecondsSinceEpoch.toString();
    Reservation reservation = new Reservation();
    reservation.txnId = txnId;
    reservation.currentDate = currentTime;
//    reservation.amount = "10.0";
    reservation.workSpace = workSpace;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    reservation.userEmail = user.email;
    reservation.userId = user.uid;
    reservation.userName = "Dishant";

    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text("  Processing Please Wait...")
        ],
      ),
    ));

    Firestore.instance
        .collection("Reservations")
        .document(txnId)
        .setData(reservation.getMap())
        .then((result) {
      Firestore.instance
          .collection("Reservations")
          .document(txnId)
          .snapshots()
          .listen((change) {
        print("Values are " + change.data.toString());
        print("Hash is " + change.data['hash'].toString());

        if (change.data['hash'] != null) {
//          reservation.hash = change.data['hash'].toString();
          reservation.userPhone = "9023074222";
          showPaymentUi(reservation);
        }
      });
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }

  void showPaymentUi(Reservation reservation) async {
    String result =
        await platform.invokeMethod('showPaymentView', <String, dynamic>{
      // data to be passed to the function
      'option': 3,
      'txnId': reservation.txnId,
//      'hash': reservation.hash,
      'userPhone': reservation.userPhone,
      'userEmail': reservation.userEmail,
      'userName': reservation.userName,
      'pInfo': reservation.workSpace.name,
    });

    if (result == "success") print("Hello success flutter" + result);
  }
}

class WorkSpaceD extends StatelessWidget {
  WorkSpace workSpace;

  WorkSpaceD(this.workSpace);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: new BorderRadius.circular(4.0),
                      child: Image.network(
                        workSpace.picUrls.length > 0
                            ? workSpace.picUrls.elementAt(0)
                            : "https://res.cloudinary.com/myhq/image/upload/fl_lossy,f_auto,q_auto/space-images/58334a65e55b93643163ee1b/58334a65e55b93643163ee1b-5.jpg",
                        height: 100.0,
                        width: 130.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  workSpace.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "GoogleSansBold",
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 12.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3.0),
                                ),
                                Expanded(
                                  child: Text(
                                    workSpace.address.locality +
                                        " , " +
                                        workSpace.address.city,
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "GoogleSansRegular",
                                        fontSize: 14.0),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            Divider(
                              height: 1.0,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                "Availability: "+(workSpace.closing).toString()+" Students",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "GoogleSansRegular",
                                    fontSize: 14.0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                workSpace.getOpenStatus(),
                                style: TextStyle(
                                    color:
                                        workSpace.getOpenStatus() == "Open Now"
                                            ? Colors.green
                                            : Colors.red,
                                    fontFamily: "GoogleSansRegular",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
              ],
            )));
  }
}

class ATimes extends StatefulWidget {
  WorkSpace workSpace;

  ATimes(this.workSpace);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AvailableTimes(workSpace);
  }
}

class AvailableTimes extends State<ATimes> {
  AvailableTimes(this.workSpace);

  WorkSpace workSpace;

  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new FutureBuilder(
      future: getAvailabletimes(),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return new ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  Color color = Colors.white, textColor = colorPrimary;

                  selectedIndex == Index ? color = colorPrimary : Colors.white;

                  selectedIndex == Index
                      ? textColor = Colors.white
                      : colorPrimary;

                  return GestureDetector(
                    onTap: () {
                      selectedIndex = Index;
                      selectedTime = snapshot.data.elementAt(Index);
                      print("Selected Time is" + selectedTime);
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.all(12.0),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: color,
                          border: new Border.all(color: colorPrimary)),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Text(
                          snapshot.data[Index],
                          style: TextStyle(
                              fontFamily: "GoogleSansRegular",
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ),
                  );
                });
          } else {
            return Center(child: new CircularProgressIndicator());
          }
        } else {
          return Center(child: new CircularProgressIndicator());
        }
      },
    );

//    new ListView.builder(
//        scrollDirection: Axis.horizontal,
//        itemCount: times.toList().length,
//        itemBuilder: (BuildContext ctxt, int Index) {
//          return Padding(
//            padding: EdgeInsets.all(12.0),
//            child: Container(
//              margin: const EdgeInsets.all(15.0),
//              padding: const EdgeInsets.all(3.0),
//              decoration: new BoxDecoration(
//                  border: new Border.all(color: colorPrimary)),
//              child: Text(
//                times[Index],
//                style: TextStyle(
//                    fontFamily: "GoogleSansRegular",
//                    fontSize: 12.0,
//                    color: Colors.black),
//                softWrap: true,
//                textAlign: TextAlign.center,
//              ),
//            ),
//          );
//        });
  }

  Future<List<String>> getAvailabletimes() async {
    List<String> times = [];

    double start = 9.25;

    while (start < 19.50 - 1) {
      double open = start - start.floor();

      int oMins = (open * 60).floor();

      if (oMins == 0) {
        times.add(start.floor().toString() + ":00");
      } else {
        times.add(start.floor().toString() + ":" + oMins.toString());
      }

      start = start + 1.0;
    }

    print(times);

    if (selectedTime == null) {
      selectedTime = times.first;
    }

    return times;
  }
}
