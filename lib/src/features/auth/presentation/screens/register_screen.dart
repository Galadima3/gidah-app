import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/constants/custom_snackbar.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:gidah/src/features/auth/presentation/screens/login_screen.dart';
import 'package:gidah/src/features/auth/presentation/screens/profile_details.dart';
import 'package:gidah/src/features/auth/presentation/widgets/bottom_text_widget.dart';
import 'package:google_fonts/google_fonts.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final confirmPasswordFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isPasswordVisible = true;
  bool isPasswordVisible1 = true;

  Future<void> signUpMethod(String email, String password, WidgetRef ref,
      BuildContext context) async {
    ref.read(loadingProvider.notifier).update((state) => true);
    final auth = ref.read(authRepositoryProvider);
    try {
      await auth.signUp(email, password);
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileDetails()),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(context, error.toString()),
      );
    } finally {
      ref.read(loadingProvider.notifier).update((state) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    //print(height);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //text
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Create your account',
                style: GoogleFonts.urbanist(
                  fontSize: 39,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(
              height: height * 0.045,
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
            SizedBox(
              height: height * 0.025,
            ),
            //password
            Form(
              key: passwordFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: isPasswordVisible,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => value!.length > 6
                      ? null
                      : "Password should be more than 6 characters",
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.025,
            ),

            //confirm password
            Form(
              key: confirmPasswordFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: isPasswordVisible1,
                  controller: confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) => value! == passwordController.text
                      ? null
                      : "Passwords don't match",
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible1 = !isPasswordVisible1;
                          });
                        },
                        icon: Icon(isPasswordVisible1
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.025,
            ),

            //button
            Consumer(
              builder: (context, ref, child) {
                final isLoading = ref.watch(loadingProvider);
                return GestureDetector(
                  onTap: () {
                    if (emailFormKey.currentState!.validate() &&
                        passwordFormKey.currentState!.validate() &&
                        confirmPasswordFormKey.currentState!.validate()) {
                      signUpMethod(emailController.text,
                          passwordController.text, ref, context);
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
                              'Sign up',
                              style: GoogleFonts.urbanist(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 15,
            ),
            //text
            BottomTextWidget(
              text1: 'Already have an account? ',
              text2: 'Sign In ',
              reqFunction: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              )),
            )
          ],
        ),
      ),
    );
  }
}
