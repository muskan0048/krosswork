import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:splash/activities/ChatActivity.dart';
import 'package:splash/activities/SplashPostDetails.dart';
import 'package:splash/beans/Chat.dart';
import 'package:splash/beans/Like.dart';
import 'package:splash/beans/Post.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

class UserProfile extends StatefulWidget {
  String _uid, myid;

  UserProfile(this._uid, this.myid);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserProfileState(_uid, myid);
  }
}

class UserProfileState extends State<UserProfile> {
  List<Post> _posts = [];

  String uid, myUid;
  User user;
  var dateFormat = new DateFormat("dd MMM yyyy");
  var userListener;
  UserProfileState(this.uid, this.myUid);

  ScrollController _scrollControllerUserProfile = new ScrollController();

  static const kExpandedHeight = 300.0;

  void fetchPosts() async {
    Firestore.instance
        .collection('Posts')
        .where("userId", isEqualTo: uid)
        .orderBy("postCreateDate", descending: true)
        .getDocuments()
        .then((snapshots) {
      snapshots.documents.forEach((doc) {
        print(doc.data);

        _posts.add(Post.mapToPost(doc.data));
      });

      setState(() {});
    }).catchError((error) {
      print("Error is " + error.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser();
    fetchPosts();
  }

  void getUser() async {
    userListener = Firestore.instance
        .collection('Users')
        .document(uid)
        .snapshots()
        .listen((firebaseUser) {
      user = User.mapToUser(firebaseUser.data);

//          email = firebaseUser.data['email'];

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
          child: NestedScrollView(
              controller: _scrollControllerUserProfile,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: kExpandedHeight,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 50.0),
                          ),
                          user != null && user.imageUrl != null
                              ? Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            user.imageUrl,
                                          ))))
                              : CircleAvatar(
                                  radius: 70.0,
                                  backgroundColor: colorPrimary,
                                  child: Text(
                                    user != null
                                        ? user.name.substring(0, 1)
                                        : "S",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35.0,
                                        fontFamily: "GoogleSansBold"),
                                  ),
                                ),
                          user != null
                              ? Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "GoogleSansRegular",
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(1.0),
                                ),
                          user != null && user.creationDate != null
                              ? Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    "Member Since " +
                                        dateFormat.format(user.creationDate),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "GoogleSansRegular",
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(1.0),
                                ),
                          user != null && user.lastSeen != null
                              ? Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    DateTime.now()
                                                .difference(user.lastSeen)
                                                .inDays <
                                            1
                                        ? "Active Today"
                                        : "",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: "GoogleSansRegular",
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(1.0),
                                )
                        ],
                      ),
                    ),
                    title: _showTitle
                        ? Text(
                            user.name,
                            style: TextStyle(
                                color: colorPrimary,
                                fontFamily: "GoogleSansRegular",
                                fontWeight: FontWeight.bold),
                          )
                        : Padding(padding: EdgeInsets.all(1.0)),
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
                    actions: <Widget>[
                      myUid != uid
                          ? RaisedButton(
                              elevation: 0.0,
                              color: Colors.transparent,
                              onPressed: () {
                                if (user == null) {
                                  return;
                                }

                                Chat chat = new Chat();

                                chat.userPicUrl = user.imageUrl;
                                chat.userName = user.name;
                                chat.uid = user.uid;

                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            ChatActivity(chat, myUid)));
                              },
                              child: Row(children: [
                                Text(
                                  "Message",
                                  style: TextStyle(
                                      color: colorPrimary,
                                      fontSize: 16.0,
                                      fontFamily: "GoogleSansBold"),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                ),
                                Icon(
                                  Icons.send,
                                  color: colorPrimary,
                                ),
                              ]))
                          : Padding(
                              padding: EdgeInsets.only(right: 1.0),
                            ),
                    ],
                    centerTitle: false,
                  ),
                ];
              },
              body: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.all(10.0)),
                              user != null
                                  ? Text(
                                      "POSTS FROM " + user.name.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontFamily: "GoogleSansRegular",
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Center(
                                      child: CupertinoActivityIndicator(),
                                    ),
                              Padding(padding: EdgeInsets.all(10.0)),
                              _posts.length > 0
                                  ? AllPosts(_posts, user)
                                  : Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .size
                                                .height),
                                        child: Text(
                                          "No Posts Found",
                                          style: TextStyle(
                                              color: colorPrimary,
                                              fontSize: 18.0,
                                              fontFamily: "GoogleSansRegular"),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  bool get _showTitle {
    try {
      return _scrollControllerUserProfile.hasClients &&
          _scrollControllerUserProfile.offset >
              kExpandedHeight - kToolbarHeight;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollControllerUserProfile.dispose();

    userListener?.cancel();
  }
}

class AllPosts extends StatelessWidget {
  List<Post> posts;

  AllPosts(this.posts, this.user);

  User user;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print(posts[index].pid);
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        SplashPostDetails(posts[index], user)));
          },
          child: PostView(posts[index], user),
        );
      },
      itemCount: posts.length,
    );
  }
}

class PostView extends StatelessWidget {
  Post post;

  User user;

  PostView(this.post, this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
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
            ),
            post.postText != null && post.postText.length > 0
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            post.postText,
                            maxLines: 5,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
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
            HorizontalDivider(
                lightGrey, 1.0, MediaQuery.of(context).size.width),
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
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  SplashPostDetails(post, user)));
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
        ),
      ),
    );
  }

  void updatePost(Post post) async {
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

  void addLike() async {
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

  void removeLike() async {
    Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .collection('Likes')
        .document(user.uid)
        .delete();
  }
}
