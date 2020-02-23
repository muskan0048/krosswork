import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: CupertinoActivityIndicator(
        animating: true,
        radius: 15.0,
      ),
    );

    CupertinoAlertDialog(
      title: Container(
          width: 20.0,
          height: 20.0,
          child: Center(
            child: CupertinoActivityIndicator(),
          )),
      content: Text('Please Wait'),
    );
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog();
        });
  }
}
