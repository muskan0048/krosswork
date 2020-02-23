class Comment {
  String uid, userName, userPicUrl;
  String comment;
  DateTime commentDate;

  static Comment mapToPost(doc) {
    Comment comment = new Comment();

    comment.uid = doc['uid'];
    comment.commentDate = doc['commentDate'];
    comment.userName = doc['userName'];
    comment.userPicUrl = doc['userPicUrl'];
    comment.comment = doc['comment'];

    return comment;
  }

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["uid"] = uid;
    map['commentDate'] = commentDate;
    map['comment'] = comment;
    map["userName"] = userName;
    map["userPicUrl"] = userPicUrl;

    return map;
  }
}
