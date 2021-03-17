import 'package:flutter/material.dart';
import 'package:notes_app/controllers/firebase_auth.dart';
import 'package:notes_app/controllers/user_preferences.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/models/user.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/note_circle.dart';
import 'package:notes_app/widgets/settings_item.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FBAuth _fbAuth;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String userName = "";
  String firstChar = "";
  String emailUser = "";

  int _selectedRadioTile;
  bool _enStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  void _initialize() {
    _fbAuth = FBAuth(_scaffoldKey, this.context);
    showUser();
    language();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("settings"),
          style: TextStyle(
            color: AppColors.APP_BAR_COLOR,
            fontSize: SizeConfig.scaleTextFont(22),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: SizeConfig.scaleWidth(22),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoteCircle(
            radius: 35,
            text: firstChar,
            isShadow: true,
            bottomMargin: 8,
          ),
          Text(
            userName,
            style: TextStyle(
              fontSize: SizeConfig.scaleTextFont(15),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            emailUser,
            style: TextStyle(
              fontSize: SizeConfig.scaleTextFont(13),
              fontWeight: FontWeight.w600,
              color: AppColors.LIGHT_GREY_COLOR,
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(10),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Color(0xffD0D0D0),
            indent: SizeConfig.scaleWidth(45),
            endIndent: SizeConfig.scaleWidth(45),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsetsDirectional.only(
                start: SizeConfig.scaleWidth(18),
                end: SizeConfig.scaleWidth(17),
                top: SizeConfig.scaleHeight(25),
              ),
              children: [
                SettingsItem(
                  AppLocalizations.of(context).translate("language"),
                  "${AppLocalizations.of(context).translate("selectedLanguage")} ${_enStatus == true ? "EN" : "AR"}",
                  Icons.language,
                  callback: () {
                    setState(() {
                      showLanguageDialog(context);
                    });
                  },
                ),
                SettingsItem(
                  AppLocalizations.of(context).translate("profile"),
                  AppLocalizations.of(context).translate("updateYourData"),
                  Icons.person,
                  isStartEdge: false,
                  callback: () {
                    goToProfileScreen(context);
                  },
                ),
                SettingsItem(
                  AppLocalizations.of(context).translate("aboutApp"),
                  AppLocalizations.of(context).translate("whatIsNotesApp"),
                  Icons.perm_device_info,
                  callback: () {
                    Navigator.pushNamed(context, "/aboutApp");
                  },
                ),
                SettingsItem(
                  AppLocalizations.of(context).translate("aboutDeveloper"),
                  AppLocalizations.of(context).translate("whoIsTheDeveloper"),
                  Icons.info_outline,
                  isStartEdge: false,
                  callback: () {},
                ),
                SettingsItem(
                  AppLocalizations.of(context).translate("logout"),
                  AppLocalizations.of(context).translate("waitingYourReturn"),
                  Icons.power_settings_new,
                  callback: () {
                    signOut(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(5),
          ),
          Text(
            "Notes App V1.0",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.scaleTextFont(12),
              color: AppColors.LIGHT_GREY_COLOR,
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleHeight(15),
          ),
        ],
      ),
    );
  }

  void goToProfileScreen(BuildContext context) {
    Navigator.pushNamed(context, "/profileScreen").then((value) {
      setState(() {
        showUser();
      });
    });
  }

  void showUser() {
    User _user = UserPreferences.instance.getUser();
    userName = "${_user.firstName} ${_user.lastName}";
    emailUser = "${_user.email}";
    firstChar = "${_user.firstName.substring(0, 1).toUpperCase()}";
  }

  void signOut(BuildContext context) async {
    await UserPreferences.instance.clear();
    _fbAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, "/loginScreen", (route) => false);
  }

  void language() {
    Locale locale = UserPreferences.instance.getLocale();
    if (locale.languageCode == "en") {
      _selectedRadioTile = 1;
      _enStatus = true;
      return;
    }
    _selectedRadioTile = 2;
    _enStatus = false;
  }

  void showLanguageDialog(context) {
    showModalBottomSheet(
        context: context,
        elevation: 3,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              width: double.infinity,
              height: 130,
              color: AppColors.BLUE_COLOR,
              child: Column(
                children: [
                  RadioListTile(
                    value: 1,
                    groupValue: _selectedRadioTile,
                    title: Text(
                      "English",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    ),
                    onChanged: (value) {
                      print("radio tile pressed $value");
                      setState(() {
                        _selectedRadioTile = value;
                        MainApp.setLocale(context, Locale('en', 'US'));
                        _enStatus = value == 1;
                      });
                    },
                    activeColor: Colors.white,
                    selected: _selectedRadioTile == 1,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: _selectedRadioTile,
                    title: Text(
                      "Arabic",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                      ),
                    ),
                    onChanged: (value) {
                      print("radio tile pressed $value");
                      setState(() {
                        _selectedRadioTile = value;
                        MainApp.setLocale(context, Locale('ar', 'SA'));
                        _enStatus = value == 1;
                      });
                    },
                    activeColor: Colors.white,
                    selected: _selectedRadioTile == 2,
                  ),
                ],
              ),
            );
          });
        });
  }
}
