import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FancyGreenButton extends StatelessWidget {
  final Widget inputWidget;
  final bool? isLandingScreen;
  const FancyGreenButton({
    super.key,
    required this.inputWidget,
    this.isLandingScreen,
  });

  @override
  Widget build(BuildContext context) {
    return isLandingScreen != null && isLandingScreen == true ? Container(
      width: 285.w,
      height: 50.h,
      decoration: ShapeDecoration(
        color: const Color(0xFF1AB65C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.50),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 5,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Center(child: inputWidget),
    ) : Container(
      width: 328.w,
      height: 53.h,
      decoration: ShapeDecoration(
        color: const Color(0xFF1AB65C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26.50),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 5,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Center(child: inputWidget),
    );
    
    
    
  }
}
