import 'package:flutter/material.dart';
import 'package:notes_app/utils/app_colors.dart';
import 'package:notes_app/utils/size_config.dart';

class NoteTextField extends StatelessWidget {
  final String hint;
  bool obscureText;
  TextInputType keyboardType;
  TextEditingController controller;

  NoteTextField(this.hint, this.controller,
      {this.obscureText = false, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return TextField(
      style: TextStyle(
        fontSize: SizeConfig.scaleTextFont(22),
        color: AppColors.DARK_BLUE_COLOR,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: SizeConfig.scaleTextFont(22),
          color: AppColors.HINT_COLOR,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.UNDERLINE_COLOR,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.UNDERLINE_COLOR,
            width: 1,
          ),
        ),
      ),
      controller: this.controller ?? "",
      obscureText: this.obscureText,
      keyboardType:
          this.keyboardType == null ? TextInputType.text : this.keyboardType,
    );
  }
}
