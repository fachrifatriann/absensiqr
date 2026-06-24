// lib/screens/scan_qr_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});
  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(child: Text('Arahkan kamera HP ke QR Code Dosen', style: TextStyle(fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!_isProcessing && scanData.code != null) {
        _isProcessing = true;
        controller.pauseCamera();
        
        final prefs = await SharedPreferences.getInstance();
        final currentNim = prefs.getString('nim') ?? '';
        final scannedKodeMatkul = scanData.code!;

        try {
          final response = await ApiService.postAbsen(currentNim, scannedKodeMatkul);

          if (response.statusCode == 201) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Absen Berhasil!"), backgroundColor: Colors.green)
              );
              Navigator.pop(context); // Otomatis kembali ke dashboard setelah berhasil
            }
          } else {
            _resetCamera();
          }
        } catch (e) {
          _resetCamera();
        }
      }
    });
  }

  void _resetCamera() {
    _isProcessing = false;
    controller?.resumeCamera();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal melakukan absensi. Coba lagi.")));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}