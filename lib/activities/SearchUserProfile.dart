import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash/activities/UserProfile.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

class SearchUserActivity extends StatefulWidget {
  String _myUid;

  SearchUserActivity(this._myUid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchUserState(_myUid);
  }
}

class SearchUserState extends State<SearchUserActivity> {
  List<User> _users = [];

  String myUid;

  SearchUserState(this.myUid);

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        centerTitle: false,
        leading: MaterialButton(
          elevation: 0.0,
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.transparent,
          child: Icon(
            Icons.close,
            color: colorPrimary,
          ),
        ),
        title: Container(
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
//                              GestureDetector(
//                                onTap: () {},
//                                child: Icon(
//                                  CupertinoIcons.photo_camera_solid,
//                                  size: 30.0,
//                                  color: colorPrimary,
//                                ),
//                              ),
//                              Padding(
//                                padding: EdgeInsets.only(left: 10.0),
//                              ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        maxLines: 1,
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 18.0),
                        decoration: new InputDecoration.collapsed(
                            hintText: "Search by name , email or phone"),
//                                decoration: new InputDecoration(
//                                    contentPadding: EdgeInsets.all(10.0),
//                                    border: new OutlineInputBorder(
//                                        borderRadius: const BorderRadius.all(
//                                          const Radius.circular(25.0),
//                                        ),
//                                        borderSide:
//                                        BorderSide(color: Colors.white)),
//                                    filled: true,
//                                    fillColor: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchUsers();
                    },
                    child: Icon(
                      Icons.search,
                      size: 30.0,
                      color: colorPrimary,
                    ),
                  )
                ],
              )),
        ),
      ),
      body: _users.length > 0
          ? Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: UsersList(_users, myUid))
          : Center(child: CupertinoActivityIndicator()),
    );
  }

  void getAllUsers() async {
    Firestore.instance
        .collection("Users")
        .where("status", isEqualTo: 1)
        .orderBy("lastSeen", descending: true)
        .limit(10)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((doc) {
        _users.add(User.mapToUser(doc.data));
      });

      setState(() {});
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }

  void searchUsers() async {
    print("Query is " + searchController.text);
    _users.clear();

    searchName();
    searchEmail();
    searchPhone();
  }

  void searchName() async {
    Firestore.instance
        .collection("Users")
        .startAt([searchController.text.toLowerCase()])
        .endAt([searchController.text.toLowerCase() + "\uf8ff"])
        .where("status", isEqualTo: 1)
        .orderBy("nameLower")
        .orderBy("lastSeen", descending: true)
        .limit(10)
        .getDocuments()
        .then((docs) {
          docs.documents.forEach((doc) {
            _users.add(User.mapToUser(doc.data));
          });

          setState(() {});
        })
        .catchError((error) {
          print("Error is " + error.toString());
        });
  }

  void searchEmail() async {
    Firestore.instance
        .collection("Users")
        .where("status", isEqualTo: 1)
        .where("email", isEqualTo: searchController.text)
        .orderBy("lastSeen", descending: true)
        .limit(10)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((doc) {
        _users.add(User.mapToUser(doc.data));
      });

      setState(() {});
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }

  void searchPhone() async {
    Firestore.instance
        .collection("Users")
        .where("status", isEqualTo: 1)
        .where("phoneNo", isEqualTo: searchController.text)
        .orderBy("lastSeen", descending: true)
        .limit(10)
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((doc) {
        _users.add(User.mapToUser(doc.data));
      });

      setState(() {});
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }
}

class UsersList extends StatelessWidget {
  List<User> users;

  String uid;

  UsersList(this.users, this.uid);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext ctxt, int Index) {
          return MaterialButton(
              elevation: 0.0,
              onPressed: () {
                print(users[Index].uid + " " + uid);

                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            UserProfile(users[Index].uid, uid)));
              },
              child: UserView(users[Index]));
        });
  }
}

class UserView extends StatelessWidget {
  User user;

  UserView(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                user != null && user.imageUrl != null
//                    ? Container(
//                        width: 60.0,
//                        height: 60.0,
//                        decoration: new BoxDecoration(
//                            shape: BoxShape.circle,
//                            image: new DecorationImage(
//                                fit: BoxFit.cover,
//                                image: NetworkImageWithRetry(user.imageUrl))))
//                    :
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: colorPrimary,
                  child: Text(
                    user != null ? user.name.substring(0, 1) : "S",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "GoogleSansBold"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user != null ? user.name : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoogleSansBold",
                            fontSize: 17.0),
                      ),
                      Text(
                        user != null ? user.email : "",
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 69.0, top: 10.0),
              child: HorizontalDivider(
                  lightGrey, 1.0, MediaQuery.of(context).size.width),
            )
          ],
        ));
  }
}
