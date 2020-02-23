import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash/activities/AddCreditsActivity.dart';
import 'package:splash/activities/SubscribePlan.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/res/AppColors.dart';

class WalletActivity extends StatefulWidget {
  User user;

  WalletActivity(this.user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AccountBalance(user);
  }
}

class AccountBalance extends State<WalletActivity> {
  User user;

  AccountBalance(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          elevation: 1.0,
          title: new Text(
            "Your Wallet",
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
            height: 300.0,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Your Account Balance",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "GoogleSansRegular",
                      fontSize: 16.0),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      "https://img.icons8.com/windows/1600/rupee.png",
                      height: 30.0,
                      color: colorPrimary,
                    ),
                    Text(
                      user.redemableCredits.toStringAsFixed(2),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "GoogleSansRegular",
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscribePlanActivity(user)));
                  },
                  child: Text(
                    "Subscribe to get Free Credits",
                    style: TextStyle(
                        color: colorPrimary,
                        fontFamily: "GoogleSansRegular",
                        fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Text(
                  "OR",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "GoogleSansRegular",
                      fontSize: 18.0),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: MaterialButton(
                    color: colorPrimary,
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCreditsActivity(user)));
                    },
                    child: Text(
                      "Add Credits",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "GoogleSansRegular",
                          fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
