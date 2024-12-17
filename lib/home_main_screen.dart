import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/common/loader.dart';
import 'package:hizmetim/features/auth/controller/auth_controller.dart';
import 'package:hizmetim/features/auth/screens/login_screen.dart';
import 'package:hizmetim/features/home/screens/home_screen.dart';
import 'package:hizmetim/main.dart';

class HomeMainScreen extends ConsumerStatefulWidget {
  const HomeMainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends ConsumerState<HomeMainScreen> {
  late Future _initApp;
  @override
  void initState() {
    super.initState();
    _initApp = ref
        .read(authControllerProvider.notifier)
        .loginWithSecureStorage(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = ref.watch(isLoggedInProvider);
    return Scaffold(
      body: FutureBuilder(
        future: _initApp,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return isLoggedIn ? const HomeScreen() : const LoginScreen();
          } else {
            return const Center(
              child: Text(""),
            );
          }
        },
      ),
    );
  }
}
