class Message {
  String messageText, imageUrl;
  DateTime dateTime;
  bool userSent;
  String messageId;

  static Message toObject(doc) {
    Message message = new Message();

    message.messageText = doc['messageText'];
    message.imageUrl = doc['imageUrl'];
    message.dateTime = doc['dateTime'];
    message.messageId = doc['messageId'];
    message.userSent = doc['userSent'];

    return message;
  }

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["userSent"] = userSent;
    map['messageId'] = messageId;
    map["dateTime"] = dateTime;
    map["imageUrl"] = imageUrl;
    map["messageText"] = messageText;

    return map;
  }
}
