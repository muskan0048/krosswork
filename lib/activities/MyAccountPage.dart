import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';
import 'package:splash/activities/AddCreditsActivity.dart';
import 'package:splash/activities/LoginActivity.dart';
import 'package:splash/activities/MyReservationsActivity.dart';
import 'package:splash/activities/SubscribePlan.dart';
import 'package:splash/activities/TransactionHistoryActivity.dart';
import 'package:splash/activities/WalletActivity.dart';
import 'package:splash/beans/SplashTransaction.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/helpers/LoadingDialog.dart';
import 'package:splash/helpers/MyAlertDialog.dart';
import 'package:splash/res/AppColors.dart';

TextEditingController amountController = TextEditingController();

class MyAccount extends StatefulWidget {
  MyAccount({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAccountState();
  }
}

class MyAccountState extends State<MyAccount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String name = "", email = "", phone = "";

  var userListener;

  User user;

  File _image;

  String addressTitle = "";

  void updateUserInDB(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context);

    Firestore.instance
        .collection("Users")
        .document(user.uid)
        .updateData(user.getMap())
        .then((result) {
      Navigator.pop(context);
    });
  }

  int selected = 0;

  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      uploadImage();
    }

    setState(() {});
  }

  void uploadImage() async {
//    final Directory systemTempDir = Directory.systemTemp;
//    final File file = await File('${systemTempDir.path}/foo$uuid.txt').create();
//    await file.writeAsString(kTestString);
//    assert(await file.readAsString() == kTestString);
//    final StorageReference ref =
//    widget.storage.ref().child('text').child('foo$uuid.txt');

    LoadingDialog.showLoadingDialog(context);

    StorageReference ref =
        FirebaseStorage.instance.ref().child("Users/" + user.uid);
    final StorageUploadTask uploadTask = ref.putFile(
      _image,
      StorageMetadata(contentType: "image/jpeg"),
    );

    uploadTask.events.listen((events) {
      if (uploadTask.isComplete) {
        print("Upload Complete");
        ref.getDownloadURL().then((url) {
          Navigator.pop(context);
          user.imageUrl = url.toString();
          print(user.imageUrl);
          updateUserInDB(context);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("initstate called");

    getUserDetails();
  }

  void getUserDetails() async {
    FirebaseAuth.instance.currentUser().then((v) {
      if (v != null) {
        userListener = Firestore.instance
            .collection('Users')
            .document(v.uid)
            .snapshots()
            .listen((firebaseUser) {
          user = User.mapToUser(firebaseUser.data);

          if (user.status == 0 || user.email == null) {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }).catchError((e) {
              print("Error " + e.toString());
            });
          }

          try {
            getAddress(user.lat, user.lng);
          } catch (e) {
            print(e);
          }

          name = firebaseUser.data['name'];
          email = firebaseUser.data['email'];

          if (firebaseUser.data['phoneNo'] != null) {
            phone = firebaseUser.data['phoneNo'];
          }
          print('i am called' + name);

          setState(() {});
        });
      } else {
        name = "";
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    print("dispose called");

    userListener?.cancel();
  }

  void getAddress(double lat, double lng) async {
    print("I am called");
    final coordinates = new Coordinates(lat, lng);
    List<Address> addresses =
    await Geocoder.google("AIzaSyAlVrEyOOalLJDd11N95KkvTxxRmpO6p0w").findAddressesFromCoordinates(coordinates);
    if (addresses.length > 0) {
      Address first = addresses.first;

      if (first.subLocality != null) {
        addressTitle = first.subLocality + ",";
      } else if (first.locality != null) {
        addressTitle = first.locality + ",";
      }

      if (first.subAdminArea != null) {
        addressTitle += first.subAdminArea + ",";
      }

      if (first.adminArea != null) {
        addressTitle += first.adminArea;
      }

      print("${first.featureName} : ${first.addressLine} " +
          first.toMap().toString());
    }

    setState(() {});
  }

//  @override
//  void deactivate() {
//    // TODO: implement deactivate
//    super.deactivate();
//
//    print("deactivate called");
//
//    userListener?.cancel();
//  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();

    print("reassemble called");

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: DrawerView(user),
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: MaterialButton(
            elevation: 0.0,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
            )
          ],
        ),
        backgroundColor: lightGrey,
        body: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            UserInfo(name, email, phone, ImageSet, addressTitle, user),
            Padding(
              padding: EdgeInsets.all(1.0),
            ),
            CreditsInfo(this.callback, selected, user),
            Padding(
              padding: EdgeInsets.all(10.0),
            )
          ],
        )));
  }

  void ImageSet() {
    getImage();
  }

  void callback(option) {
    setState(() {
      selected = option;
    });
  }
}

