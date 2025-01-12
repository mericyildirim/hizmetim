import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Tema Değiştir'),
            trailing: Switch(value: true, onChanged: null),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Dil Seçimi'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Bildirim Ayarları'),
            trailing: Switch(value: true, onChanged: null),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Hakkında'),
          ),
        ],
      ),
    );
  }
}
