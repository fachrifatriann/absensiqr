import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'mahasiswa_dashboard.dart';
import 'dosen_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _actionLogin() async {
    if (_nimController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    
    try {
      final response = await ApiService.login(_nimController.text, _passwordController.text);
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nim', data['nim']);
        await prefs.setString('nama', data['nama']);
        await prefs.setString('prodi', data['prodi']);

        // Memeriksa 'mounted' sebelum menggunakan BuildContext untuk menghilangkan warning biru
        if (!mounted) return;

        // Logika Alur: Jika NIM mengandung unsur "DOSEN", masuk ke Dashboard Dosen
        if (data['nim'].toString().toUpperCase().contains("DOSEN")) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DosenDashboard()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MahasiswaDashboard()));
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("NIM atau Password Salah!")));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal terhubung ke server.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Proteksi overflow sesuai spesifikasi kaku
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            children: [
              const Icon(Icons.qr_code_scanner, size: 120, color: Colors.blue),
              const SizedBox(height: 16),
              const Text("SISTEM PRESENSI QR", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 48),
              TextField(
                controller: _nimController, 
                decoration: const InputDecoration(labelText: "Nomor Induk Mahasiswa / Dosen", border: OutlineInputBorder())
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController, 
                obscureText: true, // Proteksi input password agar menggunakan obscureText true
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())
              ),
              const SizedBox(height: 40),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(55)),
                    onPressed: _actionLogin, 
                    child: const Text("MASUK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ),
            ],
          ),
        ),
      ),
    );
  }
}