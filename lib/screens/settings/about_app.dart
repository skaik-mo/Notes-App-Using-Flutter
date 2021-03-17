import 'package:flutter/material.dart';
import 'package:notes_app/locale/AppLocalizations.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("images/launch.png"),
        fit: BoxFit.fill,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate("aboutApp"),
            style: TextStyle(
              color: AppColors.APP_BAR_COLOR,
              fontSize: SizeConfig.scaleTextFont(22),
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: SizeConfig.scaleWidth(20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.only(
            top: SizeConfig.scaleHeight(197),
            start: SizeConfig.scaleWidth(63),
            end: SizeConfig.scaleWidth(63),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: AppColors.BLUE_COLOR,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.GRAY_COLOR,
                      offset: Offset(0, 3),
                      spreadRadius: 1,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.scaleHeight(30),
                    ),
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
                    SizedBox(
                      height: SizeConfig.scaleHeight(30),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.white,
                // period: Duration(seconds: 3),
                child: Text(
                  'Notes App V1.0',
                  style: TextStyle(
                    fontSize: SizeConfig.scaleTextFont(20),
                    // color: AppColors.GRAY_COLOR,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: SizeConfig.scaleHeight(20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
