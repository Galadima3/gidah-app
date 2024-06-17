import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gidah/src/constants/fancy_green_button.dart';
import 'package:gidah/src/features/auth/presentation/screens/confirm_password.dart';
import 'package:gidah/src/features/auth/presentation/screens/login_screen.dart';
import 'package:gidah/src/features/auth/presentation/screens/register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Logo
          SvgPicture.asset(
            'asset/images/flutter.svg',
            height: 150.h,
            width: 250.w,
          ),
          SizedBox(
            height: 35.h,
          ),

          Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              )),
              child: const FancyGreenButton(inputWidget: Text(
                    'Create an account ',
                    style: TextStyle(color: Colors.white),
                  ), isLandingScreen: true,)
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            )),
            child: Container(
                width: 285.w,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade600,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                      Colors.grey.shade400,
                      Colors.grey.shade500,
                    ],
                    stops: const [0.1, 0.3, 0.8, 1],
                  ),
                ),
                child:
                    const Center(child: Text('Log in to an existing account'))),
          )
        ],
      ),
    );
  }
}
