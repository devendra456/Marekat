import 'package:flutter/material.dart';

class CompareBottomSheet {
  static showCompareBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return Container(
            height: 200,
            child: Row(
              children: [],
            ),
          );
        });
  }
}
