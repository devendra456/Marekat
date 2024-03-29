import 'package:flutter/material.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

import '../app_config.dart';
import '../my_theme.dart';

class FullScreenImage extends StatefulWidget {
  final List list;
  final int index;

  const FullScreenImage(this.list, this.index, {Key key}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int index;

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                _forwardImage();
              },
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: AppConfig.BASE_PATH + widget.list[index],
                  imageErrorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image.asset(
                      "assets/placeholder.png",
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: langCode.$ == "en" ? 16 : null,
            right: langCode.$ == "en" ? null : 16,
            top: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Color.fromARGB(102, 255, 255, 255),
                child: Icon(
                  Icons.arrow_back,
                  color: MyTheme.accent_color,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _backImage() {
    if (index != 0) {
      index--;
    }
    setState(() {});
  }

  void _forwardImage() {
    if (index != widget.list.length - 1) {
      index++;
    } else if (index == widget.list.length - 1) {
      //index = 0;
      Navigator.pop(context);
    }
    setState(() {});
  }
}
