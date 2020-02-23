import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAlertDialog {
  static void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );
  }

  static void showError(String error, BuildContext context,
      {@optionalTypeArgs String title}) {
    showDemoDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text(title == null ? "Error" : title,
              softWrap: true,
              style: TextStyle(fontSize: 14.0, fontFamily: "GoogleSansBold")),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Okay'),
            )
          ],
          content: Text(error.toString(),
              softWrap: true,
              style:
                  TextStyle(fontSize: 14.0, fontFamily: "GoogleSansRegular")),
        ));
  }
}
