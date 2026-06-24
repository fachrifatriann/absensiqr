// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiService {
  static Future<http.Response> login(String nim, String password) async {
    final url = Uri.parse("${AppConstants.baseUrl}/login");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nim": nim, "password": password}),
    );
  }

  static Future<http.Response> getDashboard(String nim) async {
    final url = Uri.parse("${AppConstants.baseUrl}/mahasiswa/dashboard/$nim");
    return await http.get(url);
  }

  static Future<http.Response> postAbsen(String nim, String kodeMatkul) async {
    final url = Uri.parse("${AppConstants.baseUrl}/absen");
    // Sesuai aturan ketat: Hanya mengirim nim dan kode_matkul. Waktu diisi oleh server/DB.
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nim": nim, "kode_matkul": kodeMatkul}),
    );
  }
}