import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splash/activities/LoginActivity.dart';
import 'package:splash/activities/MainActivity.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/LoadingDialog.dart';
import 'package:splash/res/AppColors.dart';

import 'OtpVerifyActivity.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  FocusNode mobileFocusNode = new FocusNode();
  FocusNode mailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  var code = 507567;
  User user = new User();

  String _password;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
            elevation: 2.0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: colorPrimary, fontSize: 10.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                ),
                new Text(
                  "Create a New Studdy Account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Welcome to Study Buddy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorPrimary,
                          fontFamily: "GoogleSansBold",
                          fontSize: 16.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      Form(
                        key: formkey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  hintText: "Your Name",
                                  hintStyle: TextStyle(color: colorGrey)),
                              validator: (value) =>
                                  value.isEmpty ? "Name is Required" : null,
                              onSaved: (value) => user.name = value.trim(),
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(mailFocusNode);
                              },
                            ),
                            Padding(padding: EdgeInsets.all(10.0)),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: "Your Email",
                                  hintStyle: TextStyle(color: colorGrey)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Email is Required";
                                } else if (!isEmail(value.toString())) {
                                  return "Valid Email is Required";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) => user.email = value.trim(),
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(mobileFocusNode);
                              },
                              focusNode: mailFocusNode,
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            Padding(padding: EdgeInsets.all(10.0)),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: "Mobile Number",
                                  hintText: "Mobile Number ",
                                  prefixText: "+91 ",
                                  hintStyle: TextStyle(color: colorGrey)),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Mobile Number is required";
                                } else if (value.length != 10) {
                                  return "Valid Mobile Number is required";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) => user.phoneNo = value.trim(),
                              maxLength: 10,
                              focusNode: mobileFocusNode,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocusNode);
                              },
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                            Padding(padding: EdgeInsets.all(3.0)),
                            TextFormField(
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  hintText: "Minimum 6 characters",
                                  hintStyle: TextStyle(color: colorGrey)),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password is required";
                                } else if (value.length < 6) {
                                  return "Minimum 6 characters are required";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) => _password = value.trim(),
                              maxLines: 1,
                              focusNode: passwordFocusNode,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      const Text.rich(
                        TextSpan(
                          text: 'By creating this account, you agree to our ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.0), // default text style
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Terms & Conditions ',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: ' and  ',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11.0), // default text style
                            ),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(15.0)),
                      new RaisedButton(
                        onPressed: () {
                          signUp();
                        },
                        textColor: Colors.white,
                        color: colorPrimary,
                        child: new Text("Create a New Account"),
                      ),
                      Padding(padding: EdgeInsets.all(15.0)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: new Text(
                          "Login to StudyBuddy",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorPrimary),
                        ),
                      )
                    ],
                  ))),
        )));
  }

  void signUp() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();

      showDemoDialog<String>(
        context: context,
        child: CupertinoAlertDialog(
          title: Text('Verify +91' + user.phoneNo.toString()),
          content: const Text(
              'We ll send a SMS containing 4 digit code to verify your mobile.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
            CupertinoDialogAction(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.pop(context, 'Okay');

                LoadingDialog.showLoadingDialog(context);

                checkPhoneInDB().then((result) {
                  if (result == true) {
                    sendSMS().then((r) {
                      if (r) {
                        Navigator.pop(context);

                        Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => OtpVerifyActivity(
                                        code.toString(), user.phoneNo)))
                            .then((value) {
                          if (value == true) {
                            LoadingDialog.showLoadingDialog(context);

                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: user.email, password: _password)
                                .then((currentUser) {
                              print(currentUser.toString());
                              user.uid = currentUser.uid;

                              saveUserInDb();
                            }).catchError((error) {
                              Navigator.pop(context);

                              showError(error.toString());
                            });
                          }
                        });
                      }
                    });
                  }
                });
              },
            ),
          ],
        ),
      );
    } else {}
  }

  bool isEmail(String em) {
    RegExp regExp = new RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return regExp.hasMatch(em);
  }

  void saveUserInDb() {
    user.status = 1;
    user.trial = 1;
    user.paidVisits = 0;
    user.password = _password;
    user.redemableCredits = 0;
    user.creationDate = DateTime.now();
    user.nameLower = user.name.toLowerCase();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      user.token = token;

      Firestore.instance
          .collection("Users")
          .document(user.uid)
          .setData(user.getMap())
          .then((currentUser) {
        print("User saved Successfully");

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainActivity()));
      }).catchError((error) {
        showError(error.toString());
      });
    });
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );
  }

  Future<bool> sendSMS() async {
    var rng = new Random();
    code = rng.nextInt(9999);

    print(code);

    var msg = "Dear " +
        user.name +
        ". Welcome to STudyBuddy. Your STudyBuddy verification code is " +
        code.toString() +
        '.Please do not share this OTP with anyone. Thank you, Krosswork';

    msg = msg.replaceAll(" ", "%20");

    final response = await http.get(
        'http://api.msg91.com/api/sendhttp.php?sender=STUDDY&route=4&mobiles=' +
            user.phoneNo +
            '&authkey=319476AacwN9xJ5e4f9b4eP1&country=91&message=' +
            msg);
    print("Response :" + response.body);

    return true;
  }

  Future<bool> checkPhoneInDB() async {
    bool response = false;

    await Firestore.instance
        .collection('Users')
        .where('phoneNo', isEqualTo: user.phoneNo)
        .limit(1)
        .getDocuments()
        .then((result) {
      if (result != null && result.documents.length == 0) {
        print("New SignUp");
        response = true;
      } else if (result.documents.length > 0) {
        Navigator.pop(context);
        showError('Mobile Number is Already registered.');
        response = false;
      }
    });

    return response;
  }

  void showError(String error) {
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
}
