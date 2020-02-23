import 'WorkSpace.dart';

class Reservation {
  String txnId, userId, userName, userPhone, userEmail;
  WorkSpace workSpace;
  DateTime bookingDate, currentDate;

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["txnId"] = txnId;
    map['userId'] = userId;
    map["userName"] = userName;
    map["userPhone"] = userPhone;
    map["userEmail"] = userEmail;
    map["workSpace"] = workSpace.getMap();
    map["bookingDate"] = bookingDate;
    map["currentDate"] = currentDate;

    return map;
  }

  static Reservation toObject(Map<String, dynamic> document) {
    Reservation reservation = new Reservation();

    reservation.txnId = document['txnId'];
    reservation.userId = document['userId'];
    reservation.userName = document['userName'];
    reservation.userPhone = document['userPhone'];
    reservation.userEmail = document['userEmail'];
    reservation.workSpace = WorkSpace.toObject(
        new Map<String, dynamic>.from(document['workSpace']));
    reservation.bookingDate = document['bookingDate'];
    reservation.currentDate = document['currentDate'];

//    workSpace.ambienceSeating = document['ambienceSeating'];
//    workSpace.workAmenities = document['workAmenities'];
//    workSpace.spaceInfo = document['spaceInfo'];

    return reservation;
  }
}
