import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Button text
  final VoidCallback onPressed; // Callback for button press
  final Color? color; // Background color
  final Color? textColor; // Text color
  final double? fontSize; // Font size

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // Default to theme primary color
        padding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 20), // Padding inside button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white, // Default text color to white
          fontSize: fontSize ?? 16, // Default font size
          fontWeight: FontWeight.bold, // Bold text
        ),
      ),
    );
  }
}
