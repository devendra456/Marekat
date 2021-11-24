import 'dart:convert';
import 'dart:io' as Io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/input_decorations.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/profile_repositories.dart';
import 'package:marekat/ui_sections/loader.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  ScrollController _mainScrollController = ScrollController();

  TextEditingController _nameController =
      TextEditingController(text: "${user_name.$}");
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  //for image uploading
  //File _file;

  chooseAndUploadImage(context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text(S.of(context).photoPermission),
                content: Text(
                    S.of(context).thisAppNeedsPhotoToTakePicturesForUploadUser),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(S.of(context).deny),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text(S.of(context).settings),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          S.of(context).goToYourApplicationSettingsAndGivePhotoPermission);
    } else if (status.isGranted) {
      //_file = await ImagePicker.pickImage(source: ImageSource.camera);
      //_file = await ImagePicker.pickImage(source: ImageSource.gallery);

      var result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result == null) {
        ToastComponent.showDialog(
          S.of(context).noFileIsChosen,
        );
        return;
      }

      Loader.showLoaderDialog(context);

      PlatformFile file = result.files.first;

      //return;
      String base64Image =
          base64Encode(await Io.File(file.path.toString()).readAsBytesSync());
      String fileName = file.name;

      var profileImageUpdateResponse;

      try {
        profileImageUpdateResponse =
            await ProfileRepository().getProfileImageUpdateResponse(
          base64Image,
          fileName,
        );
        Loader.dismissDialog(context);
      } catch (e) {
        Loader.dismissDialog(context);
      }

      if (profileImageUpdateResponse.result == false) {
        ToastComponent.showDialog(
          profileImageUpdateResponse.message,
        );
        return;
      } else {
        ToastComponent.showDialog(
          profileImageUpdateResponse.message,
        );

        avatar_original.$ = profileImageUpdateResponse.path;
        setState(() {});
      }
    }
  }

  Future<void> _onPageRefresh() async {}

  onPressUpdate() async {
    var name = _nameController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    var change_password = password != "" ||
        password_confirm !=
            ""; // if both fields are empty we will not change user's password

    if (name == "") {
      ToastComponent.showDialog(
        S.of(context).enterYourName,
      );
      return;
    }
    if (change_password && password == "") {
      ToastComponent.showDialog(
        S.of(context).enterPassword,
      );
      return;
    }
    if (change_password && password_confirm == "") {
      ToastComponent.showDialog(
        S.of(context).confirmYourPassword,
      );
      return;
    }
    if (change_password && password.length < 6) {
      ToastComponent.showDialog(
        S.of(context).passwordMustContainAtLeast6Characters,
      );
      return;
    }
    if (change_password && password != password_confirm) {
      ToastComponent.showDialog(
        S.of(context).passwordsDoNotMatch,
      );
      return;
    }

    var profileUpdateResponse;
    Loader.showLoaderDialog(context);
    try {
      profileUpdateResponse =
          await ProfileRepository().getProfileUpdateResponse(
        name,
        change_password ? password : "",
      );
      Loader.dismissDialog(context);
    } catch (e) {
      Loader.dismissDialog(context);
    }

    if (profileUpdateResponse.result == false) {
      ToastComponent.showDialog(
        profileUpdateResponse.message,
      );
    } else {
      ToastComponent.showDialog(
        profileUpdateResponse.message,
      );

      user_name.$ = name;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(context),
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
        S.of(context).profile,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildBody(context) {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            S.of(context).pleaseLogInToSeeTheProfile,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        displacement: 10,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                buildTopSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                  ),
                ),
                buildProfileForm(context)
              ]),
            )
          ],
        ),
      );
    }
  }

  buildTopSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      color: Color.fromRGBO(112, 112, 112, .3), width: 2),
                  //shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: AppConfig.BASE_PATH + "${avatar_original.$}",
                      fit: BoxFit.cover,
                      imageErrorBuilder: (BuildContext context,
                          Object exception, StackTrace stackTrace) {
                        return Image.asset(
                          "assets/placeholder.png",
                          fit: BoxFit.cover,
                        );
                      },
                    )),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: MaterialButton(
                    padding: EdgeInsets.all(0),
                    child: Icon(
                      Icons.edit,
                      color: MyTheme.font_grey,
                      size: 14,
                    ),
                    shape: CircleBorder(
                      side:
                          new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    ),
                    color: MyTheme.light_grey,
                    onPressed: () {
                      chooseAndUploadImage(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  buildProfileForm(context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                S.of(context).basicInformation,
                style: TextStyle(
                    color: MyTheme.grey_153,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                S.of(context).name,
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 36,
                child: TextField(
                  controller: _nameController,
                  autofocus: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hintText: S.of(context).johnDoe),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                S.of(context).password,
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 36,
                    child: TextField(
                      controller: _passwordController,
                      autofocus: false,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecorations.buildInputDecoration_1(
                          hintText: "• • • • • • • •"),
                    ),
                  ),
                  Text(
                    S.of(context).passwordMustBeAtLeast6Character,
                    style: TextStyle(
                        color: MyTheme.textfield_grey,
                        fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                S.of(context).retypePassword,
                style: TextStyle(
                    color: MyTheme.accent_color, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: 36,
                child: TextField(
                  controller: _passwordConfirmController,
                  autofocus: false,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecorations.buildInputDecoration_1(
                      hintText: "• • • • • • • •"),
                ),
              ),
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    width: 120,
                    height: 36,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9.0))),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      //height: 50,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0))),
                      child: Text(
                        S.of(context).updateProfile,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressUpdate();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
