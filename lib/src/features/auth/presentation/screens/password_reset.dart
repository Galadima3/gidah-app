import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:gidah/src/features/auth/presentation/screens/confirm_password.dart';

import 'package:google_fonts/google_fonts.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;

  Future<void> resetPassword(
      {required String email, required WidgetRef ref}) async {
    ref.read(loadingProvider.notifier).state = true;
    final auth = ref.read(authRepositoryProvider);
    await auth.resetPassword(email: email).then((value) {
      ref.read(loadingProvider.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent!")),
      );
    }).onError((error, stackTrace) {
      log(error.toString());
      ref.read(loadingProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          //Text
          Text(
            'Reset Password',
            style: GoogleFonts.urbanist(
              fontSize: 39,
              fontWeight: FontWeight.w700,
            ),
          ),
          //Long Paragraph
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              'Enter the email associated with your account and we\'ll send an email with instructions to reset your password',
              style: TextStyle(fontSize: 16.5),
            ),
          ),

          //email
          Form(
            key: emailFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                validator: (value) => EmailValidator.validate(value!)
                    ? null
                    : "Please enter a valid email",
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 25,
          ),
          //button
          Consumer(builder: (context, ref, child) {
            final isLoading = ref.watch(loadingProvider);
            return InkWell(
              onTap: () {
                if (emailFormKey.currentState!.validate()) {
                  resetPassword(email: emailController.text, ref: ref).then(
                      (value) => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ConfirmPasswordReset(),
                          )));
                }
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
                  child: isLoading
                      ? Transform.scale(
                          scale: 0.65,
                          child: const CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          'Send Instructions',
                          style: GoogleFonts.urbanist(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
