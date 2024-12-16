import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/features/auth/controller/auth_controller.dart';
import 'package:hizmetim/features/auth/screens/signup_screen.dart';
import 'package:hizmetim/features/home/screens/home_screen.dart';
import 'package:hizmetim/firebase_options.dart';
import 'package:hizmetim/theme/palette.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(authControllerProvider.notifier)
            .loginWithSecureStorage(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = ref.watch(isLoggedInProvider);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hizmetim',
        theme: Pallete.lightModeAppTheme,
        home: isLoggedIn ? const HomeScreen() : const SignupScreen());
  }
}

final isLoggedInProvider = StateProvider<bool>((ref) {
  var user = ref.watch(userProvider);
  if (user != null) {
    return true;
  } else {
    return false;
  }
});
