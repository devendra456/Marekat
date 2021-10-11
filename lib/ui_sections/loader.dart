import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marekat/my_theme.dart';

class Loader {
  static BuildContext dialogContext;

  static showLoaderDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return WillPopScope(
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.white.withOpacity(0),
            child: Center(
              child: CircularProgressIndicator(
                color: MyTheme.accent_color,
              ),
            ),
          ),
          onWillPop: () async {
            return false;
          },
        );
      },
    );
  }

  static dismissDialog(context) {
    Navigator.pop(dialogContext);
  }
}
