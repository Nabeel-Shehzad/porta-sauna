import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portasauna/core/theme/pallete.dart';
import 'package:portasauna/core/utils/ui_const.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {super.key,
      this.onChange,
      this.items,
      this.value,
      this.bgColor,
      this.borderColor,
      this.width,
      this.textStyle,
      this.icon,
      this.iconColor,
      this.borderRadius,
      this.dropDownTextColor});

  final Function(String?)? onChange;
  final List<String>? items;
  final String? value;
  final Color? bgColor;
  final Color? borderColor;
  final double? width;
  final Icon? icon;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final Color? dropDownTextColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Pallete.buttonBgColor,
        borderRadius: borderRadius ?? radius(1),
        border: Border.all(color: borderColor ?? Pallete.borderColor),
      ),
      width: width ?? double.infinity,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            borderRadius: BorderRadius.circular(2),
            icon: icon,
            onChanged: onChange,
            iconDisabledColor: iconColor ?? const Color(0xffAAAAAA),
            iconEnabledColor: iconColor ?? const Color(0xffAAAAAA),
            dropdownColor: Pallete.buttonBgColor,
            elevation: 2,
            isExpanded: true,
            value: value,
            items: items?.map((value) {
              return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value.tr,
                    style: textStyle ?? Theme.of(context).textTheme.bodySmall,
                  ));
            }).toList(),
          ),
        ),
      ),
    );
  }
}
