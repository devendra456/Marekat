import 'package:flutter/material.dart';

import '../my_theme.dart';

class InputDecorations {
  static InputDecoration buildInputDecoration_1({hintText = ""}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.textfield_grey, width: 1.0),
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        contentPadding: EdgeInsets.only(left: 16.0, right: 16));
  }

  static InputDecoration buildInputDecorationPhone({hintText = ""}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.textfield_grey, width: 1.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0))),
        contentPadding: EdgeInsets.only(left: 16.0, right: 16));
  }
}
