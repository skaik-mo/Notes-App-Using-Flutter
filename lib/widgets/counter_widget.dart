import 'package:flutter/material.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';

class CounterItem extends StatelessWidget {
  String type;
  String counter;
  double marginStart;
  double marginEnd;

  CounterItem(this.type, this.counter,
      {this.marginStart = 0, this.marginEnd = 0});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsetsDirectional.only(
        start: SizeConfig.scaleWidth(marginStart),
        end: SizeConfig.scaleWidth(marginEnd),
      ),
      height: SizeConfig.scaleWidth(58),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppColors.BLUE_COLOR,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.Very_LIGHT_GREY_COLOR,
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            type,
            style: TextStyle(
              color: AppColors.BLUE_COLOR,
              fontSize: SizeConfig.scaleTextFont(12),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: SizeConfig.scaleWidth(7),
          ),
          Text(
            counter,
            style: TextStyle(
              color: AppColors.LIGHT_GREY_COLOR,
              fontSize: SizeConfig.scaleTextFont(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
