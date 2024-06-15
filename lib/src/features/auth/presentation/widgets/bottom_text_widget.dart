import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomTextWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback reqFunction;
  const BottomTextWidget({
    super.key,
    required this.text1,
    required this.text2,
    required this.reqFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text1,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: reqFunction,
            child: Text(
              text2,
              style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}