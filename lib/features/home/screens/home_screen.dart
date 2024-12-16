import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/common/drawer_list.dart';
import 'package:hizmetim/features/auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              displayDrawer(context);
            },
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic!),
            ),
          ),
        ],
      ),
      drawer: const DrawerList(),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              logout(ref);
            },
            child: const Text('Sign Out')),
      ),
    );
  }
}
