class Address {
  double lat, lng;
  String streetAddress, locality, city, state, country, pincode;

  static Address toObject(document) {
    Address address = new Address();

    address.lat = double.parse(document['lat'].toString());
    address.lng = double.parse(document['lng'].toString());
    address.streetAddress = document['streetAddress'];
    address.locality = document['locality'];
    address.city = document['city'];
    address.pincode = document['pincode'];
    address.state = document['state'];
    address.country = document['country'];

    return address;
  }

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["lat"] = lat;
    map['lng'] = lng;
    map["streetAddress"] = streetAddress;
    map["locality"] = locality;
    map["city"] = city;
    map["state"] = state;
    map["country"] = country;

    map["pincode"] = pincode;

    return map;
  }
}
