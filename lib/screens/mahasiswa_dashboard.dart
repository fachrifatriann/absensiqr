// lib/screens/mahasiswa_dashboard.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/matakuliah_model.dart';
import '../widgets/statistik_card.dart';
import '../widgets/jadwal_item.dart';
import 'scan_qr_screen.dart';

class MahasiswaDashboard extends StatefulWidget {
  const MahasiswaDashboard({super.key});
  @override
  State<MahasiswaDashboard> createState() => _MahasiswaDashboardState();
}

class _MahasiswaDashboardState extends State<MahasiswaDashboard> {
  String _nama = "", _nim = "", _prodi = "";
  String _hadir = "0", _izin = "0", _alpa = "0";
  List<MatakuliahModel> _jadwalList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentNim = prefs.getString('nim') ?? '';
    setState(() {
      _nama = prefs.getString('nama') ?? '';
      _nim = currentNim;
      _prodi = prefs.getString('prodi') ?? '';
    });

    final response = await ApiService.getDashboard(currentNim);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _hadir = data['statistik']['hadir'].toString();
        _izin = data['statistik']['izin'].toString();
        _alpa = data['statistik']['alpa'].toString();
        
        var list = data['jadwal_hari_ini'] as List;
        _jadwalList = list.map((item) => MatakuliahModel.fromJson(item)).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Mahasiswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const QrCodeScreen())).then((_) => _fetchDashboardData());
            },
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView( // Proteksi overflow konten panjang
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("NIM: $_nim | $_prodi", style: const TextStyle(color: Colors.grey)),
                const Divider(height: 32),
                Row(
                  children: [
                    StatistikCard(label: "Hadir", value: _hadir, color: Colors.green),
                    StatistikCard(label: "Izin", value: _izin, color: Colors.orange),
                    StatistikCard(label: "Alpa", value: _alpa, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 32),
                const Text("Jadwal Kuliah Hari Ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _jadwalList.length,
                  itemBuilder: (context, index) => JadwalItem(matkul: _jadwalList[index]),
                )
              ],
            ),
          ),
    );
  }
}