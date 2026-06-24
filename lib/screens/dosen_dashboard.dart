// lib/screens/dosen_dashboard.dart
import 'package:flutter/material.dart';
import 'generate_qr_screen.dart';

class DosenDashboard extends StatelessWidget {
  const DosenDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Dosen")),
      body: SingleChildScrollView( // Proteksi overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mahasiswa Informatika", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                title: Text("Total Rekap Kehadiran Kelas (IF-001)"),
                subtitle: Text("Hadir: 28 Mahasiswa | Izin: 1 | Alpa: 0"),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.qr_code),
              label: const Text("GENERATE QR ABSENSI CLASS"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GenerateQRScreen(kodeMatkul: "IF-001")));
              },
            ),
            const SizedBox(height: 48),
            const Text("Detail Informasi Kelas:", style: TextStyle(fontWeight: FontWeight.bold)),
            const Text("Program Studi: Teknik Informatika\nFakultas: Teknik dan Ilmu Komputer")
          ],
        ),
      ),
    );
  }
}