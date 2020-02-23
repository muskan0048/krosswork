class Like extends Object {
  String uid, userName, userPicUrl;

  DateTime likeDate;

  static Like mapToPost(doc) {
    Like like = new Like();

    like.uid = doc['uid'];
    like.likeDate = doc['likeDate'];
    like.userName = doc['userName'];
    like.userPicUrl = doc['userPicUrl'];

    return like;
  }

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["uid"] = uid;
    map['likeDate'] = likeDate;
    map["userName"] = userName;
    map["userPicUrl"] = userPicUrl;

    return map;
  }
}
