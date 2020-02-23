import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splash/beans/SplashTransaction.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

var dateFormat = new DateFormat('dd MMM yyyy hh:mm a');

class TransactionHistoryActivity extends StatefulWidget {
  User user;

  TransactionHistoryActivity(this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TransactionHistory(user);
  }
}

class TransactionHistory extends State<TransactionHistoryActivity> {
  User user;

  TransactionHistory(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        elevation: 1.0,
        title: new Text(
          "My Transactions",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Transactions')
            .where("userId", isEqualTo: user.uid)
            .orderBy('transactionTime', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          else if (snapshot.hasData) {
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  return GestureDetector(
                      onTap: () {},
                      child: Hero(
                          tag: snapshot.data.documents[Index].data['txnId'],
                          child: SingleTransaction(
                            SplashTransaction.mapToTransaction(
                              snapshot.data.documents[Index].data,
                            ),
                          )));
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
//        switch (snapshot.connectionState) {
//          case ConnectionState.waiting:
////            return Center(child: CircularProgressIndicator());
//            return Center(child: Text(""));
//          default:
////            mainCallBack();
//
//        }
        },
      ),
    );
  }
}

class SingleTransaction extends StatelessWidget {
  SplashTransaction splashTransaction;

  SingleTransaction(this.splashTransaction);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Order No. " + splashTransaction.txnId,
                      style: TextStyle(
                          color: Colors.black, fontFamily: "GoogleSansRegular"),
                    ),
                  ),
                  Text(
                    dateFormat.format(splashTransaction.transactionTime),
                    style: TextStyle(
                        color: Colors.grey, fontFamily: "GoogleSansRegular"),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              HorizontalDivider(
                  lightGrey, 1.0, MediaQuery.of(context).size.width),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          splashTransaction.pInfo,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontFamily: "GoogleSansRegular"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                        ),
                        Text(
                          getStatus(splashTransaction.paymentStatus),
                          style: TextStyle(
                              color: getColor(splashTransaction.paymentStatus),
                              fontFamily: "GoogleSansRegular"),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "₹ " + splashTransaction.amount.toString(),
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontFamily: "GoogleSansBold"),
                  ),
                ],
              )
            ],
          )),
    );
  }

  String getStatus(int paymentStatus) {
    switch (paymentStatus) {
      case 0:
        return "Pending";
      case 1:
        return "Failed";
      case 2:
        return "Pending";
      case 3:
        return "Success";
    }
  }

  getColor(int paymentStatus) {
    switch (paymentStatus) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.red;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.green;
    }
  }
}
