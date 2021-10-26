import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marekat/generated/l10n.dart';

class DataNotFound extends StatelessWidget {
  const DataNotFound({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/data_not_found.svg",
          width: MediaQuery.of(context).size.width * .5,
        ),
        SizedBox(
          height: 8,
        ),
        Text(S.of(context).noDataIsAvailable)
      ],
    );
  }
}
