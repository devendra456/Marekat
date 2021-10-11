import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/custom/toast_component.dart';
import 'package:Daemmart/generated/l10n.dart';
import 'package:Daemmart/my_theme.dart';
import 'package:Daemmart/repositories/flash_deal_repository.dart';
import 'package:Daemmart/screens/flash_deal_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:shimmer/shimmer.dart';

class FlashDealList extends StatefulWidget {
  @override
  _FlashDealListState createState() => _FlashDealListState();
}

class _FlashDealListState extends State<FlashDealList> {
  List<CountdownTimerController> _timerControllerList = [];

  DateTime convertTimeStampToDateTime(int timeStamp) {
    var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    return dateToTimeStamp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildFlashDealList(context),
    );
  }

  buildFlashDealList(context) {
    return FutureBuilder(
        future: FlashDealRepository().getFlashDeals(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var flashDealResponse = snapshot.data;
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: flashDealResponse.flash_deals.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: buildFlashDealListItem(flashDealResponse, index),
                  );
                },
              ),
            );
          } else {
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Shimmer.fromColors(
                          baseColor: MyTheme.shimmer_base,
                          highlightColor: MyTheme.shimmer_highlighted,
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Shimmer.fromColors(
                            baseColor: MyTheme.shimmer_base,
                            highlightColor: MyTheme.shimmer_highlighted,
                            child: Container(
                              height: 30,
                              width: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Shimmer.fromColors(
                            baseColor: MyTheme.shimmer_base,
                            highlightColor: MyTheme.shimmer_highlighted,
                            child: Container(
                              height: 30,
                              width: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  String timeText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString()) ? blank_zeros : txt;

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }

    return newtxt;
  }

  buildFlashDealListItem(flashDealResponse, index) {
    DateTime end = convertTimeStampToDateTime(flashDealResponse.flash_deals[index].date); // YYYY-mm-dd
    DateTime now = DateTime.now();
    int diff = end.difference(now).inMilliseconds;
    int endTime = diff + now.millisecondsSinceEpoch;

    void onEnd() {}

    CountdownTimerController time_controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    _timerControllerList.add(time_controller);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CountdownTimer(
        controller: _timerControllerList[index],
        widgetBuilder: (_, CurrentRemainingTime time) {
          return GestureDetector(
            onTap: () {
              if (time == null) {
                ToastComponent.showDialog(
                  S.of(context).flashDealIsEnded,
                );
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FlashDealProducts(
                    flash_deal_id: flashDealResponse.flash_deals[index].id,
                    flash_deal_name: flashDealResponse.flash_deals[index].title,
                  );
                }));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 2.0,
                  child: Container(
                      width: double.infinity,
                      height: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: AppConfig.BASE_PATH + flashDealResponse.flash_deals[index].banner,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                              return Image.asset(
                                "assets/placeholder.png",
                                fit: BoxFit.cover,
                              );
                            },
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    flashDealResponse.flash_deals[index].title,
                    maxLines: 1,
                    style: TextStyle(color: MyTheme.dark_grey, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  width: 150,
                  child: Center(
                      child: time == null
                          ? Text(
                              S.of(context).ended,
                              style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
                            )
                          : buildTimerRowRow(time)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Row buildTimerRowRow(CurrentRemainingTime time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          timeText(time.days.toString(), default_length: 3),
          style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Text(
            ":",
            style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          timeText(time.hours.toString(), default_length: 2),
          style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Text(
            ":",
            style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          timeText(time.min.toString(), default_length: 2),
          style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Text(
            ":",
            style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          timeText(time.sec.toString(), default_length: 2),
          style: TextStyle(color: MyTheme.accent_color, fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        S.of(context).flashDeals,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
