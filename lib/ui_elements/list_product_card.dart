import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:Daemmart/my_theme.dart';
import 'package:Daemmart/screens/product_details.dart';
import 'package:flutter/material.dart';

class ListProductCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String price;

  ListProductCard({Key key, this.id, this.image, this.name, this.price})
      : super(key: key);

  @override
  _ListProductCardState createState() => _ListProductCardState();
}

class _ListProductCardState extends State<ListProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: widget.id,
          );
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2.0,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            width: 75,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                  left: langCode.$ == "en" ? Radius.circular(16) : Radius.zero,
                  right:
                      langCode.$ == "ar" ? Radius.circular(16) : Radius.zero),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: AppConfig.BASE_PATH + widget.image,
                fit: BoxFit.cover,
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Image.asset(
                    "assets/placeholder.png",
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                    child: Text(
                      widget.price,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
