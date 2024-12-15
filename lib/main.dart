import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  UserModel? userModel;
  late Future<void> userFuture;

  // Kullanıcı verisini almak için async fonksiyon
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
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (data) {
            // Eğer data null değilse veriyi al
            if (userModel == null) {
              userFuture =
                  getData(ref, data); // data burada nullable User? olabilir
            } else {
              // userModel varsa, userFuture'ı geçerli yap
              userFuture = Future.value();
            }

            return FutureBuilder<void>(
              future: userFuture,
              builder: (context, snapshot) {
                // Eğer veri alınıyor veya hata varsa bir bekleme durumu göster
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                if (snapshot.hasError) {
                  return ErrorText(error: snapshot.error.toString());
                }

                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Hizmetim',
                  theme: Pallete.lightModeAppTheme,
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
