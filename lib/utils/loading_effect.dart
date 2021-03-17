import 'package:flutter/material.dart';
import 'package:notes_app/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

class LoadingEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int time = 800;
    int offset = 5;
    SizeConfig().init(context);
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.scaleWidth(20),
        vertical: SizeConfig.scaleHeight(5),
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        offset += 5;
        time = 800 + offset;
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.white,
          period: Duration(milliseconds: time),
          child: Container(
            margin:
                EdgeInsetsDirectional.only(bottom: SizeConfig.scaleHeight(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.scaleWidth(70),
                  height: SizeConfig.scaleWidth(70),
                  color: Colors.red,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.scaleWidth(150),
                      height: SizeConfig.scaleWidth(15),
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: SizeConfig.scaleWidth(280),
                      height: SizeConfig.scaleWidth(15),
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: SizeConfig.scaleWidth(280),
                      height: SizeConfig.scaleWidth(15),
                      color: Colors.red,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
