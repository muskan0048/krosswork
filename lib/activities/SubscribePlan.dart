import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash/beans/Plan.dart';
import 'package:splash/beans/SplashTransaction.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

class SubscribePlanActivity extends StatefulWidget {
  User user;

  SubscribePlanActivity(this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SunscribePlanState(user);
  }
}

class SunscribePlanState extends State<SubscribePlanActivity> {
  User user;
  static const platform = const MethodChannel('flutter.appyflow.in.channel');

  SunscribePlanState(this.user);

  Plan selectedPlan = null;
  int seletedIndex = -1;

  double valueOpacity = 0.0;
  List<Plan> allPlans = [];

  List<String> benefits = [
    "Free Unlimited, Reliable, Fast Wifi",
    "Exclusive F&B Discounts and Offers",
    "Fully reedemable plan with lifetime validity",
    "Network with other krossowrk Members"
  ];

  List<IconData> icons = [
    Icons.wifi,
    Icons.local_offer,
    Icons.card_giftcard,
    Icons.insert_emoticon
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: new Text(
            "Subscribe to Studdy",
            style: TextStyle(color: colorPrimary),
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
        body: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Text(
                        "Studdy Benefits",
                        style: TextStyle(
                            color: colorPrimary,
                            fontSize: 18.0,
                            fontFamily: "GoogleSansBold"),
                      ),
                      Container(
                        height: 130.0,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: benefits.length,
                            itemBuilder: (BuildContext ctxt, int Index) {
                              return Container(
                                width: 200.0,
                                child: Card(
                                  margin: EdgeInsets.all(10.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          icons.elementAt(Index),
                                          color: colorPrimary,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                        ),
                                        Text(
                                          benefits.elementAt(Index),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                              fontFamily: "GoogleSansRegular"),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(
                            "Available Plans",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: 18.0,
                                fontFamily: "GoogleSansBold"),
                          )
                        ],
                      ),
                      Container(
                          height: 280.0,
                          child: allPlans.length == 0
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection("Plans")
                                      .orderBy("price")
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Center(
                                            child: CircularProgressIndicator());
                                      default:
//            mainCallBack();
                                        allPlans.clear();

                                        return new ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                snapshot.data.documents.length,
                                            itemBuilder:
                                                (BuildContext ctxt, int Index) {
                                              allPlans.add(Plan.toObject(
                                                snapshot
                                                    .data.documents[Index].data,
                                              ));
                                              return GestureDetector(
                                                  onTap: () {},
                                                  child: Hero(
                                                      tag: snapshot
                                                          .data
                                                          .documents[Index]
                                                          .data['uid'],
                                                      child: PlanView(
                                                          Plan.toObject(
                                                            snapshot
                                                                .data
                                                                .documents[
                                                                    Index]
                                                                .data,
                                                          ),
                                                          Index,
                                                          seletedIndex,
                                                          this.selectPlan)));
                                            });
                                    }
                                  },
                                )
                              : new ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allPlans.length,
                                  itemBuilder: (BuildContext ctxt, int Index) {
                                    return GestureDetector(
                                        onTap: () {},
                                        child: Hero(
                                            tag: allPlans.elementAt(Index).uid,
                                            child: PlanView(
                                                allPlans.elementAt(Index),
                                                Index,
                                                seletedIndex,
                                                this.selectPlan)));
                                  }))
                    ],
                  ),
                )),
              ],
            ),
            seletedIndex > -1
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      color: colorPrimary,
                      minWidth: MediaQuery.of(context).size.width,
                      textColor: Colors.white,
                      onPressed: () {
                        createTransaction();

                        setState(() {
                          valueOpacity = 1.0;
                        });
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "GoogleSansRegular",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ))
                : Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
            Opacity(
              opacity: valueOpacity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ));
  }

  void selectPlan(int index) {
    setState(() {
      seletedIndex = index;
      selectedPlan = allPlans.elementAt(index);
    });
  }

  void showPaymentUi(SplashTransaction transaction) async {
    Map<dynamic, dynamic> result =
        await platform.invokeMethod('showPaymentView', <String, dynamic>{
      // data to be passed to the function
      'option': 3,
      'txnId': transaction.txnId,
      'userPhone': transaction.userPhone,
      'userEmail': transaction.userEmail,
      'userName': transaction.userName,
      'pInfo': transaction.pInfo,
      'amount': transaction.amountString
    });

    print("Hello  flutter" + result.toString());
    if (result.containsKey("status") && result.containsKey('paymentId')) {
      transaction.paymentStatus = result['status'];
      transaction.paymentId = result['paymentId'];

      updateTransaction(transaction);
    }
  }

  void subscribeToPlan() {
    Firestore.instance.collection("Users").document(user.uid).updateData({
      "redemableCredits": user.redemableCredits + selectedPlan.freeCredits,
      "paidVisits": user.paidVisits + selectedPlan.numberOfVisits,
      "lastPlan": "Plan of ₹ " +
          selectedPlan.price.toString() +
          " with " +
         // selectedPlan.validity.toString() +
          " year validity"
    }).then((result) {
      Navigator.pop(context);
    }).catchError((error) {
      setState(() {
        valueOpacity = 1.0;
      });
    });
  }

  void createTransaction() {
    SplashTransaction transaction = new SplashTransaction();

    DateTime currentTime = new DateTime.now();

    String txnId = currentTime.millisecondsSinceEpoch.toString();

    transaction.txnId = txnId.trim();
    transaction.transactionTime = currentTime;
    transaction.userId = user.uid.trim();
    transaction.userName = user.name.trim();
    transaction.userEmail = user.email.trim();
    transaction.userPhone = user.phoneNo.trim();
    transaction.plan = selectedPlan;
    transaction.amount = selectedPlan.price;
    transaction.amountString = selectedPlan.price.toString().trim();
    transaction.txnType = 0;
    transaction.paymentStatus = 0;
    transaction.creditsRedemmed = 0;
    transaction.pInfo = "Plan of ₹ " + selectedPlan.price.toString().trim();

    addTxnToDb(transaction);
  }

  void addTxnToDb(SplashTransaction transaction) {
    Firestore.instance
        .collection("Transactions")
        .document(transaction.txnId)
        .setData(transaction.getMap())
        .then((result) {
      showPaymentUi(transaction);
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }

  void updateTransaction(SplashTransaction transaction) {
    Firestore.instance
        .collection('Transactions')
        .document(transaction.txnId)
        .updateData(transaction.getMap())
        .then((updates) {
      if (transaction.paymentStatus == 3) {
        subscribeToPlan();
      } else {
        Navigator.pop(context);
      }
    });
  }
}

class PlanView extends StatelessWidget {
  Plan plan;
  int index, selectedIndex;

  Function selectPlan;

  Color color, textColor;

  PlanView(this.plan, this.index, this.selectedIndex, this.selectPlan);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    selectedIndex == index ? color = colorPrimary : Colors.white;

    selectedIndex == index ? textColor = Colors.white : colorPrimary;

    return Card(
        elevation: 2.0,
        margin: index == 0
            ? EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.25,
                top: 10.0,
                bottom: 10.0,
                right: 10.0)
            : EdgeInsets.all(10.0),
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Column(
                    children: <Widget>[
                      Text(
                        plan.numberOfVisits == 1
                            ? plan.numberOfVisits.toString() + " Sessions Plan"
                            : plan.numberOfVisits.toString() + " Sessions Plan",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontFamily: "GoogleSansRegular"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Text(
                        "₹ " + plan.price.toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontFamily: "GoogleSansBold"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      HorizontalDivider(colorGrey, 1.0, 70.0),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
//                      Text(
//                        "Get " +
//                            plan.freeCredits.toString() +
//                            " Redeemable Credits",
//                        style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 14.0,
//                            fontFamily: "GoogleSansRegular"),
//                        softWrap: true,
//                        textAlign: TextAlign.center,
//                      ),
//                      Padding(
//                        padding: EdgeInsets.only(top: 10.0),
//                      ),
                      Text(
                        plan.numberOfVisits == 1
                            ? "Valid for any " +
                                plan.numberOfVisits.toString() +
                                " Session"
                            : "Valid for any " +
                                plan.numberOfVisits.toString() +
                                " Session",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: "GoogleSansRegular"),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectPlan(index);
                        },
                        child: Container(
                          margin: EdgeInsets.all(12.0),
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: color,
                              border: new Border.all(color: colorPrimary)),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Select",
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
                      ),
                    ],
                  )),
            )));
  }
}
