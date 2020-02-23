import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:splash/beans/Chat.dart';
import 'package:splash/beans/Message.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/res/AppColors.dart';

class ChatActivity extends StatefulWidget {
  Chat _chat;

  String _uid;

  ChatActivity(this._chat, this._uid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatActivityState(_chat, _uid);
  }
}

class ChatActivityState extends State<ChatActivity> {
  Chat chat;

  String uid;

  ChatActivityState(this.chat, this.uid);

  User reciever;

  var lastSeendateFormat = new DateFormat('dd MMM yyyy hh:mm a');

  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRecieverProfile();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            chat != null && chat.userPicUrl != null
                ? Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              reciever == null || reciever.imageUrl == null
                                  ? chat.userPicUrl
                                  : reciever.imageUrl,
                            ))))
                : CircleAvatar(
                    radius: 20.0,
                    backgroundColor: colorPrimary,
                    child: Text(
                      reciever == null
                          ? chat != null ? chat.userName.substring(0, 1) : "S"
                          : reciever.name.substring(0, 1),
                      style: TextStyle(
                          color: Colors.white, fontFamily: "GoogleSansBold"),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    reciever == null
                        ? chat != null ? chat.userName : ""
                        : reciever.name,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "GoogleSansBold",
                        fontSize: 17.0),
                  ),
                  reciever != null && reciever.lastSeen != null
                      ? Text(
                          "last seen at " +
                              lastSeendateFormat.format(reciever.lastSeen),
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "GoogleSansRegular",
                              fontSize: 12.0),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 1.0),
                        ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
        leading: MaterialButton(
          elevation: 0.0,
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.transparent,
          child: Icon(
            Icons.arrow_back_ios,
            color: colorPrimary,
          ),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          bottom: true,
          child: new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/chatbkg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 55.0),
                  child: AllMessages(chat, uid),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
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
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(25.0),
                                    ),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: TextField(
                                        maxLines: null,
                                        controller: messageController,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "GoogleSansRegular",
                                            fontSize: 18.0),
                                        decoration:
                                            new InputDecoration.collapsed(
                                                hintText: "Type you message"),
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
                                      )),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (messageController.text.length > 0) {
                                    addChatAndMessage(messageController.text);
                                    messageController.clear();
                                    setState(() {});
                                  } else {
                                    print("Please add some message first");
                                  }
                                },
                                child: Icon(
                                  Icons.send,
                                  size: 30.0,
                                  color: colorPrimary,
                                ),
                              )
                            ],
                          )),
                    )),
              ],
            ),
          )),
    );
  }

  void addMessage(String msgText) async {
    Message message = new Message();
    message.userSent = true;
    message.dateTime = chat.lastTextDateTime;
    message.messageText = msgText;
    message.imageUrl = null;
    message.messageId = message.dateTime.millisecondsSinceEpoch.toString();

    Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("Chats")
        .document(chat.uid)
        .collection("Messages")
        .document(message.messageId)
        .setData(message.getMap())
        .then((result) {
      SystemSound.play(SystemSoundType.click);
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }

  void addChatAndMessage(String msgText) async {
    chat.lastTextDateTime = new DateTime.now();
    chat.lastText = msgText;

    Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("Chats")
        .document(chat.uid)
        .setData(chat.getMap())
        .then((result) {
      addMessage(msgText);
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }

  void getRecieverProfile() {
    Firestore.instance
        .collection("Users")
        .document(chat.uid)
        .get()
        .then((userR) {
      reciever = User.mapToUser(userR.data);

      print("Reciever is " + reciever.toString());

      chat.userPicUrl = reciever.imageUrl;
      chat.userName = reciever.name;

      setState(() {});
    }).catchError((error) {
      print("Error " + error.toString());
    });
  }
}

class AllMessages extends StatefulWidget {
  Chat chat;
  String uid;

  AllMessages(this.chat, this.uid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AllMessagesState(chat, uid);
  }
}

class AllMessagesState extends State<AllMessages> {
  Chat chat;
  String uid;

  var chatListener;

  List<Message> messages = [];

  AllMessagesState(this.chat, this.uid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamMessages();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chatListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return chat != null
        ? ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext ctxt, int Index) {
              return MessageView(
                messages[Index],
              );
            })

//    StreamBuilder<QuerySnapshot>(
//            stream: Firestore.instance
//                .collection("Users")
//                .document(uid)
//                .collection("Chats")
//                .document(chat.uid)
//                .collection("Messages")
//                .orderBy("dateTime", descending: true)
//                .limit(15)
//                .snapshots(),
//            builder:
//                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//              if (snapshot.hasError)
//                return new Text('Error: ${snapshot.error}');
//              else if (snapshot.hasData) {
//                return new
//              } else if (snapshot.connectionState.index ==
//                  ConnectionState.done) {
//                return Center(
//                  child: Text(
//                    "No Messages Found",
//                    style: TextStyle(color: colorPrimary),
//                  ),
//                );
//              } else {
//                return Center(child: CircularProgressIndicator());
//              }
////        switch (snapshot.connectionState) {
////          case ConnectionState.waiting:
//////            return Center(child: CircularProgressIndicator());
////            return Center(child: Text(""));
////          default:
//////            mainCallBack();
////
////        }
//            },
//          )
        : Center(child: CircularProgressIndicator());
  }

  void streamMessages() async {
    chatListener = Firestore.instance
        .collection("Users")
        .document(uid)
        .collection("Chats")
        .document(chat.uid)
        .collection("Messages")
        .orderBy("dateTime", descending: true)
        .limit(15)
        .snapshots()
        .listen((snapshot) {
      if (snapshot == null) {
        return;
      }
      messages.clear();
      snapshot.documents.forEach((doc) {
        messages.add(Message.toObject(doc));
      });
    });
  }
}

class MessageView extends StatelessWidget {
  Message message;

  MessageView(this.message);

  var dateFormat = new DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Bubble(
      message: message.messageText,
      isMe: message.userSent ? false : true,
      time: dateFormat.format(message.dateTime),
      delivered: true,
    );
  }
}

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : lightGreen;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(20.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: !isMe
              ? const EdgeInsets.only(
                  top: 5.0, left: 70.0, bottom: 5.0, right: 5.0)
              : const EdgeInsets.only(
                  top: 5.0, right: 70.0, left: 5.0, bottom: 5.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 65.0),
                child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "GoogleSansRegular",
                      fontSize: 16.0),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
