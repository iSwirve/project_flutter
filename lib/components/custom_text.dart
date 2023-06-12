import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomText extends StatelessWidget {
  CustomText({super.key, this.text, this.textStyle, this.sizedBox});
  String? text;
  SizedBox? sizedBox;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 7),
          child: Text(
            '$text',
            style: textStyle,
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
