import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/common/error_text.dart';
import 'package:hizmetim/core/common/loader.dart';
import 'package:hizmetim/features/auth/controller/auth_controller.dart';
import 'package:hizmetim/firebase_options.dart';
import 'package:hizmetim/models/user_model.dart';
import 'package:hizmetim/router.dart';
import 'package:hizmetim/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  UserModel? userModel;
  late Future<void> userFuture;
  bool isSplashScreenVisible = true;
  final appTheme = Pallete.darkModeAppTheme;

  Future<void> getData(WidgetRef ref, User? data) async {
    if (data != null && userModel == null) {
      userModel = await ref
          .watch(authControllerProvider.notifier)
          .getUserData(data.uid)
          .first;
      ref.read(userProvider.notifier).update((state) => userModel);
      log('deneme');
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (data) {
            if (userModel == null) {
              userFuture = getData(ref, data);
            } else {
              userFuture = Future.value();
            }

            return FutureBuilder<void>(
              future: userFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorText(error: snapshot.error.toString());
                }

                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Hizmetim',
                  theme: appTheme,
                  routerDelegate: RoutemasterDelegate(
                    routesBuilder: (context) {
                      if (data != null) {
                        if (userModel != null) {
                          return loggedInRoute;
                        }
                      }
                      return loggedOutRoute;
                    },
                  ),
                  routeInformationParser: const RoutemasterParser(),
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
