import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth;
  static double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static double deviceRatio;
  static bool isPortrait = true;
  static bool isMobilePortrait = true;

  static MediaQueryData _mediaQueryData;

  // void init(BoxConstraints constraints, Orientation orientation){
  //   if (orientation == Orientation.portrait){
  //     _screenWidth = constraints.maxWidth;
  //     _screenHeight = constraints.maxHeight;
  //     isPortrait = true;
  //     if(_screenWidth < 450){
  //       isMobilePortrait = true;
  //     }
  //   } else{
  //     _screenWidth = constraints.maxHeight;
  //     _screenHeight = constraints.maxWidth;
  //     isPortrait = false;
  //     isMobilePortrait = false;
  //   }
  // }

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;

    _blockWidth = screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    deviceRatio = screenWidth / _screenHeight;

    // print("Height $_screenHeight");
    // print("---");
    // print("textMultiplier: $textMultiplier");
    // print("heightMultiplier: $heightMultiplier");
    // print("widthMultiplier: $widthMultiplier");
    // print("_screenWidth: $_screenWidth");
    // print("---");
  }

  static double scaleTextFont(double fontSize) {
    double scale = fontSize / 8.96;
    return (textMultiplier * scale);
  }

  static double scaleWidth(double width) {
    double scale = width / 4.14;
    return (widthMultiplier * scale);
  }

  static double scaleHeight(double height) {
    // double scale = height / 8.7;
    double scale = height / 9.1;
    return (heightMultiplier * scale);
  }
}

// class SizeConfig{
//   static MediaQueryData _mediaQueryData;
//   static double screenWidth;
//   static double screenHeight;
//   static double blockSizeHorizontal = 0;
//   static double blockSizeVertical = 0;
//
//   static double _safeAreaHorizontal;
//   static double _safeAreaVertical;
//   static double safeBlockHorizontal;
//   static double safeBlockVertical;
//
//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenWidth = _mediaQueryData.size.width;
//     screenHeight = _mediaQueryData.size.height;
//
//     blockSizeHorizontal = screenWidth / 100;
//     blockSizeVertical = screenHeight / 100;
//
//     _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
//     _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
//     safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
//     safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
//   }
//
//   static double scaleTextFont(double fontSize){
//     double scale = fontSize / 4.14;
//     return ((safeBlockHorizontal * scale));
//   }
//
//   static double scaleWidth(double width){
//     double scale = width / 4.14;
//     return ((blockSizeHorizontal * scale));
//   }
//
//   static double scaleHeight(double height){
//     // double scale = height / 8.7;
//     double scale = height / 9.0;
//     return ((blockSizeVertical * scale));
//   }
// }
