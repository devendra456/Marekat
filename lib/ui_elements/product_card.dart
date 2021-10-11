import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/my_theme.dart';
import 'package:Daemmart/screens/product_details.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String price;

  ProductCard({Key key, this.id, this.image, this.name, this.price}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  var icon_color = MyTheme.dark_grey;

  @override
  Widget build(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
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
          side: new BorderSide(color: Color.fromARGB(255, 232, 232, 232), width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
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
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(8), bottom: Radius.zero),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: AppConfig.BASE_PATH + widget.image,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                          return Image.asset(
                            "assets/placeholder.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ))),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 14, height: 1.6, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Text(
                      widget.price,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: MyTheme.accent_color, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
