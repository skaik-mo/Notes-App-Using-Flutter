import 'package:flutter/material.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:notes_app/widgets/note_circle.dart';

class SettingsItem extends StatelessWidget {
  String title;
  String subTitle;
  IconData icon;
  bool isStartEdge;
  GestureTapCallback callback;

  SettingsItem(
    this.title,
    this.subTitle,
    this.icon, {
    @required this.callback,
    this.isStartEdge = true,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsetsDirectional.only(
          bottom: SizeConfig.scaleHeight(10),
        ),
        height: SizeConfig.scaleWidth(70),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(5),
          boxShadow: [
            BoxShadow(
              color: AppColors.Very_LIGHT_GREY_COLOR,
              offset: Offset(0, 0),
              spreadRadius: 0.2,
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            if (isStartEdge) edgeWidget(),
            NoteCircle(
              radius: 24,
              isIcon: true,
              icon: icon,
              topMargin: 10,
              bottomMargin: 10,
              startMargin: isStartEdge == true ? 10 : 15,
              endMargin: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.scaleTextFont(13),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.scaleHeight(1),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: AppColors.LIGHT_GREY_COLOR,
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.scaleTextFont(12),
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsetsDirectional.only(
                end: SizeConfig.scaleWidth(isStartEdge == true ? 10 : 5),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: SizeConfig.scaleWidth(15),
              ),
            ),
            if (!isStartEdge) edgeWidget(),
          ],
        ),
      ),
    );
  }

  Container edgeWidget() {
    return Container(
      height: double.infinity,
      width: SizeConfig.scaleWidth(5),
      decoration: BoxDecoration(
        color: AppColors.BLUE_COLOR,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(isStartEdge == true ? 5 : 0),
          //Start Edge
          bottomStart: Radius.circular(isStartEdge == true ? 5 : 0),
          //Start Edge
          topEnd: Radius.circular(isStartEdge == true ? 0 : 5),
          //End Edge
          bottomEnd: Radius.circular(isStartEdge == true ? 0 : 5), //End Edge
        ),
      ),
    );
  }
}
