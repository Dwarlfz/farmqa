import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final email = auth.user?.email ?? 'Guest';

    return Drawer(
      child: SafeArea(
        child: Column(children: [
          UserAccountsDrawerHeader(
            accountName: Text(auth.user?.displayName ?? 'Farmer'),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person, color: Colors.white), backgroundColor: Colors.green.shade700),
            decoration: const BoxDecoration(color: Color(0xFF4CAF50)),
          ),
          ListTile(leading: const Icon(Icons.person), title: const Text('Profile'), onTap: () => Navigator.pushNamed(context, '/profile')),
          ListTile(leading: const Icon(Icons.history), title: const Text('Query History'), onTap: () => Navigator.pushNamed(context, '/history')),
          ListTile(leading: const Icon(Icons.bookmark), title: const Text('Saved Advisory'), onTap: () => Navigator.pushNamed(context, '/saved')),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () => Navigator.pushNamed(context, '/settings')),
          const Divider(),
          ListTile(leading: const Icon(Icons.info), title: const Text('About / Help'), onTap: () => Navigator.pushNamed(context, '/about')),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await auth.signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ]),
      ),
    );
  }
}
