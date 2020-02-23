class User {
  String name, email, phoneNo, uid, token, imageUrl, password, nameLower;
  int status = 0;

  double redemableCredits = 0;
  int paidVisits = 0;
  int trial = 0;
  String lastPlan;

  double lat, lng;
  DateTime lastSeen;
  DateTime creationDate;

  User();

  @override
  String toString() {
    return 'User{name: $name, email: $email, phoneNo: $phoneNo, uid: $uid, token: $token, imageUrl: $imageUrl, status: $status}';
  }

  static User mapToUser(doc) {
    User user = new User();

    user.name = doc['name'];
    user.email = doc['email'];
    user.phoneNo = doc['phoneNo'];
    user.uid = doc['uid'];
    user.token = doc['token'];
    user.imageUrl = doc['imageUrl'];
    user.status = doc['status'];

    user.redemableCredits = double.tryParse(doc['redemableCredits'].toString());
    user.paidVisits = doc['paidVisits'];
    user.trial = doc['trial'];
    user.lastPlan = doc['lastPlan'];
    user.password = doc['password'];

    user.lat = double.tryParse(doc['lat'].toString());
    user.lng = double.tryParse(doc['lng'].toString());
    user.lastSeen = doc['lastSeen'];
    user.creationDate = doc['creationDate'];
    user.nameLower = doc['nameLower'];

    return user;
  }

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["name"] = name;
    map['status'] = status;
    map["phoneNo"] = phoneNo;
    map["uid"] = uid;
    map["email"] = email;
    map["token"] = token;
    map["imageUrl"] = imageUrl;

    map["redemableCredits"] = redemableCredits;
    map["paidVisits"] = paidVisits;
    map["trial"] = trial;
    map["lastPlan"] = lastPlan;
    map['password'] = password;

    map['lat'] = lat;
    map['lng'] = lng;
    map['lastSeen'] = lastSeen;
    map['creationDate'] = creationDate;
    map['nameLower'] = nameLower;

    return map;
  }

//  static User toObject(Map<String, dynamic> document) {
//    User user = new User();
//
//    user.name = document['name'];
//    user.contactNo = document['contactNo'];
//    user.contactEmail = document['contactEmail'];
//    user.address = Address.toObject(document['address']);
//    user.about = document['about'];
//    user.category = document['category'];
//    user.vendorName = document['vendorName'];
//    user.vendorEmail = document['vendorEmail'];
//    user.vendorPhone = document['vendorPhone'];
//    user.opening = double.tryParse(document['opening'].toString());
//
////    assert(document['picUrls'] is List<String>);
//    user.picUrls = List.from(document['picUrls']);
////    workSpace.openingDays = document['name'];
//    user.closing = double.tryParse(document['closing'].toString());
//    user.uid = document['uid'];
//
//    if (document['ambienceSeating'] != null) {
//      Map<dynamic, dynamic> map = document['ambienceSeating'];
//
//      user.ambienceSeating = new Map();
//      map.forEach((key, value) {
//        user.ambienceSeating[key.toString()] = value.toString();
//      });
//
////      workSpace.ambienceSeating = document['ambienceSeating'];
//    }
//
//    if (document['spaceInfo'] != null) {
//      Map<dynamic, dynamic> map = document['spaceInfo'];
//
//      user.spaceInfo = new Map();
//      map.forEach((key, value) {
//        user.spaceInfo[key.toString()] = value.toString();
//      });
//
////      workSpace.ambienceSeating = document['ambienceSeating'];
//    }
//
//    if (document['workAmenities'] != null) {
//      Map<dynamic, dynamic> map = document['workAmenities'];
//
//      user.workAmenities = new Map();
//      map.forEach((key, value) {
//        user.workAmenities[key.toString()] = value.toString();
//      });
//
////      workSpace.ambienceSeating = document['ambienceSeating'];
//    }
//
////    workSpace.ambienceSeating = document['ambienceSeating'];
////    workSpace.workAmenities = document['workAmenities'];
////    workSpace.spaceInfo = document['spaceInfo'];
//
//    return user;
//  }
}
