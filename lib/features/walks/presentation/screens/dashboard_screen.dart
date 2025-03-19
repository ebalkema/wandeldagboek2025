import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/walk_repository.dart';
import '../../../../shared/models/walk.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: FutureBuilder<List<Walk>>(
        future: context.read<WalkRepository>().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Fout bij laden wandelingen: ${snapshot.error}'),
            );
          }

          final walks = snapshot.data ?? [];

          if (walks.isEmpty) {
            return const Center(
              child: Text('Nog geen wandelingen geregistreerd'),
            );
          }

          return ListView.builder(
            itemCount: walks.length,
            itemBuilder: (context, index) {
              final walk = walks[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(walk.title),
                  subtitle: Text(
                    'Afstand: ${walk.distance.toStringAsFixed(1)} km • '
                    'Duur: ${walk.duration.inMinutes} min',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigeer naar wandeling details
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Start nieuwe wandeling
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
