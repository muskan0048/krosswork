class Plan {
  String uid;
  int numberOfVisits, validity;

  double freeCredits, price;

  Map<String, Object> getMap() {
    Map<String, Object> map = new Map();

    map["uid"] = uid;
    map['numberOfVisits'] = numberOfVisits;
    //map["validity"] = validity;
    map["freeCredits"] = freeCredits;
    map["price"] = price;

    return map;
  }

  static Plan toObject(Map<String, dynamic> document) {
    Plan plan = new Plan();

    plan.uid = document['uid'];
    //plan.validity = document['validity'];
    plan.freeCredits = double.tryParse(document['freeCredits'].toString());
    plan.numberOfVisits = document['numberOfVisits'];
    plan.price = double.tryParse(document['price'].toString());

    return plan;
  }
}
