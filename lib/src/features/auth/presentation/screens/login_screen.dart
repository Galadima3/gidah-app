import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/constants/custom_snackbar.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:gidah/src/features/auth/presentation/screens/password_reset.dart';
import 'package:gidah/src/features/auth/presentation/screens/register_screen.dart';
import 'package:gidah/src/features/auth/presentation/widgets/bottom_navigation_bar.dart';
import 'package:gidah/src/features/auth/presentation/widgets/bottom_text_widget.dart';
import 'package:gidah/src/features/auth/presentation/widgets/custom_text_formfield.dart';
import 'package:google_fonts/google_fonts.dart';


final loadingProvider = StateProvider<bool>((ref) => false);
final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signInMethod(
      String email, String password, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();
    ref.read(loadingProvider.notifier).update((state) => true);
    final auth = ref.read(authRepositoryProvider);
    try {
      await auth.signInWithEmailAndPassword(email, password);
      if (!mounted) return; 
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomNavBar(),
      ));
    } catch (error, _) {
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
    final isLoading = ref.watch(loadingProvider);
    final isPasswordVisible = ref.watch(passwordVisibilityProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'Login to your Account',
                  style: GoogleFonts.urbanist(
                    fontSize: 39,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: height * 0.045),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomTextFormField(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : "Please enter a valid email",
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: height * 0.035),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.password,
                  obscureText: isPasswordVisible,
                  validator: (value) => value!.length > 6
                      ? null
                      : "Password should be more than 6 characters",
                  suffixIcon: IconButton(
                    onPressed: () => ref
                        .read(passwordVisibilityProvider.notifier)
                        .update((state) => !state),
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 8.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Forgot Password?',
                          style: GoogleFonts.urbanist(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.025),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    signInMethod(
                        emailController.text, passwordController.text, ref);
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
                      ),
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
                            'Sign In',
                            style: GoogleFonts.urbanist(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              BottomTextWidget(
                text1: 'Don\'t have an account? ',
                text2: 'Sign up',
                reqFunction: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
