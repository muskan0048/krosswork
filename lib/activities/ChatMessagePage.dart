import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:splash/activities/ChatActivity.dart';
import 'package:splash/activities/SearchUserProfile.dart';
import 'package:splash/beans/Chat.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatMessageState();
  }
}

class ChatMessageState extends State<ChatMessage> {
  String uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => SearchUserActivity(uid)));
          },
          child: Icon(
            Icons.supervised_user_circle,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          elevation: 1.0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Text(
            "Conversations",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: "GoogleSansBold"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.all(15.0),
//                child: Text(
//                  "Proffessions",
//                  style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 18.0,
//                      fontFamily: "GoogleSansBold"),
//                ),
//              ),
//              Container(
//                height: 70.0,
//              ),
//              Padding(
//                padding: EdgeInsets.all(10.0),
//              ),
//              HorizontalDivider(
//                  lightGrey, 1.0, MediaQuery.of(context).size.width),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              AllChatsState(uid),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
            ],
          ),
        ));
  }

  void getUser() async {
    FirebaseAuth.instance.currentUser().then((v) {
      if (v != null) {
        uid = v.uid;

        print("UID is " + uid);

        setState(() {});
      } else {
        uid = null;
      }
    });
  }
}

class AllChatsState extends StatelessWidget {
  String uid;

  AllChatsState(this.uid);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return uid != null
        ? StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("Users")
                .document(uid)
                .collection("Chats")
                .orderBy("lastTextDateTime", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else if (snapshot.hasData) {
                return new ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return MaterialButton(
                          elevation: 0.0,
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ChatActivity(
                                        Chat.toObject(snapshot
                                            .data.documents[Index].data),
                                        uid)));
                          },
                          child: ChatView(Chat.toObject(
                            snapshot.data.documents[Index].data,
                          )));
                    });
              } else if (snapshot.connectionState.index ==
                  ConnectionState.done) {
                return Center(
                  child: Text(
                    "No Chats Found",
                    style: TextStyle(color: colorPrimary),
                  ),
                );
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
          )
        : Center(child: CircularProgressIndicator());
  }
}

class ChatView extends StatelessWidget {
  Chat chat;

  var dateFormatElse = new DateFormat("dd/MM/yyyy");
  var dateFormatToday = new DateFormat("hh:mm a");
  DateTime todayDate = DateTime.now();

  ChatView(this.chat);

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
                chat != null && chat.userPicUrl != null
                    ? Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  chat.userPicUrl,
                                ))))
                    : CircleAvatar(
                        radius: 30.0,
                        backgroundColor: colorPrimary,
                        child: Text(
                          chat != null ? chat.userName.substring(0, 1) : "S",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "GoogleSansBold"),
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
                        chat != null ? chat.userName : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoogleSansBold",
                            fontSize: 17.0),
                      ),
                      Text(
                        chat != null ? chat.lastText : "",
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
                Text(
                  chat != null
                      ? todayDate.difference(chat.lastTextDateTime).inDays > 1
                          ? dateFormatElse.format(chat.lastTextDateTime)
                          : dateFormatToday.format(chat.lastTextDateTime)
                      : "",
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "GoogleSansRegular",
                      fontSize: 14.0),
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
