import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:splash/activities/UserProfile.dart';
import 'package:splash/beans/Comment.dart';
import 'package:splash/beans/Like.dart';
import 'package:splash/beans/Post.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

var dateFormat = new DateFormat('dd MMM yyyy');

class SplashPostDetails extends StatefulWidget {
  Post _post;
  User _user;

  SplashPostDetails(this._post, this._user);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashPostState(_post, _user);
  }
}

class SplashPostState extends State<SplashPostDetails> {
  Post post;
  FocusNode commentFocusNode = new FocusNode();
  User user;

  SplashPostState(this.post, this.user);

  var postListener, commentsListener;
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startListener();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        title: new Text(
          "Feed updates",
          style: TextStyle(
              color: colorPrimary,
              fontFamily: "GoogleSansBold",
              fontSize: 16.0),
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
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  PostView(post, user, commentFocusNode),
                  AllComments(comments)
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
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
                              controller: commentController,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "GoogleSansRegular",
                                  fontSize: 18.0),
                              decoration: new InputDecoration.collapsed(
                                hintText: "Write your Comment",
                              ),
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
                        if (commentController.text.length > 0) {
                          addComment();
                        } else {}
                      },
                      child: Icon(
                        Icons.send,
                        size: 30.0,
                        color: colorPrimary,
                      ),
                    )
                  ],
                ),
              )),
        ],
      )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postListener?.cancel();
    commentsListener?.cancel();
  }

  void startListener() {
    postListener = Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .snapshots()
        .listen((doc) {
      post = Post.mapToPost(doc);
      print('Post in details updated');
      setState(() {});
    });

    commentsListener = Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .collection('Comments')
        .snapshots()
        .listen((snapshot) {
      print("Hello");

      snapshot.documentChanges.forEach((doc) {
        print(doc.document.data['uid'] + " Hello");
        if (!comments.contains(Comment.mapToPost(doc.document))) {
          comments.add(Comment.mapToPost(doc.document));
        }
      });

      setState(() {
        print(comments.length);
      });
    });
  }

  void updatePost(Post post) {
    Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .updateData(post.getMap());
  }

  void addComment() {
    Comment comment = new Comment();

    comment.comment = commentController.text;
    comment.userPicUrl = user.imageUrl;
    comment.userName = user.name;
    comment.commentDate = new DateTime.now();

    comment.uid = comment.commentDate.millisecondsSinceEpoch.toString();

    commentController.clear();

    FocusScope.of(context).requestFocus(focusNode);

    post.comments++;

    updatePost(post);

    Firestore.instance
        .document('Posts/' + post.pid + "/Comments/" + comment.uid)
        .setData(comment.getMap());
  }
}

class AllComments extends StatelessWidget {
  List<Comment> comments;

  AllComments(this.comments);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: CommentView(comments[index]),
          );
        },
        itemCount: comments.length,
        shrinkWrap: true,
        reverse: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

class CommentView extends StatelessWidget {
  Comment comment;

  CommentView(this.comment);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("i am called " + comment.uid);
    return Row(
      children: <Widget>[
        comment != null && comment.userPicUrl != null
            ? Container(
                width: 40.0,
                height: 40.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          comment.userPicUrl,
                        ))))
            : CircleAvatar(
                radius: 20.0,
                backgroundColor: colorPrimary,
                child: Text(
                  comment != null ? comment.userName.substring(0, 1) : "S",
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
                comment != null ? comment.userName : "",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "GoogleSansBold",
                    fontSize: 14.0),
              ),
              Text(
                comment != null ? comment.comment : "",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "GoogleSansRegular",
                    fontSize: 12.0),
              )
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 100.0,
          child: Text(
            comment != null
                ? dateFormat.format(comment.commentDate)

//                      new DateFormat('dd MMMM yyyy , hh:mm a')
//                          .format(post.postCreateDate)
                : "",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: colorPrimary,
                fontFamily: "GoogleSansRegular",
                fontSize: 12.0),
          ),
        )
      ],
    );
  }
}

class PostView extends StatelessWidget {
  Post post;

  User user;

  FocusNode commentFocusNode;

