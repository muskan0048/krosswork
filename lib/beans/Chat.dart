class Chat {
  String uid, userName, userPicUrl, lastText;
  DateTime lastTextDateTime;

  static Chat toObject(doc) {
    Chat chat = new Chat();

    chat.userName = doc['userName'];
    chat.userPicUrl = doc['userPicUrl'];
    chat.lastText = doc['lastText'];
    chat.uid = doc['uid'];
    chat.lastTextDateTime = doc['lastTextDateTime'];

    return chat;
  }

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["lastTextDateTime"] = lastTextDateTime;
    map['userName'] = userName;
    map["userPicUrl"] = userPicUrl;
    map["uid"] = uid;
    map["lastText"] = lastText;

    return map;
  }
}
