import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash/res/AppColors.dart';

String verificationCode, phoneNo, errortext = null;

bool isError = true;

class OtpVerifyActivity extends StatefulWidget {
  String code, phone;

  OtpVerifyActivity(this.code, this.phone);

  @override
  State createState() {
    verificationCode = code;
    phoneNo = phone;
    return OtpState();
  }
}

class OtpState extends State<OtpVerifyActivity> {
  FocusNode _focusNode = FocusNode();

  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: new Text(
            "Verification Pending ",
            style: TextStyle(color: colorPrimary, fontFamily: "GoogleSansBold"),
          ),
          leading: MaterialButton(
            elevation: 0.0,
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.white,
            child: Icon(
              Icons.arrow_back_ios,
              color: colorPrimary,
            ),
          ),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(30.0),
                    ),
                    Text(
                      'A One Time Password (OTP) has been sent to your mobile number',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "GoogleSansRegular",
                        fontSize: 18.0,
                      ),
                      softWrap: true,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      phoneNo,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "GoogleSansBold",
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    TextFormField(
                      controller: otpController,
                      textInputAction: TextInputAction.go,
                      maxLines: 1,
                      focusNode: _focusNode,
                      maxLength: 4,
                      keyboardAppearance: Brightness.dark,
                      decoration: InputDecoration(
                          errorText: errortext != null ? errortext : null,
                          errorStyle: TextStyle(
                              color: isError ? Colors.red : Colors.green,
                              fontSize: 12.0,
                              fontFamily: "GoogleSansRegular"),
                          hintText: "Enter OTP",
                          suffix: GestureDetector(
                            onTap: () {
                              print("Resend OTP");

                              sendSMS().then((result) {
                                errortext = "OTP Resent";
                                isError = false;
                                setState(() {});
                              }).catchError((error) {
                                errortext = "Error in Resending OTP .";
                                isError = true;
                                setState(() {});
                              });
                            },
                            child: Text(
                              "Resend OTP",
                              style: TextStyle(color: colorPrimary),
                            ),
                          )),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontFamily: "GoogleSansRegular",
                          color: Colors.black,
                          fontSize: 18.0),
                      autofocus: true,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                    ),
                    CupertinoButton(
                      color: colorPrimary,
                      pressedOpacity: 0.3,
                      borderRadius: BorderRadius.circular(1.0),
                      onPressed: () {
                        print(otpController.text.toString());
                        if (otpController.text.toString().length == 4) {
                          if (verificationCode ==
                              otpController.text.toString()) {
                            Navigator.pop(context, true);
                          } else {
                            errortext = 'Invalid One Time Password';
                            isError = true;
                            setState(() {});
                          }
                        } else {
                          errortext =
                              'Please enter the One Time Password (OTP) before you proceed.';
                          isError = true;
                          setState(() {});
                        }
                      },
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }

  Future<bool> sendSMS() async {
    var msg = "Welcome to Krosswork. Your Krosswork verification code is " +
        verificationCode.toString() +
        '.Please do not share this OTP with anyone. Thank you, Krosswork';

    msg = msg.replaceAll(" ", "%20");

//    final response = await http.get(
//        'http://api.msg91.com/api/sendhttp.php?sender=SPLASH&route=4&mobiles=' +
//            user.phoneNo +
//            '&authkey=201565A9xoadCI5aa0dd7c&country=91&message=' +
//            msg);
//    print("Response :" + response.body);

    return true;
  }
}
