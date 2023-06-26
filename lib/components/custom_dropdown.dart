import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart' as colors;
import '../constants/dimens.dart' as dimens;

void getValue(String value) {}

class CustomDropdown extends StatefulWidget {
  Map<dynamic, dynamic>? list;
  String? title;
  SingleValueDropDownController? controller =
      SingleValueDropDownController(data: DropDownValueModel(name: "-", value: '-'));

  CustomDropdown({
    super.key,
    this.list,
    this.title,
    this.controller,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    bool visible = false;
    if (widget.title != null) visible = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: visible,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '${widget.title}',
              style: TextStyle(
                color: colors.textPrimaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DropDownTextField(
          autovalidateMode: AutovalidateMode.always,
          validator: (value) {
            if (value == null) {
              return "Required field";
            } else {
              return null;
            }
          },
          clearOption: false,
          textFieldDecoration: InputDecoration(
            hintText: "Select Data",
            contentPadding: EdgeInsets.symmetric(
              vertical: dimens.inputContentPaddingVertical,
              horizontal: dimens.inputContentPaddingHorizontal,
            ),
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
          ),
          controller: widget.controller,
          dropdownRadius: 8.0,
          dropDownItemCount: widget.list!.length,
          dropDownList: [
            for (var i = 0; i < widget.list!.length; i++)
              DropDownValueModel(
                name: widget.list!.values.elementAt(i),
                value: widget.list!.keys.elementAt(i),
              ),
          ],
          onChanged: (val) {},
        ),
      ],
    );
  }
}
