import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splash/beans/Post.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/LoadingDialog.dart';
import 'package:splash/res/AppColors.dart';

class AddPostActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddPostState();
  }
}

class AddPostState extends State<AddPostActivity> {
  User user;

  List<String> categories = [];
  int selectedIndex = 0;

  TextEditingController postText = new TextEditingController();
  Post post = new Post();

  var userListener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser();

    fetchCategories();
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    userListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        title: new Text(
          "Post to Our Board",
          style: TextStyle(color: colorPrimary, fontFamily: "GoogleSansBold"),
        ),
        leading: MaterialButton(
          elevation: 0.0,
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
          child: Icon(
            Icons.close,
            color: colorPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              addPostToDb();
            },
            child: Center(
                child: Icon(
              Icons.send,
              color: colorPrimary,
            )),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                UserDetails(user),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Text(
                  "CHOOSE CATEGORY",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontFamily: "GoogleSansBold"),
                  textAlign: TextAlign.start,
                ),
                categories != null
                    ? Container(
                        height: 50.0,
                        child:
                            CategoriesList(selectedIndex, callBack, categories),
                      )
                    : Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CupertinoActivityIndicator(),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                            Text(
                              "Fetching Categories",
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: colorPrimary),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Text(
                  "START TYPING HERE",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontFamily: "GoogleSansBold"),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                Card(
                  color: Colors.white,
                  elevation: 0.0,
                  child: TextField(
                    controller: postText,
                    maxLines: null,
                    decoration:
                        InputDecoration(hintText: "What's on your mind?"),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Text(
                  "ADD PHOTO",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontFamily: "GoogleSansBold"),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    width: _image == null
                        ? 100.0
                        : MediaQuery.of(context).size.width,
                    height: _image == null ? 100.0 : 300.0,
                    color: lightGrey,
                    child: _image == null
                        ? Icon(
                            CupertinoIcons.photo_camera,
                            color: colorPrimary,
                            size: 50.0,
                          )
                        : new ClipRRect(
                            borderRadius: new BorderRadius.circular(4.0),
                            child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  void callBack() {
    setState(() {});
  }

  void getUser() async {
    FirebaseAuth.instance.currentUser().then((v) {
      if (v != null) {
        userListener = Firestore.instance
            .collection('Users')
            .document(v.uid)
            .snapshots()
            .listen((firebaseUser) {
          user = User.mapToUser(firebaseUser.data);

//          email = firebaseUser.data['email'];

          setState(() {});
        });
      } else {}
    });
  }

  void fetchCategories() async {
    Firestore.instance
        .collection('Post Categories')
        .snapshots()
        .listen((snapshots) {
      categories.clear();
      snapshots.documents.forEach((doc) {
        categories.add(doc.data['name']);
        print(categories.toString());
      });
    });
  }

  void addPostToDb() async {
    if (postText.text.length > 0) {
      LoadingDialog.showLoadingDialog(context);

      post.postCreateDate = new DateTime.now();
      post.pid = post.postCreateDate.millisecondsSinceEpoch.toString();

      if (_image != null) {
        uploadImage();
      } else {
        saveInDB();
      }
    } else {
      showError("Please add message or a Picture");
    }
  }

  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );
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

  void uploadImage() async {
//    final Directory systemTempDir = Directory.systemTemp;
//    final File file = await File('${systemTempDir.path}/foo$uuid.txt').create();
//    await file.writeAsString(kTestString);
//    assert(await file.readAsString() == kTestString);
//    final StorageReference ref =
//    widget.storage.ref().child('text').child('foo$uuid.txt');

    StorageReference ref =
        FirebaseStorage.instance.ref().child("PostImages/" + post.pid);
    final StorageUploadTask uploadTask = ref.putFile(
      _image,
      StorageMetadata(contentType: "image/jpeg"),
    );

    uploadTask.events.listen((events) {
      if (uploadTask.isComplete) {
        print("Upload Complete");
        ref.getDownloadURL().then((url) {
          post.postImageUrl = url.toString();
          print(post.postImageUrl);
          saveInDB();
        });
      }
    });
  }

  void saveInDB() async {
    post.postText = postText.text;
    post.postCategory = categories[selectedIndex];
    post.userName = user.name;
    post.userId = user.uid;

    post.userPicUrl = user.imageUrl;

    Firestore.instance
        .collection("Posts")
        .document(post.pid)
        .setData(post.getMap())
        .then((result) {
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((error) {
      Navigator.pop(context);
      showError(error.toString());
    });
  }
}

class CategoriesList extends StatelessWidget {
  int selectedIndex;

  Function callBack;

  List<String> categories = [];

  CategoriesList(this.selectedIndex, this.callBack, this.categories);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        Color color = Colors.white, textColor = colorPrimary;

        selectedIndex == index ? color = colorPrimary : Colors.white;

        selectedIndex == index ? textColor = Colors.white : colorPrimary;
        return GestureDetector(
          onTap: () {
            selectedIndex = index;
            callBack();
          },
          child: Container(
            margin: EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: color,
                border: new Border.all(color: colorPrimary)),
            child: Center(
                child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: Text(
                categories[index],
                style: TextStyle(
                    fontFamily: "GoogleSansRegular",
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: textColor),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            )),
          ),
        );
      },
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
    );
  }
}

class UserDetails extends StatelessWidget {
  User user;

  UserDetails(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        user != null && user.imageUrl != null
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
            : CircleAvatar(
                radius: 35.0,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user != null ? user.name : "",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "GoogleSansBold",
                    fontSize: 20.0),
              ),
              Text(
                user != null ? user.email : "",
                style: TextStyle(
                    color: colorPrimary,
                    fontFamily: "GoogleSansRegular",
                    fontSize: 16.0),
              )
            ],
          ),
        )
      ],
    );
  }
}
