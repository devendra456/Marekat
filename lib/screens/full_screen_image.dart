import 'package:flutter/material.dart';

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
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: index > 0
                ? GestureDetector(
                    onTap: () {
                      _backImage();
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Color.fromARGB(102, 255, 255, 255),
                      child: Icon(
                        Icons.keyboard_arrow_left_rounded,
                        color: MyTheme.accent_color,
                        size: 20,
                      ),
                    ),
                  )
                : Container(),
          ),
          Positioned(
              top: 0,
              right: 16,
              bottom: 0,
              child: index == widget.list.length - 1
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        _forwardImage();
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color.fromARGB(102, 255, 255, 255),
                        child: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: MyTheme.accent_color,
                          size: 20,
                        ),
                      ),
                    )),
          Positioned(
            left: 16,
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
    }
    setState(() {});
  }
}
