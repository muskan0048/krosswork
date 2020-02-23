import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:splash/activities/MainActivity.dart';
import 'package:splash/activities/SignUpActivity.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/helpers/LoadingDialog.dart';
import 'package:splash/res/AppColors.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  FocusNode mobileFocusNode = new FocusNode();
  FocusNode mailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

  String phoneNo, forgotPasswordText, name, emailText;

  final formkey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _password, _email, _token;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
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
                Text(
                  "Cancel",
                  style: TextStyle(color: colorPrimary, fontSize: 10.0),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                ),
                new Text(
                  "Login into Studdy",
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
                        "Let's get started",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorPrimary,
                          fontFamily: "GoogleSansBold",
                          fontSize: 18.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      Text(
                        "Login for a delightful work experience",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "GoogleSansBold",
                          fontSize: 16.0,
                        ),
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(10.0)),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: "Your Email",
                                  hintStyle: TextStyle(color: colorGrey)),
                              validator: (value) =>
                                  value.isEmpty ? "Email is Required" : null,
                              onSaved: (value) => _email = value.trim(),
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(passwordFocusNode);
                              },
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            ),
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
                      Padding(padding: EdgeInsets.all(5.0)),
                      GestureDetector(
                        onTap: () {
                          showForgotPassword();
                        },
                        child: Text(
                          "Forgot Password ?",
                          style: TextStyle(
                              color: colorPrimary,
                              fontFamily: 'GoogleSansRegular',
                              fontSize: 16.0),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      const Text.rich(
                        TextSpan(
                          text: 'By logging in, you agree to our ',
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
                      Padding(padding: EdgeInsets.all(10.0)),
                      new RaisedButton(
                        onPressed: () {
                          signin(context);
                        },
                        textColor: Colors.white,
                        color: colorPrimary,
                        child: new Text("Login Securely"),
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          HorizontalDivider(colorGrey, 1.0, 100.0),
                          Text(
                            "Or",
                            style: TextStyle(color: colorGrey),
                          ),
                          HorizontalDivider(colorGrey, 1.0, 100.0),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(CupertinoPageRoute(
                                    builder: (context) => SignUpPage()));
                          },
                          child: new Text(
                            "Create Account",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorPrimary),
                          ))
                    ],
                  ))),
        )));
  }

  void signin(BuildContext context) {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();

      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 4),
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text("  Logging-In...")
          ],
        ),
      ));

      print("Hello");
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((currentUser) {
        print("Hello");
        print(currentUser.toString());

        _firebaseMessaging.getToken().then((token) {
          print(token);
          _token = token;
          Firestore.instance
              .collection("Users")
              .document(currentUser.uid)
              .updateData({"token": _token});
        }).then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainActivity()));
        }).catchError((error) {
          print("Error is " + error.toString());
          showError(error.toString(), "Error");
        });
      }).catchError((error) {
        print("Error is " + error.toString());
        showError(error.toString(), "Error");
      });
    } else {}
  }

  void showForgotPassword() {
    showDemoDialog<String>(
      context: context,
      child: CupertinoAlertDialog(
        title: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text('Forgot Password ?')),
        content: CupertinoTextField(
          textInputAction: TextInputAction.next,
          placeholder: "Mobile Number ",
          prefix: Text(
            "+91",
            style: TextStyle(color: colorPrimary),
          ),
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            phoneNo = value.toString();
            print(phoneNo);
          },
//              onSaved: (value) => phoneNo = value.trim(),
          maxLength: 10,

          style: TextStyle(fontSize: 15.0, color: Colors.black),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, 'Disallow');
            },
          ),
          CupertinoDialogAction(
            child: const Text('Send Password'),
            onPressed: () {
              if (phoneNo.isEmpty) {
                return "Mobile Number is required";
              } else if (phoneNo.length != 10) {
                return "Valid Mobile Number is required";
              } else {
                Navigator.pop(context, 'Send Password');

                LoadingDialog.showLoadingDialog(context);
                forgotPassword();

                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,

//      new AlertDialog(
//            title: const Text('Forgot Password ?'),
//
//            content: TextField(
//                textInputAction: TextInputAction.next,
//                decoration: InputDecoration(
//                    labelText: "Mobile Number",
//                    hintText: "Mobile Number ",
//                    prefixText: "+91 ",
//                    hintStyle: TextStyle(color: colorGrey)),
//                keyboardType: TextInputType.phone,
//                onSubmitted: (value) {
//                  if (value.isEmpty) {
//                    return "Mobile Number is required";
//                  } else if (value.length != 10) {
//                    return "Valid Mobile Number is required";
//                  } else {
//                    return null;
//                  }
//                },
////              onSaved: (value) => phoneNo = value.trim(),
//                maxLength: 10,
//                style: TextStyle(fontSize: 16.0, color: Colors.black)),
//            actions: <Widget>[
//
//
//              GestureDetector(
//                child: Text(
//                  'Cancel',
//                  style: TextStyle(
//                      color: colorPrimary,
//                      fontSize: 18.0,
//                      fontFamily: 'GoogleSansRegular'),
//                ),
//                onTap: () {
//                  Navigator.pop(context, 'Disallow');
//                },
//              ),
//              Padding(
//                padding: EdgeInsets.only(left: 10.0, right: 10.0),
//              ),
//              GestureDetector(
//                child: Text(
//                  'Send Password',
//                  style: TextStyle(
//                      color: colorPrimary,
//                      fontSize: 18.0,
//                      fontFamily: 'GoogleSansBold'),
//                ),
//                onTap: () {
//                  Navigator.pop(context, 'Send Password');
//                },
//              ),
//            ],
//          ),
    );
  }

  void forgotPassword() {
    checkPhoneInDB().then((present) {
      if (present) {
        sendSMS().then((result) {
          if (result) {
            Navigator.pop(context);
            showError('Password Sent', "Success");
          }
        });
      }
    });
  }

  Future<bool> checkPhoneInDB() async {
    bool response = false;

    await Firestore.instance
        .collection('Users')
        .where('phoneNo', isEqualTo: phoneNo)
        .limit(1)
        .getDocuments()
        .then((result) {
      if (result != null && result.documents.length == 0) {
        Navigator.pop(context);
        showError('Mobile Number is not registered.', "Error");
        response = false;
      } else if (result.documents.length > 0) {
        forgotPasswordText = result.documents.first.data['password'];
        emailText = result.documents.first.data['email'];
        name = result.documents.first.data['name'];
        print("New SignUp");
        response = true;
      }
    });

    return response;
  }

  void showError(String error, String title) {
    showDemoDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text(title,
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

  Future<bool> sendSMS() async {
    var msg = "Dear " +
        name +
        ". We have recieved a forgot password request. Your Login details are : Email : " +
        emailText +
        " Password:" +
        forgotPasswordText +
        '.Please do not share this with anyone. Thank you, Krosswork';

    msg = msg.replaceAll(" ", "%20");

    final response = await http.get(
        'http://api.msg91.com/api/sendhttp.php?sender=SPLASH&route=4&mobiles=' +
            phoneNo +
            '&authkey=319476AacwN9xJ5e4f9b4eP1&country=91&message=' +
            msg);
    print("Response :" + response.body);

    return true;
  }

//  void saveUserInDb() {
//    user.status = 1;
//    Firestore.instance
//        .collection("Users")
//        .document(user.uid)
//        .setData(user.getMap())
//        .then((currentUser) {
//      print("User saved Successfully");
//    }).catchError((error) {
//      Scaffold.of(context).showSnackBar(SnackBar(
//          content: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
//        Container(
//            margin: EdgeInsets.only(left: 20.0),
//            child: Text("Error Occured " + error.toString(),
//                style: TextStyle(fontStyle: FontStyle.italic)))
//      ])));
//    });
//  }
}
