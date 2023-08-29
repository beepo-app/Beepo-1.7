import 'package:flutter/material.dart';

import '../utils/styles.dart';

class OutlnButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  // final Color color;

  const OutlnButton({
    Key? key,
    required this.text,
    // required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 237,
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            const BorderSide(
              width: 1,
              color: secondaryColor,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
