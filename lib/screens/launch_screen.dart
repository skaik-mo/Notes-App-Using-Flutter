import 'package:flutter/material.dart';
import 'package:notes_app/controllers/user_preferences.dart';
import 'package:notes_app/main.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // UserPreferences.instance;
    Locale locale = UserPreferences.instance.getLocale();
    MainApp.setLocale(context, locale);
    // if(locale.languageCode != null) {
    //   print(
    //       "lang ${locale.languageCode} %%%%%%%");
    // }else{
    //   print("%%%%%%  null lang");
    // }
    Future.delayed(Duration(seconds: 3), () {
      if (UserPreferences.instance.isLogged()) {
        Navigator.pushReplacementNamed(context, "/categoriesScreen");
      } else {
        Navigator.pushReplacementNamed(context, "/loginScreen");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              'images/launch.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/iconfinder_note.png'),
                SizedBox(
                  height: SizeConfig.scaleHeight(12),
                ),
                Text(
                  'My Notes',
                  style: TextStyle(
                    color: AppColors.DARK_BLUE_COLOR,
                    fontSize: SizeConfig.scaleTextFont(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.scaleHeight(2),
                ),
                Text(
                  'For Organized Life',
                  style: TextStyle(
                    fontSize: SizeConfig.scaleTextFont(15),
                    color: AppColors.GRAY_COLOR,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: SizeConfig.scaleHeight(20),
            child: Text(
              'Notes App V1.0',
              style: TextStyle(
                fontSize: SizeConfig.scaleTextFont(15),
                color: AppColors.GRAY_COLOR,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
