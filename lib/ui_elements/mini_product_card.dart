import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/screens/product_details.dart';

class MiniProductCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String price;

  MiniProductCard({Key key, this.id, this.image, this.name, this.price})
      : super(key: key);

  @override
  _MiniProductCardState createState() => _MiniProductCardState();
}

class _MiniProductCardState extends State<MiniProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id);
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(0.0),
        ),
        elevation: 1.5,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0), bottom: Radius.zero),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: AppConfig.BASE_PATH + widget.image,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (BuildContext context,
                              Object exception, StackTrace stackTrace) {
                            return Image.asset(
                              "assets/placeholder.png",
                              fit: BoxFit.cover,
                            );
                          },
                        ))),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Text(
                  widget.name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 11,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
      ),
    );
  }
}