class CreditsInfo extends StatelessWidget {
  Function onPressed;
  int selected;

  User user;

  CreditsInfo(this.onPressed, this.selected, this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        elevation: 0.0,
        child: Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child:
                      Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                onPressed(0);
                              },
                              child: Text(
                                "Plan",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "GoogleSansRegular"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            selected == 0
                                ? HorizontalDivider(Colors.red, 3.0, 100.0)
                                : Container(
                                    width: 100.0,
                                  )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                onPressed(1);
                              },
                              child: Text(
                                "Wallet",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "GoogleSansRegular"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            selected == 1
                                ? HorizontalDivider(Colors.red, 3.0, 100.0)
                                : Container(
                                    width: 100.0,
                                  )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                onPressed(2);
                              },
                              child: Text(
                                "Add Credits",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "GoogleSansRegular"),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                            ),
                            selected == 2
                                ? HorizontalDivider(Colors.red, 3.0, 100.0)
                                : Container(
                                    width: 100.0,
                                  )
                          ],
                        )
                      ],
                    ),
                    HorizontalDivider(
                        colorGrey, 1.0, MediaQuery.of(context).size.width),
                    TabView(selected, user),
                  ]),
                )
              ],
            )));
  }
}

class TabView extends StatelessWidget {
  int selected;

  User user;

  TabView(this.selected, this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    switch (selected) {
      case 0:
        return PlanInfo(user);
      case 1:
        return AccountBalance(user);

      case 2:
        return AddCredits(context, user);
    }

    return null;
  }
}

class PlanInfo extends StatelessWidget {
  User user;

  PlanInfo(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 300.0,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          user != null && user.paidVisits != null && user.paidVisits != 0
              ? Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: colorPrimary, shape: BoxShape.circle),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                        child: Text(
                      user.paidVisits.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: "GoogleSansBold"),
                    )),
                  ),
                )
              : Image.network(
                  "https://img.icons8.com/windows/1600/rupee.png",
                  height: 70.0,
                  color: colorPrimary,
                ),
          Text(
            user != null && user.paidVisits != null && user.paidVisits != 0
                ? "Visits Left"
                : "You are subscribed to no Plan",
            style: TextStyle(
                color: Colors.grey,
                fontFamily: "GoogleSansRegular",
                fontSize: 16.0),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => new SubscribePlanActivity(user)));
            },
            child: Text(
              user != null && user.paidVisits != null && user.paidVisits != 0
                  ? user.lastPlan
                  : "SUBSCRIBE NOW",
              style: TextStyle(
                  color: colorPrimary,
                  fontFamily: "GoogleSansRegular",
                  fontSize: 18.0),
            ),
          ),
        ],
      )),
    );
  }
}

class AccountBalance extends StatelessWidget {
  User user;

  AccountBalance(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
                  CupertinoPageRoute(
                      builder: (context) => new SubscribePlanActivity(user)));
            },
            child: Text(
              "Subscribe to get Free Credits",
              style: TextStyle(
                  color: colorPrimary,
                  fontFamily: "GoogleSansRegular",
                  fontSize: 18.0),
            ),
          ),
        ],
      )),
    );
  }
}

class AddCredits extends StatelessWidget {
  BuildContext context;

  User user;

  AddCredits(this.context, this.user);

