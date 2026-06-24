// lib/screens/generate_qr_screen.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRScreen extends StatelessWidget {
  final String kodeMatkul;

  const GenerateQRScreen({super.key, required this.kodeMatkul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code Presensi")),
      body: SingleChildScrollView( // Proteksi overflow jika orientasi layar landscape
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                QrImageView(
                  data: kodeMatkul, // Data diisi dengan kode_matkul dari parameter API
                  version: QrVersions.auto,
                  size: 300.0,
                ),
                const SizedBox(height: 40),
                const Text(
                  "Minta Mahasiswa untuk scan QR Code di atas menggunakan aplikasi presensi",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}