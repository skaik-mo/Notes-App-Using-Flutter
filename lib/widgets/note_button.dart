import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NoteButton extends StatelessWidget {
  final RoundedLoadingButtonController btnController;

  final String text;
  double height;
  double borderRadius;
  VoidCallback callBack;

  NoteButton(
    this.text, {
    @required this.callBack,
    @required this.btnController,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RoundedLoadingButton(
      height: height,
      width: SizeConfig.screenWidth,
      color: AppColors.BLUE_COLOR,
      animateOnTap: true,
      controller: btnController,
      borderRadius: borderRadius,
      elevation: 7,
      successColor: Colors.green,
      onPressed: callBack,
      child: Text(
        text,
        style: TextStyle(
          fontSize: SizeConfig.scaleTextFont(20),
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
/*
SizedBox(
      width: double.infinity,
      height: SizeConfig.scaleWidth(height),
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: callBack,
        color: AppColors.BLUE_COLOR,
        child: Text(
          text,
          style: TextStyle(
              fontSize: SizeConfig.scaleTextFont(20),
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(borderRadius),
        ),
        elevation: 10,
      ),
    );
 */