  PostView(this.post, this.user, this.commentFocusNode);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          UserProfile(post.userId, user.uid)));
            },
            child: Row(
              children: <Widget>[
                post != null && post.userPicUrl != null
                    ? Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  post.userPicUrl,
                                ))))
                    : CircleAvatar(
                        radius: 20.0,
                        backgroundColor: colorPrimary,
                        child: Text(
                          post != null ? post.userName.substring(0, 1) : "S",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "GoogleSansBold"),
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
                        post != null ? post.userName : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoogleSansBold",
                            fontSize: 14.0),
                      ),
                      Text(
                        post != null
                            ? new DateFormat('dd MMMM yyyy At hh:mm a')
                                .format(post.postCreateDate)
                            : "",
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: 100.0,
                  child: Text(
                    post != null
                        ? post.postCategory

//                      new DateFormat('dd MMMM yyyy , hh:mm a')
//                          .format(post.postCreateDate)
                        : "",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: colorPrimary,
                        fontFamily: "GoogleSansRegular",
                        fontSize: 12.0),
                  ),
                )
              ],
            )),
        post.postText != null && post.postText.length > 0
            ? Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        post.postText,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "GoogleSansRegular",
                            fontSize: 14.0),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(1.0),
              ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: post.postImageUrl == null ? 0.0 : 200.0,
            color: lightGrey,
            child: post.postImageUrl != null
                ? new ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: post.postImageUrl,

                      fit: BoxFit.cover,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(1.0),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            getLikeCommentCount(),
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
        ),
        HorizontalDivider(lightGrey, 1.0, MediaQuery.of(context).size.width),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print("I am Called");
                  if (post.likesMap != null &&
                      post.likesMap.containsKey(user.uid)) {
                    post.likesMap.remove(user.uid);
                    post.likes--;
                    removeLike();
                  } else {
                    if (post.likesMap == null) {
                      post.likesMap = new Map();
                    }

//                        Map<String, dynamic> map = new Map();
//                        map["uid"] = user.uid;
//                        map['likeDate'] = new DateTime.now();
//                        map["userName"] = user.name;
//                        map["userPicUrl"] = user.imageUrl;

                    post.likesMap[user.uid] = true;

                    post.likes++;
                    addLike();
                  }

                  updatePost(post);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.thumb_up,
                      color: post.likesMap != null &&
                              user != null &&
                              post.likesMap.containsKey(user.uid)
                          ? colorPrimary
                          : Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    ),
                    Text(
                      "Like",
                      style: TextStyle(
                          color: post.likesMap != null &&
                                  user != null &&
                                  post.likesMap.containsKey(user.uid)
                              ? colorPrimary
                              : Colors.black),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(commentFocusNode);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.comment,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    ),
                    Text("Comment")
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Share.share(post.postText +
                      "\nPost by " +
                      post.userName +
                      "\n\nSee More Posts at Krosswork Download the app now.");
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.share,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    ),
                    Text("Share")
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void updatePost(Post post) {
    Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .updateData(post.getMap());
  }

  String getLikeCommentCount() {
    String likeText = "0 Like", commentText = "0 Comment";

//    if (post.likes != null && post.likes.length > 0) {
//      likes = post.likes.length;
//    }
//    if (post.comments != null && post.comments.length > 0) {
//      comments = post.comments.length;
//    }

//    print(likes.toString() + " " + comments.toString());

    if (post.likes > 1) {
      likeText = post.likes.toString() + " Likes";
      print(likeText);
    } else if (post.likes == 1) {
      likeText = "1 Like";
    }

    if (post.comments > 1) {
      commentText = post.comments.toString() + " Comments";
    } else if (post.comments == 1) {
      commentText = "1 Comment";
    }

    return likeText + " " + commentText;
  }

  void addLike() {
    Like like = new Like();

    like.uid = user.uid;
    like.likeDate = new DateTime.now();
    like.userName = user.name;
    like.userPicUrl = user.imageUrl;

    Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .collection('Likes')
        .document(user.uid)
        .setData(like.getMap());
  }

  void removeLike() {
    Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .collection('Likes')
        .document(user.uid)
        .delete();
  }
}
