import 'Address.dart';

class WorkSpace {
  String name, contactNo, uid, contactEmail, about;

  Address address;

  String category;

  String vendorName, vendorPhone, vendorEmail;

  List<String> picUrls;

  List<int> openingDays;

  double opening;
  double closing;

  Map<String, String> ambienceSeating, workAmenities, spaceInfo;

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["name"] = name;
    map['contactNo'] = contactNo;
    map["uid"] = uid;
    map["contactEmail"] = contactEmail;
    map["about"] = about;
    map["category"] = category;
    map["address"] = address.getMap();
    map["vendorPhone"] = vendorPhone;
    map["vendorName"] = vendorName;
    map["vendorEmail"] = vendorEmail;
    map["opening"] = opening;
    map["closing"] = closing;
    map['ambienceSeating'] = ambienceSeating;
    map['workAmenities'] = workAmenities;
    map['spaceInfo'] = spaceInfo;
    map['picUrls'] = picUrls;
    map['openingDays'] = openingDays;

    return map;
  }

//  final DocumentReference reference;
//
//  WorkSpace.fromMap(Map<String, dynamic> map, {this.reference})
//      : assert(map['name'] != null),
//        assert(map['votes'] != null),
//        name = map['name'],
//        opening = map['votes'];
//
//  WorkSpace.fromSnapshot(DocumentSnapshot snapshot)
//      : this.fromMap(snapshot.data, reference: snapshot.reference);

  static WorkSpace toObject(Map<String, dynamic> document) {
    WorkSpace workSpace = new WorkSpace();

    workSpace.name = document['name'];
    workSpace.contactNo = document['contactNo'];
    workSpace.contactEmail = document['contactEmail'];

    if (document['address'] != null) {
      workSpace.address =
          Address.toObject(new Map<String, dynamic>.from(document['address']));
    } else {
      workSpace.address = new Address();
    }

    workSpace.about = document['about'];
    workSpace.category = document['category'];
    workSpace.vendorName = document['vendorName'];
    workSpace.vendorEmail = document['vendorEmail'];
    workSpace.vendorPhone = document['vendorPhone'];
    workSpace.opening = double.tryParse(document['opening'].toString());

//    assert(document['picUrls'] is List<String>);
    workSpace.picUrls = List.from(document['picUrls']);
//    workSpace.openingDays = document['name'];
    workSpace.closing = double.tryParse(document['closing'].toString());
    workSpace.uid = document['uid'];

    if (document['ambienceSeating'] != null) {
      Map<dynamic, dynamic> map = document['ambienceSeating'];

      workSpace.ambienceSeating = new Map();
      map.forEach((key, value) {
        workSpace.ambienceSeating[key.toString()] = value.toString();
      });

//      workSpace.ambienceSeating = document['ambienceSeating'];
    }

    if (document['spaceInfo'] != null) {
      Map<dynamic, dynamic> map = document['spaceInfo'];

      workSpace.spaceInfo = new Map();
      map.forEach((key, value) {
        workSpace.spaceInfo[key.toString()] = value.toString();
      });

//      workSpace.ambienceSeating = document['ambienceSeating'];
    }

    if (document['workAmenities'] != null) {
      Map<dynamic, dynamic> map = document['workAmenities'];

      workSpace.workAmenities = new Map();
      map.forEach((key, value) {
        workSpace.workAmenities[key.toString()] = value.toString();
      });

//      workSpace.ambienceSeating = document['ambienceSeating'];
    }

//    workSpace.ambienceSeating = document['ambienceSeating'];
//    workSpace.workAmenities = document['workAmenities'];
//    workSpace.spaceInfo = document['spaceInfo'];

    return workSpace;
  }

  String getTimings() {
    String openingTime, closingTime;

    double open = opening - opening.floor();

    int oMins = (open * 60).floor();

    if (oMins == 0) {
      openingTime = opening.floor().toString() + ":00";
    } else {
      openingTime = opening.floor().toString() + ":" + oMins.toString();
    }

    double close = opening - opening.floor();

    int cMins = (close * 60).floor();

    if (cMins == 0) {
      closingTime = closing.floor().toString() + ":00";
    } else {
      closingTime = closing.floor().toString() + ":" + cMins.toString();
    }

    return "Timimgs: 9:00"  + " - 18:30";
  }

  String getOpenStatus() {
    DateTime dateTime = new DateTime.now();

    if (9 <= dateTime.hour && 18.5 >= dateTime.hour) {
      return "Available ";
    } else {
      return "Not Available ";
    }
  }
}
