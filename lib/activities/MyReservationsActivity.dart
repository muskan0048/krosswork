import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splash/beans/Reservation.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

var formatter = new DateFormat('MMMM dd , yyyy   hh:mm a');

class MyReservationsActivity extends StatefulWidget {
  String uid;

  MyReservationsActivity(this.uid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyReservationsState(uid);
  }
}

class MyReservationsState extends State<MyReservationsActivity> {
  String uid;

  MyReservationsState(this.uid);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
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
        title: Text(
          "Your Sessions",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: "GoogleSansBold"),
          softWrap: true,
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("Reservations")
                  .where("userId", isEqualTo: uid)
                  .orderBy("txnId", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      backgroundColor: Colors.black,
                    ));
                  default:
//            mainCallBack();
                    return new ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          return GestureDetector(
                              onTap: () {},
                              child: Hero(
                                  tag: snapshot
                                      .data.documents[Index].data['txnId'],
                                  child: SingleReservation(Reservation.toObject(
                                    snapshot.data.documents[Index].data,
                                  ))));
                        });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class SingleReservation extends StatelessWidget {
  Reservation reservation;

  SingleReservation(this.reservation);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new ClipRRect(
                  borderRadius: new BorderRadius.circular(4.0),
                  child: Image.network(
                    reservation.workSpace.picUrls.length > 0
                        ? reservation.workSpace.picUrls.elementAt(0)
                        : "https://res.cloudinary.com/myhq/image/upload/fl_lossy,f_auto,q_auto/space-images/58334a65e55b93643163ee1b/58334a65e55b93643163ee1b-5.jpg",
                    height: 40.0,
                    width: 40.0,
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
                              reservation.workSpace.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "GoogleSansBold",
                                  fontSize: 18.0),
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
                                reservation.workSpace.address.locality +
                                    " , " +
                                    reservation.workSpace.address.city,
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
                      ],
                    ),
                  ),
                )
              ],
            ),
            HorizontalDivider(
                lightGrey, 1.0, MediaQuery.of(context).size.width),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(
              "RESERVATION FOR",
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "GoogleSansBold",
                  fontSize: 12.0),
            ),
            Text(
              formatter.format(reservation.bookingDate),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "GoogleSansRegular",
                  fontSize: 14.0),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            Text(
              "ORDERED ON",
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: "GoogleSansBold",
                  fontSize: 12.0),
            ),
            Text(
              formatter.format(reservation.currentDate),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "GoogleSansRegular",
                  fontSize: 14.0),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            HorizontalDivider(
                lightGrey, 1.0, MediaQuery.of(context).size.width),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                reservation.bookingDate.isAfter(new DateTime.now())
                    ? "Reserved"
                    : "Expired",
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: reservation.bookingDate.isAfter(new DateTime.now())
                        ? Colors.green
                        : Colors.red,
                    fontFamily: "GoogleSansBold",
                    fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
