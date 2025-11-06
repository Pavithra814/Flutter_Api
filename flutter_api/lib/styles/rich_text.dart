import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;

  const InfoText({
    super.key,
    required this.label,
    required this.value,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }
}
