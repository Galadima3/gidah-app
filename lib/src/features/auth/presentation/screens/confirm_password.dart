// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            height: 135,
            width: 250,
          ),
          const SizedBox(
            height: 35,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Check your mail',
              style: GoogleFonts.urbanist(
                fontSize: 39,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              'We have sent password recovery instructions to your email',
              style: TextStyle(fontSize: 16.5),
            ),
          ),

          const SizedBox(
            height: 25,
          ),
          // Center(
          //   child: Container(
          //     height: 50,
          //     width: 285,
          //     decoration: BoxDecoration(
          //         color: Colors.white70,
          //         borderRadius: BorderRadius.circular(12)),
          //     child: const Center(
          //       child: Text('Log in to an existing account '),
          //     ),
          //   ),
          // ),
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
            child: Container(
              width: 328,
              height: 53,
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
              child: Center(
                child: Text(
                  'Open email app',
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
