import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../constants/colors.dart' as colors;
import '../constants/dimens.dart' as dimens;

class CustomTextField extends StatelessWidget {
  String? hintText, title, labeltext;
  int? custom_maxline_size;
  TextEditingController? text_controller;
  Widget? prefixIcon;

  CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.title,
    this.text_controller,
    this.labeltext,
    this.custom_maxline_size,
  });

  @override
  Widget build(BuildContext context) {
    bool visible = false;
    if (title != null) visible = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: visible,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '$title',
              style: TextStyle(
                color: colors.textPrimaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        TextFormField(
          controller: text_controller,
          maxLines: custom_maxline_size,
          validator: (value) {
            if (value == null) {
              return "Required field";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            labelText: labeltext,
            prefixIcon: prefixIcon,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors.inputBorderPrimary,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colors.inputBorderPrimary,
                width: 1.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: dimens.inputContentPaddingHorizontal,
              vertical: dimens.inputContentPaddingVertical,
            ),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
