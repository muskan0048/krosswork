class Post {
  String pid, userId, userName, userPicUrl;

  String postText, postImageUrl;

  //From Firestore
  String postCategory;

  DateTime postCreateDate;

  Map<String, bool> likesMap;
//  Map<String, dynamic> comments;

  int likes = 0, comments = 0;

  static Post mapToPost(doc) {
    Post post = new Post();

    post.pid = doc['pid'];
    post.userId = doc['userId'];
    post.userName = doc['userName'];
    post.userPicUrl = doc['userPicUrl'];
    post.postText = doc['postText'];
    post.postImageUrl = doc['postImageUrl'];
    post.postCategory = doc['postCategory'];

    if (doc['likesMap'] != null) {
      Map<dynamic, dynamic> map = doc['likesMap'];

      post.likesMap = new Map();
      map.forEach((key, value) {
        post.likesMap[key.toString()] = value;
      });
    }

//    if (doc['comments'] != null) {
//      Map<dynamic, dynamic> map = doc['comments'];
//
//      post.comments = new Map();
//      map.forEach((key, value) {
//        post.comments[key.toString()] = Comment.mapToPost(value);
//      });
//    }

    post.postCreateDate = doc['postCreateDate'];
    post.likes = doc['likes'];
    post.comments = doc['comments'];

    return post;
  }

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["pid"] = pid;
    map['userId'] = userId;
    map["userName"] = userName;
    map["userPicUrl"] = userPicUrl;
    map["postText"] = postText;
    map["postImageUrl"] = postImageUrl;
    map["postCategory"] = postCategory;
    map['likesMap'] = likesMap;
    map["likes"] = likes;
    map["comments"] = comments;
    map["postCreateDate"] = postCreateDate;

    return map;
  }
}
