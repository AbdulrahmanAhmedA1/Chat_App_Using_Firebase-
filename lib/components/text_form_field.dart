
import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final String? Function(String?)? validate;
  final String lText;
  final String hText;
  final Widget pIcon;
  final Widget? sIcon;
  final bool secureText;
  final TextInputType textInputType;
  final void Function(String?)? onSave;

  const DefaultTextField({
    required this.validate,
    required this.lText,
    required this.hText,
    required this.pIcon,
    this.sIcon,
    required this.textInputType,
    this.onSave,
    this.secureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      validator: validate,
      onSaved: onSave,
      obscureText: secureText,
      decoration: InputDecoration(
        labelText: lText,
        hintText: hText,
        prefixIcon: pIcon,
        suffixIcon: sIcon,
        border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
            )),
      ),
    );
  }
}
