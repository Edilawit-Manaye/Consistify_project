// consistify_frontend/lib/presentation/widgets/app_text_field.dart

import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? suffixIcon;
  final bool enabled; 

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.suffixIcon,
    this.enabled = true, 
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        
        floatingLabelStyle: TextStyle(
          color: enabled ? Colors.black87 : Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        
        enabledBorder: enabled
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        )
            : OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100], 
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.black87 : Colors.grey[700], 
      ),
    );
  }
}