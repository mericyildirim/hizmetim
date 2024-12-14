import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/common/auth_gradient_button.dart';
import 'package:hizmetim/core/common/custom_field.dart';
import 'package:hizmetim/core/common/loader.dart';
import 'package:hizmetim/core/common/sign_in_google_button.dart';
import 'package:hizmetim/core/constants/constants.dart';
import 'package:hizmetim/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider); // Yüklenme durumu
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Loader() // Yükleniyorsa loader göster
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Sign Up.',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomField(
                        hintText: 'Name',
                        controller: nameController,
                        isObscureText: false),
                    const SizedBox(height: 15),
                    CustomField(
                        hintText: 'E-mail', controller: emailController),
                    const SizedBox(height: 15),
                    CustomField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true),
                    const SizedBox(height: 15),
                    AuthGradientButton(
                      buttonText: 'Sign Up',
                      onTap: () {
                        // Form doğrulama
                        if (formKey.currentState!.validate()) {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          final name = nameController.text.trim();

                          // AuthController üzerinden kayıt olma işlemini çağır
                          ref
                              .read(authControllerProvider.notifier)
                              .signUpWithEmail(context, email, password, name);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Routemaster.of(context).push('/login');
                      },
                      child: const Text('Already have an account? Sign In'),
                    ),
                    const SizedBox(height: 15),
                    const SignInGoogleButton(),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
    );
  }
}
