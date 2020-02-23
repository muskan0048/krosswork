import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:splash/activities/AddPostActivity.dart';
import 'package:splash/activities/SplashPostDetails.dart';
import 'package:splash/activities/UserProfile.dart';
import 'package:splash/beans/Like.dart';
import 'package:splash/beans/Post.dart';
import 'package:splash/beans/User.dart';
import 'package:splash/helpers/Dividers.dart';
import 'package:splash/res/AppColors.dart';

class SplashBoard extends StatefulWidget {
  SplashBoard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashBoardState();
  }
}

class SplashBoardState extends State<SplashBoard> {
  List<Post> posts = [];

  List<String> categories = [];
  int selectedIndex = 0;

  var listener, userListener;
  User user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    fetchPosts();
    fetchCategories();
  }

  void fetchCategories() async {
    Firestore.instance
        .collection('Post Categories')
        .getDocuments()
        .then((snapshots) {
      categories.clear();
      categories.add("All");
      snapshots.documents.forEach((doc) {
        categories.add(doc.data['name']);
        print(categories.toString());
      });
      callBack();
    });
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
          setState(() {});
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: categories != null && categories.length > 1
              ? Container(
                  height: 50.0,
                  child: CategoriesList(selectedIndex, fetchPosts, categories),
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
          centerTitle: true,
          elevation: 1.0,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => AddPostActivity()));
          },
          backgroundColor: colorPrimary,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 0.0,
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: AllPosts(posts, user));
  }

  void callBack() {
    try {
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listener?.cancel();
    userListener?.cancel();
  }

  void fetchPosts() async {
    print(selectedIndex.toString());

    if (listener != null) {
      listener?.cancel();
      callBack();
    }

    if (selectedIndex == 0) {
      listener = Firestore.instance
          .collection('Posts')
          .orderBy("postCreateDate", descending: true)
          .snapshots()
          .listen((snapshots) {
        posts.clear();

        snapshots.documents.forEach((doc) {
          posts.add(Post.mapToPost(doc));
        });

        callBack();
      });
    } else {
      listener = Firestore.instance
          .collection('Posts')
          .where("postCategory", isEqualTo: categories[selectedIndex])
          .orderBy("postCreateDate", descending: true)
          .snapshots()
          .listen((snapshots) {
        posts.clear();

        snapshots.documents.forEach((doc) {
          posts.add(Post.mapToPost(doc));
        });

        callBack();
      });
    }
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

class AllPosts extends StatelessWidget {
  List<Post> posts;

  User user;

  static User staticUser;

  AllPosts(this.posts, this.user) {
    staticUser = user;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
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
          child: PostView(posts[index]),
        );
      },
      itemCount: posts.length,
    );
  }
}

class PostView extends StatelessWidget {
  Post post;

  PostView(this.post);

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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            UserProfile(post.userId, AllPosts.staticUser.uid)));
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
              ),
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
                          post.likesMap.containsKey(AllPosts.staticUser.uid)) {
                        post.likesMap.remove(AllPosts.staticUser.uid);
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

                        post.likesMap[AllPosts.staticUser.uid] = true;

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
                                  AllPosts.staticUser != null &&
                                  post.likesMap
                                      .containsKey(AllPosts.staticUser.uid)
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
                                      AllPosts.staticUser != null &&
                                      post.likesMap
                                          .containsKey(AllPosts.staticUser.uid)
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
                              builder: (context) => SplashPostDetails(
                                  post, AllPosts.staticUser)));
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

  void addLike() async {
    Like like = new Like();

    like.uid = AllPosts.staticUser.uid;
    like.likeDate = new DateTime.now();
    like.userName = AllPosts.staticUser.name;
    like.userPicUrl = AllPosts.staticUser.imageUrl;

    Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .collection('Likes')
        .document(AllPosts.staticUser.uid)
        .setData(like.getMap());
  }

  void removeLike() async {
    Firestore.instance
        .collection('Posts')
        .document(post.pid)
        .collection('Likes')
        .document(AllPosts.staticUser.uid)
        .delete();
  }
}
