import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/screens/brand_products.dart';

class BrandSquareCard extends StatefulWidget {
  int id;
  String image;
  String name;

  BrandSquareCard({Key key, this.id, this.image, this.name}) : super(key: key);

  @override
  _BrandSquareCardState createState() => _BrandSquareCardState();
}

class _BrandSquareCardState extends State<BrandSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return BrandProducts(
                id: widget.id,
                brand_name: widget.name,
              );
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 2.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16), bottom: Radius.zero),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: AppConfig.BASE_PATH + widget.image,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (
                      BuildContext context,
                      Object exception,
                      StackTrace stackTrace,
                    ) {
                      return Image.asset(
                        "assets/placeholder.png",
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 38,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text(
                  widget.name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: MyTheme.font_grey,
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
