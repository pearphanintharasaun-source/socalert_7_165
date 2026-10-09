import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../controllers/auth_controller.dart';
import 'add_incident_screen.dart';
import 'edit_incident_screen.dart';
import '../models/incident.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _fs = FirestoreService();
  final AuthController _auth = AuthController();
  String _role = 'guest';

  @override
  void initState() {
    super.initState();
    _role = _auth.getUserRole(_auth.currentUser?.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOCAlert'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              if (mounted) Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      floatingActionButton: _auth.canCreate(_role)
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddIncidentScreen())),
              child: const Icon(Icons.add),
            )
          : null,
      body: StreamBuilder<List<Incident>>(
        stream: _fs.getIncidentsStream(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.isEmpty) {
            return const Center(child: Text('ไม่พบข้อมูลเหตุการณ์'));
          }
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final item = list[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(item.cvssScore.toStringAsFixed(1)),
                  ),
                  title: Text(item.ticketNo),
                  subtitle: Text(item.attackType),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_auth.canEdit(_role))
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditIncidentScreen(data: item))),
                        ),
                      if (_auth.canDelete(_role))
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(item.id!),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('ต้องการลบข้อมูลนี้ใช่หรือไม่?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ยกเลิก')),
          TextButton(
            onPressed: () async {
              await _fs.deleteIncident(id);
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}