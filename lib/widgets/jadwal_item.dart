// lib/widgets/jadwal_item.dart
import 'package:flutter/material.dart';
import '../models/matakuliah_model.dart';

class JadwalItem extends StatelessWidget {
  final MatakuliahModel matkul;

  const JadwalItem({super.key, required this.matkul});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.menu_book)),
        title: Text(matkul.namaMatkul, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${matkul.dosen} • ${matkul.ruangan}"),
        trailing: Text(
          "${matkul.jamMulai.substring(0, 5)} - ${matkul.jamSelesai.substring(0, 5)}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }
}