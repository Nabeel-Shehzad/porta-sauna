import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInput extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final bool? readOnly;
  final String? Function(String?)? validation;
  final TextInputAction textInputAction;
  final bool isPasswordField;
  final FocusNode? focusNode;
  final bool isNumberField;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double marginBottom;
  final double borderRadius;
  final TextEditingController? controller;
  final int? maxLines;
  final bool autofocus;
  final double? inputHeight;
  final Function(String)? onFieldSubmitted;
  final bool? filled;
  final TextStyle? hintStyle;
  final InputBorder? borderBottom;

  const CustomInput({
    super.key,
    this.hintText,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.isPasswordField = false,
    this.focusNode,
    this.isNumberField = false,
    this.controller,
    this.validation,
    this.prefixIcon,
    this.suffixIcon,
    this.paddingHorizontal,
    this.marginBottom = 0,
    this.borderRadius = 0,
    this.paddingVertical,
    this.maxLines,
    this.onTap,
    this.readOnly,
    this.autofocus = false,
    this.inputHeight,
    this.onSuffixTap,
    this.onFieldSubmitted,
    this.filled,
    this.hintStyle,
    this.borderBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: marginBottom),
        height: inputHeight,
        child: TextFormField(
          controller: controller,
          autofocus: autofocus,
          keyboardType:
              isNumberField ? TextInputType.number : TextInputType.text,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: maxLines ?? 1,
          onChanged: onChanged,
          onTap: onTap,
          validator: validation,
          textInputAction: textInputAction,
          obscureText: isPasswordField,
          readOnly: readOnly ?? false,
          decoration: customInputDecoration(
            context,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            borderRadius: borderRadius,
            hintText: hintText,
            paddingHorizontal: paddingHorizontal,
            paddingVertical: paddingVertical,
            onSuffixTap: onSuffixTap,
            filled: filled,
            hintStyle: hintStyle,
            borderBottom: borderBottom,
          ),
        ));
  }
}

InputDecoration customInputDecoration(BuildContext context,
    {prefixIcon,
    VoidCallback? onSuffixTap,
    bgColor,
    borderRadius,
    String? hintText,
    double? paddingHorizontal,
    double? paddingVertical,
    suffixIcon,
    bool? filled = false,
    TextStyle? hintStyle,
    InputBorder? borderBottom}) {
  return InputDecoration(
      filled: filled,
      prefixIcon: prefixIcon != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(prefixIcon)],
            )
          : null,
      suffixIcon: suffixIcon != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [InkWell(onTap: onSuffixTap, child: Icon(suffixIcon))],
            )
          : null,
      border: borderBottom,
      errorBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      hintText: hintText,
      hintStyle: hintStyle ?? Theme.of(context).textTheme.bodySmall,
      contentPadding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? 15.sp,
        vertical: paddingVertical ?? 18.sp,
      ));
}
