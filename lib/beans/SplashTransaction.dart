import 'package:splash/beans/Plan.dart';

class SplashTransaction {
  String txnId,
      userId,
      userName,
      userPhone,
      userEmail,
      amountString,
      pInfo,
      paymentId;

  DateTime transactionTime;

  double amount;

  // if user use his credits
  double creditsRedemmed;

  int txnType;

  //0 for Plan Subscribe
  //1 for Add Credits

  Plan plan;

  int paymentStatus;

  //0 for payment started
  //1 for Failure
  //2 for Pending
  //3 for Success

  Map<String, dynamic> getMap() {
    Map<String, Object> map = new Map();

    map["txnId"] = txnId;
    map['userId'] = userId;
    map["userName"] = userName;
    map["userPhone"] = userPhone;
    map["userEmail"] = userEmail;
    map["amountString"] = amountString;
    map["pInfo"] = pInfo;
    map["transactionTime"] = transactionTime;
    map["amount"] = amount;
    map["creditsRedemmed"] = creditsRedemmed;
    map['txnType'] = txnType;

    if (plan != null) map['plan'] = plan.getMap();
    map['paymentStatus'] = paymentStatus;
    map['paymentId'] = paymentId;

    return map;
  }

  static SplashTransaction mapToTransaction(doc) {
    SplashTransaction splashTransaction = new SplashTransaction();

    splashTransaction.txnId = doc['txnId'];
    splashTransaction.userId = doc['userId'];
    splashTransaction.userName = doc['userName'];
    splashTransaction.userPhone = doc['userPhone'];
    splashTransaction.userEmail = doc['userEmail'];
    splashTransaction.amountString = doc['amountString'];
    splashTransaction.pInfo = doc['pInfo'];

    splashTransaction.amount = double.tryParse(doc['amount'].toString());
    splashTransaction.transactionTime = doc['transactionTime'];
    splashTransaction.txnType = doc['txnType'];
    splashTransaction.creditsRedemmed =
        double.tryParse(doc['creditsRedemmed'].toString());
    splashTransaction.paymentId = doc['paymentId'];
    splashTransaction.paymentStatus = doc['paymentStatus'];

    if (doc['plan'] != null) {
      splashTransaction.plan =
          Plan.toObject(new Map<String, dynamic>.from(doc['plan']));
    }

    return splashTransaction;
  }

  @override
  String toString() {
    return 'SplashTransaction{txnId: $txnId, userId: $userId, userName: $userName, userPhone: $userPhone, userEmail: $userEmail, amountString: $amountString, pInfo: $pInfo, paymentId: $paymentId, transactionTime: $transactionTime, amount: $amount, creditsRedemmed: $creditsRedemmed, txnType: $txnType, plan: $plan, paymentStatus: $paymentStatus}';
  }
}
