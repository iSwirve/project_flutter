import 'package:flutter/material.dart';
import '../constants/colors.dart' as colors;
import '../constants/dimens.dart' as dimens;

class CustomButtonSmall extends StatelessWidget {
  CustomButtonSmall({super.key, this.text = "", this.onPressed});
  String text = "";
  
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: dimens.buttonVerticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimens.buttonBorderRadius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: colors.buttonPrimaryText,
          ),
        ),
      ),
    );
  }
}
