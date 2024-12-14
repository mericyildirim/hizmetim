import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/constants/constants.dart';
import 'package:hizmetim/features/auth/controller/auth_controller.dart';
import 'package:hizmetim/theme/palette.dart';

class SignInGoogleButton extends ConsumerWidget {
  const SignInGoogleButton({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Pallete.gradient2,
            Pallete.gradient1,
          ],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(context, ref),
          icon: Image.asset(
            Constants.googlePath,
            width: 35,
          ),
          label: const Text(
            'Continue with Google',
            style: TextStyle(
              fontSize: 17,
              color: Pallete.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            fixedSize: const Size(395, 55),
            shadowColor: Colors.transparent,
          )),
    );
  }
}
