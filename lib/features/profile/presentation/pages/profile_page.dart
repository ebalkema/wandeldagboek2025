import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final bool isLoggedIn = currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn Profiel'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              if (isLoggedIn) ...[
                Text(
                  currentUser.displayName ?? 'Wandelaar',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentUser.email ?? 'Geen e-mail',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                _buildProfileCard(
                  context,
                  icon: Icons.directions_walk,
                  title: 'Mijn Wandelingen',
                  subtitle: 'Bekijk al je wandelingen',
                  onTap: () => Navigator.pushNamed(context, '/walks'),
                ),
                const SizedBox(height: 16),
                _buildProfileCard(
                  context,
                  icon: Icons.nature,
                  title: 'Mijn Observaties',
                  subtitle: 'Bekijk al je waarnemingen',
                  onTap: () => Navigator.pushNamed(context, '/observations'),
                ),
                const SizedBox(height: 16),
                _buildProfileCard(
                  context,
                  icon: Icons.settings,
                  title: 'Instellingen',
                  subtitle: 'Pas je voorkeuren aan',
                  onTap: () {},
                ),
                const Spacer(),
                Text(
                  'Wandeldagboek 2025 v$_appVersion',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) {
                      // Refresh de pagina na uitloggen
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Uitloggen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ] else ...[
                const Text(
                  'Niet ingelogd',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Log in om je profiel te bekijken en gebruik te maken van alle functies.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Navigeer naar inlogpagina
                    final result = await Navigator.pushNamed(context, '/login');
                    if (mounted && result == true) {
                      // Refresh de pagina na inloggen
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Inloggen'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    // Navigeer naar registratiepagina
                    final result =
                        await Navigator.pushNamed(context, '/register');
                    if (mounted && result == true) {
                      // Refresh de pagina na registreren
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Nieuw account aanmaken'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Wandeldagboek 2025 v$_appVersion',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