  static const platform = const MethodChannel('flutter.appyflow.in.channel');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
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
    );
  }

  void addCredits(double amount) async {
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

  void createTransaction(double amount) async {
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
    Map<dynamic, dynamic> resultAddingCredits =
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

    print("Hello  flutter" + resultAddingCredits.toString());
    if (resultAddingCredits.containsKey("status") &&
        resultAddingCredits.containsKey('paymentId')) {
      transaction.paymentStatus = resultAddingCredits['status'];
      transaction.paymentId = resultAddingCredits['paymentId'];
      updateTransaction(transaction);
    }
  }

  void addTxnToDb(SplashTransaction transaction) async {
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

  void updateTransaction(SplashTransaction transaction) async {
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

class UserInfo extends StatelessWidget {
  String name = "", email = "", phone = "";

  Function getImage;
  String addressTitle = "";

  User user;

  UserInfo(this.name, this.email, this.phone, this.getImage, this.addressTitle,
      this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Colors.white,
      elevation: 0.0,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: "GoogleSansRegular",
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 14.0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                            ),
                            Expanded(
                              child: Text(
                                addressTitle,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "GoogleSansRegular",
                                    fontSize: 18.0),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: colorPrimary,
                              size: 16.0,
                            ),
                            Padding(
                              padding: EdgeInsets.all(3.0),
                            ),
                            Expanded(
                              child: Text(
                                "+91 " + phone,
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: colorPrimary,
                                    fontFamily: "GoogleSansRegular",
                                    fontSize: 16.0),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: user != null && user.imageUrl != null
                            ? Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          user.imageUrl,
                                        ))))
                            : Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    "Add\nPhoto",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Edit",
                        style: TextStyle(color: colorPrimary),
                      )
                    ],
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 16.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Expanded(
                    child: Text(
                      email,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "GoogleSansRegular",
                          fontSize: 16.0),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                MyReservationsActivity(user.uid)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.developer_board,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(3.0),
                        ),
                        Expanded(
                          child: Text(
                            "Your Sessions",
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "GoogleSansRegular",
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                          size: 16.0,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: colorGrey)),
                  ))
            ],
          )),
    );
  }
}

class DrawerView extends StatelessWidget {
  User user;

  DrawerView(this.user);

  List<String> menu1 = [
    "Subscribe to Plan",
    'Add Credits',
    'Account Balance',
    'Refer & Earn'
  ];

  List<IconData> menu1Icons = [
    Icons.credit_card,
    Icons.add,
    Icons.attach_money,
    Icons.redeem
  ];

  List<String> menu2 = ["Payment History", 'Mentor Sessions'];

  List<IconData> menu2Icons = [
    Icons.closed_caption,
    Icons.access_time,
  ];

  List<String> menu3 = ["Community Events", 'Community Benefits'];

  List<IconData> menu3Icons = [
    Icons.calendar_today,
    Icons.mood,
  ];

  List<String> menu4 = [
    "Request Guest Access",
    'Preferences',
    'Support',
    'FAQs',
    'Rate us',
    'Blog',
    'Logout'
  ];

  List<IconData> menu4Icons = [
    Icons.people_outline,
    Icons.settings,
    Icons.contact_phone,
    Icons.help_outline,
    Icons.star,
    Icons.wifi_tethering,
    Icons.power_settings_new,
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            leading: MaterialButton(
              elevation: 0.0,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.clear,
                color: Colors.black,
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Card(
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: 35.0,
                              height: 35.0,
                              decoration: BoxDecoration(
                                  color: Colors.green, shape: BoxShape.circle),
                              child: Center(
                                  child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ))),
                          Padding(
                            padding: EdgeInsets.all(3.0),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Subscription & Account",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "GoogleSansRegular",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              Text(
                                "Subscribe,Add Credits,Balance etc.",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "GoogleSansRegular",
                                    fontSize: 12.0),
                              ),
                            ],
                          ))
                        ],
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  menu1CallBack(index, context);
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      menu1Icons[index],
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5.0),
                                    ),
                                    Expanded(
                                      child: Text(
                                        menu1[index],
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
                              ));
                        },
                        itemCount: menu1.length,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Card(
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: 35.0,
                              height: 35.0,
                              decoration: BoxDecoration(
                                  color: colorPrimary, shape: BoxShape.circle),
                              child: Center(
                                  child: Icon(
                                Icons.monetization_on,
                                color: Colors.white,
                              ))),
                          Padding(
                            padding: EdgeInsets.all(3.0),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Transactions History",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "GoogleSansRegular",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              Text(
                                "Payments,Reservations etc.",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "GoogleSansRegular",
                                    fontSize: 12.0),
                              ),
                            ],
                          ))
                        ],
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () {
                              menu2CallBack(index, context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    menu2Icons[index],
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                  Expanded(
                                    child: Text(
                                      menu2[index],
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
                            ),
                          );
                        },
                        itemCount: menu2.length,
                      )
                    ],
                  ),
                ),
              ),
