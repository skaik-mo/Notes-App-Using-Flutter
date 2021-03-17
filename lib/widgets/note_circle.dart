import 'package:flutter/material.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';

class NoteCircle extends StatelessWidget {
  double radius;
  double topMargin;
  double bottomMargin;
  double startMargin;
  double endMargin;
  bool isShadow;
  bool isIcon;
  String text;
  IconData icon;

  NoteCircle({
    this.radius,
    this.topMargin = 0,
    this.bottomMargin = 0,
    this.startMargin = 0,
    this.endMargin = 0,
    this.isShadow = false,
    this.isIcon = false,
    this.text = '',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(
        top: SizeConfig.scaleHeight(topMargin),
        bottom: SizeConfig.scaleHeight(bottomMargin),
        start: SizeConfig.scaleWidth(startMargin),
        end: SizeConfig.scaleWidth(endMargin),
      ),
      // width: SizeConfig.scaleWidth(2*radius),
      // height: SizeConfig.scaleHeight(2*radius),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(radius),
        boxShadow: [
          BoxShadow(
            color: isShadow == true
                ? AppColors.Very_LIGHT_GREY_COLOR
                : Colors.transparent,
            offset: Offset(0, 6),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.BLUE_COLOR,
        radius: SizeConfig.scaleWidth(radius),
        child: isIcon == false
            ? Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.scaleTextFont(20),
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
              ),
      ),
    );
  }
}
