import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash/beans/SplashTransaction.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/LoadingDialog.dart';
import 'package:splash/res/AppColors.dart';

class AddCreditsActivity extends StatefulWidget {
  User user;

  AddCreditsActivity(this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddCredits(user);
  }
}

class AddCredits extends State<AddCreditsActivity> {
  User user;

  AddCredits(this.user);

  TextEditingController amountController = TextEditingController();

  static const platform = const MethodChannel('flutter.appyflow.in.channel');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          elevation: 1.0,
          title: new Text(
            "Add Credits",
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
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                Text(
                  "Recharge Amount",
                  style: TextStyle(
                      color: colorPrimary,
                      fontFamily: "GoogleSansRegular",
                      fontSize: 16.0),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: TextField(
                    onChanged: (value) {},
                    controller: amountController,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        hintText: "Amount (₹) ",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 18.0)),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "GoogleSansRegular",
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: MaterialButton(
                    color: colorPrimary,
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      double amount = 0;

                      try {
                        amount = double.parse(amountController.text.toString());
                        createTransaction(amount);
                      } catch (error) {
                        print("E " + error.toString());
                      }

//                if (amount <= 0) {
//                  print("Adding Credits");
//                  addCredits();
//                } else {
//                  print("Invalid Amount");
//                  //message enter valid amount
//                }
                    },
                    child: Text(
                      "Proceed to Add Credits",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "GoogleSansRegular",
                          fontSize: 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Text(
                  "Powered By",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "GoogleSansRegular",
                      fontSize: 16.0),
                ),
                Image.asset(
                  "razorpay.png",
                  height: 50.0,
                )
              ],
            )),
          ),
        ));
  }

  void addCredits(double amount) {
    print(user.redemableCredits.toString() +
        " " +
        user.uid +
        " " +
        amount.toString() +
        " " +
        amountController.text);

    Firestore.instance.collection("Users").document(user.uid).updateData(
        {"redemableCredits": (user.redemableCredits + amount)}).then((value) {
      print("Added Successfully");

      Navigator.pop(context);
    }).catchError((error) {
      print(error.toString());
    });
  }

  void createTransaction(double amount) {
    LoadingDialog.showLoadingDialog(context);

    SplashTransaction transaction = new SplashTransaction();

    DateTime currentTime = new DateTime.now();

    String txnId = currentTime.millisecondsSinceEpoch.toString();

    transaction.txnId = txnId.trim();
    transaction.transactionTime = currentTime;
    transaction.userId = user.uid.trim();
    transaction.userName = user.name.trim();
    transaction.userEmail = user.email.trim();
    transaction.userPhone = user.phoneNo.trim();
    transaction.plan = null;
    transaction.amount = amount;
    transaction.amountString = amount.toString().trim();
    transaction.txnType = 1;
    transaction.paymentStatus = 0;
    transaction.creditsRedemmed = 0;
    transaction.pInfo = "Adding credits ₹ " + amount.toString().trim();

    print(transaction.toString());

    addTxnToDb(transaction);
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
        amountController.clear();
        addCredits(transaction.amount);
      } else {
        Navigator.pop(context);
      }
    });
  }
}
