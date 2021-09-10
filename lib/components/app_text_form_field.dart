import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final IconData prefixIcon;
  final String label;
  final TextInputType textInputType;
  final bool isHidden;

  final Function(String?)? onSaved;
  final String? Function(String?)? onValidate;

  const AppTextFormField({required this.prefixIcon, required this.label, required this.textInputType, this.isHidden=false,this.onSaved,this.onValidate});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[900],
      ),
      keyboardType: textInputType,
      textInputAction: TextInputAction.next,
      obscureText: isHidden,
      onSaved: onSaved,
      validator: onValidate,
    );
  }
}
