// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gidah/src/constants/fancy_green_button.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:open_mail_app/open_mail_app.dart';

class ConfirmPasswordReset extends StatelessWidget {
  const ConfirmPasswordReset({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Logo
          SvgPicture.asset(
            'asset/images/mail.svg',
            height: 135.h,
            width: 250.w,
          ),
          SizedBox(
            height: 35.h,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Check your mail',
              style: GoogleFonts.urbanist(
                fontSize: 39.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              'We have sent password recovery instructions to your email',
              style: TextStyle(fontSize: 16.5.sp),
            ),
          ),

          SizedBox(
            height: 25.h,
          ),

          GestureDetector(
            onTap: () async {
              // var result = await OpenMailApp.openMailApp();

              // // If no mail apps found, show error
              // if (!result.didOpen && !result.canOpen) {
              //   //showNoMailAppsDialog(context);
              //   void showNoMailAppsDialog(BuildContext context) {
              //     showDialog(
              //       context: context,
              //       builder: (context) {
              //         return AlertDialog(
              //           title: const Text("Open Mail App"),
              //           content: const Text("No mail apps installed"),
              //           actions: <Widget>[
              //             TextButton(
              //               child: const Text("OK"),
              //               onPressed: () {
              //                 Navigator.pop(context);
              //               },
              //             )
              //           ],
              //         );
              //       },
              //     );
              //   }

              //   // iOS: if multiple mail apps found, show dialog to select.
              //   // There is no native intent/default app system in iOS so
              //   // you have to do it yourself.
              // } else if (!result.didOpen && result.canOpen) {
              //   void showMailDialog(BuildContext context) {
              //     showDialog(
              //       context: context,
              //       builder: (_) {
              //         return MailAppPickerDialog(
              //           mailApps: result.options,
              //         );
              //       },
              //     );
              //   }
              // }
            },
            child: FancyGreenButton(
              inputWidget: Text(
                'Open email app',
                style: GoogleFonts.urbanist(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

