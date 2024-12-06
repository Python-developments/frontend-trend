import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String name;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextfield({
    required this.name,
    required this.controller,
    this.isPassword = false,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextfieldState createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && !_isPasswordVisible,
      cursorColor: Colors.grey, // Set cursor color to grey
      decoration: InputDecoration(
        labelText: widget.name,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black, // Black underline when focused
            width: 2.0, // Thickness of the underline when focused
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black, // Black underline when not focused
            width: 1.0, // Thickness of the underline when not focused
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey, // Icon color
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
