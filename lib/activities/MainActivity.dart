import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash/activities/ChatMessagePage.dart';
import 'package:splash/activities/HomePage.dart';
import 'package:splash/activities/MyAccountPage.dart';
import 'package:splash/activities/SplashBoardPage.dart';
import 'package:splash/res/AppColors.dart';

class MainActivity extends StatefulWidget {
  @override
  State createState() {
    return MainActivityState();
  }
}

class MainActivityState extends State<MainActivity> {
  int _currentIndex = 0;

  HomePage homePage;
  SplashBoard splashBoard = SplashBoard();
  ChatMessage chatMessage = ChatMessage();
  MyAccount myAccount = MyAccount();

  List<Widget> _children;

  final PageStorageBucket bucket = PageStorageBucket();

  final Key keyHome = PageStorageKey('homePage');
  final Key keyBoard = PageStorageKey('splashBoard');
  final Key keyChat = PageStorageKey('chatMessage');
  final Key keyAccount = PageStorageKey('myAccount');

  Widget currentPage;

  @override
  void initState() {
    super.initState();

    homePage = HomePage(key: keyHome);
    splashBoard = SplashBoard(key: keyBoard);
    chatMessage = ChatMessage(key: keyChat);
    myAccount = MyAccount(key: keyAccount);

    _children = [homePage, splashBoard, chatMessage, myAccount];

    currentPage = homePage;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      currentPage = _children[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
//            primaryColor: Colors.red,
//              textTheme: Theme.of(context)
//                  .textTheme
//                  .copyWith(caption: new TextStyle(color: Colors.yellow))
          ),
          child: BottomNavigationBar(
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text("Home")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.developer_board),
                  title: Text("Studdy Board")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), title: Text("Messages")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text("Account"))
            ],
            currentIndex: _currentIndex,
            fixedColor: colorPrimary,
            type: BottomNavigationBarType.fixed,
          )),
    );
  }

//  void getUserDetails() {
//    FirebaseAuth.instance.currentUser().then((v) {
//      if (v != null) {
//        name = v.email;
//      } else {
//        name = "";
//      }
//
//      setState(() {});
//    });
//  }

//  void logout() {
//    _scaffoldKey.currentState.showSnackBar(new SnackBar(
//      duration: new Duration(seconds: 4),
//      content: new Row(
//        children: <Widget>[
//          new CircularProgressIndicator(),
//          new Text("  Loging-Out...")
//        ],
//      ),
//    ));
//
//    FirebaseAuth.instance.signOut().then((value) {
//      Navigator.pushReplacement(
//          context, MaterialPageRoute(builder: (context) => LoginPage()));
//    }).catchError((e) {
//      _scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
//        Container(
//            margin: EdgeInsets.only(left: 20.0),
//            child: Text("Error Occured " + e.toString(),
//                style: TextStyle(fontStyle: FontStyle.italic)))
//      ])));
//    });
//  }

//  void getAddress(double lat, double lng) async {
//    print("I am called");
//    final coordinates = new Coordinates(lat, lng);
//    List<Address> addresses =
//        await Geocoder.local.findAddressesFromCoordinates(coordinates);
//    if (addresses.length > 0) {
//      Address first = addresses.first;
//      addressTitle =
//          first.subLocality + "," + first.subAdminArea + "," + first.adminArea;
//      addressLine = first.addressLine;
//      print("${first.featureName} : ${first.addressLine} " +
//          first.toMap().toString());
//    }
//
//    setState(() {});
//  }
}
