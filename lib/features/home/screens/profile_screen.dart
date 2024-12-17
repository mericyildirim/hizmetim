import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/constants/constants.dart';
import 'package:hizmetim/features/auth/controller/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        user.profilePic ?? Constants.avatarDefault),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            const Text('Hakkımda:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Bu alan kullanıcının biyografi bilgisini gösterebilir. Buraya detaylı açıklamalar eklenebilir.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text('Bakiye:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              '${user.balance} TL',
              style: const TextStyle(fontSize: 16),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Profili Düzenle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