//              Padding(
//                padding: EdgeInsets.all(5.0),
//              ),
//              Card(
//                elevation: 0.0,
//                child: Padding(
//                  padding: EdgeInsets.all(10.0),
//                  child: Column(
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          Container(
//                              width: 35.0,
//                              height: 35.0,
//                              decoration: BoxDecoration(
//                                  color: Colors.redAccent,
//                                  shape: BoxShape.circle),
//                              child: Center(
//                                  child: Icon(
//                                Icons.comment,
//                                color: Colors.white,
//                              ))),
//                          Padding(
//                            padding: EdgeInsets.all(3.0),
//                          ),
//                          Expanded(
//                              child: Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            mainAxisSize: MainAxisSize.max,
//                            children: <Widget>[
//                              Text(
//                                "Community",
//                                softWrap: true,
//                                maxLines: 1,
//                                overflow: TextOverflow.ellipsis,
//                                style: TextStyle(
//                                    color: Colors.black,
//                                    fontFamily: "GoogleSansRegular",
//                                    fontWeight: FontWeight.bold,
//                                    fontSize: 14.0),
//                              ),
//                              Text(
//                                "Events,Benefits etc.",
//                                softWrap: true,
//                                maxLines: 1,
//                                overflow: TextOverflow.ellipsis,
//                                style: TextStyle(
//                                    color: Colors.grey,
//                                    fontFamily: "GoogleSansRegular",
//                                    fontSize: 12.0),
//                              ),
//                            ],
//                          ))
//                        ],
//                      ),
//                      ListView.builder(
//                        physics: NeverScrollableScrollPhysics(),
//                        shrinkWrap: true,
//                        itemBuilder: (BuildContext context, index) {
//                          return Padding(
//                            padding: EdgeInsets.only(
//                                top: 10.0, bottom: 10.0, left: 5.0),
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  menu3Icons[index],
//                                  color: Colors.black,
//                                ),
//                                Padding(
//                                  padding: EdgeInsets.all(5.0),
//                                ),
//                                Expanded(
//                                  child: Text(
//                                    menu3[index],
//                                    softWrap: true,
//                                    maxLines: 1,
//                                    overflow: TextOverflow.ellipsis,
//                                    style: TextStyle(
//                                        color: Colors.black,
//                                        fontFamily: "GoogleSansRegular",
//                                        fontSize: 14.0),
//                                  ),
//                                )
//                              ],
//                            ),
//                          );
//                        },
//                        itemCount: menu3.length,
//                      )
//                    ],
//                  ),
//                ),
//              ),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Card(
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              width: 35.0,
                              height: 35.0,
                              decoration: BoxDecoration(
                                  color: Colors.grey, shape: BoxShape.circle),
                              child: Center(
                                  child: Icon(
                                Icons.settings,
                                color: Colors.white,
                              ))),
                          Padding(
                            padding: EdgeInsets.all(3.0),
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Others",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "GoogleSansRegular",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              Text(
                                "Support,FAQs,Logout etc.",
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "GoogleSansRegular",
                                    fontSize: 12.0),
                              ),
                            ],
                          ))
                        ],
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () {
                              menu4CallBack(index, context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    menu4Icons[index],
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                  Expanded(
                                    child: Text(
                                      menu4[index],
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
                            ),
                          );
                        },
                        itemCount: menu4.length,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Text(
                        "App Version 1.0",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 14.0),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),
                      Text(
                        "Studdy",
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void menu1CallBack(int index, BuildContext context) async {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SubscribePlanActivity(user)));
        break;
      case 1:
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => AddCreditsActivity(user)));
        break;
      case 2:
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => WalletActivity(user)));
        break;
      case 3:
        MyAlertDialog.showError("Coming Soon", context, title: "Oops...");
        break;
    }
  }

  void menu2CallBack(int index, BuildContext context) async {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => TransactionHistoryActivity(user)));
        break;

      case 1:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MyReservationsActivity(user.uid)));
        break;
    }
  }

  void menu4CallBack(int index, BuildContext context) async {
    switch (index) {
      case 4:
        LaunchReview.launch();
        break;

      case 6:
        logout(context);
        break;
      default:
        MyAlertDialog.showError("Coming Soon", context, title: "Oops...");
    }
  }

  void logout(BuildContext context) {
    showDemoDialog<String>(
      context: context,
      child: CupertinoAlertDialog(
        title: const Text('Logout ?'),
        content: const Text('Are you Sure to Logout ?'),
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
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }).catchError((e) {
                showError(e.toString(), context);
              });
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
}
