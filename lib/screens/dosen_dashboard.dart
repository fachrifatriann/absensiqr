import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../constants.dart';
import 'share_state.dart';
import 'login_screen.dart';

class DosenDashboard extends StatefulWidget {
  const DosenDashboard({super.key});

  @override
  State<DosenDashboard> createState() => _DosenDashboardState();
}

class _DosenDashboardState extends State<DosenDashboard> {
  String selectedMatkul = 'Pemrograman Mobile (Flutter)';
  final TextEditingController _topikController = TextEditingController();
  String generatedData = '';
  String currentTopik = '';

  // Pop-up dialog konfirmasi tengah layar untuk Dosen
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.logout_rounded, color: Colors.redAccent, size: 40),
              SizedBox(height: 14),
              Text('Konfirmasi Keluar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textDark)),
            ],
          ),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Dosen?', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            SizedBox(
              width: 110,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            SizedBox(
              width: 110,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Tutup bottom sheet
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Bottom Sheet profil Dosen (Sama persis strukturnya dengan Mahasiswa)
  void _showDosenProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 14.0, bottom: MediaQuery.of(context).viewInsets.bottom + 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2)),
                child: CircleAvatar(radius: 44, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: const Icon(Icons.supervisor_account, size: 55, color: AppColors.primary)),
              ),
              const SizedBox(height: 14),
              const Text('Prof. Dr. Fachri Fatrian, M.T.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: const Text('NIDN: 99912345', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                child: const Column(
                  children: [
                    _DosenInfoTile(icon: Icons.school_outlined, title: 'Program Studi', value: 'Teknik Informatika'),
                    _DosenInfoTile(icon: Icons.account_balance_outlined, title: 'Fakultas', value: 'Teknik dan Ilmu Komputer'),
                    _DosenInfoTile(icon: Icons.workspace_premium_outlined, title: 'Jabatan Fungsional', value: 'Guru Besar / Profesor'),
                    _DosenInfoTile(icon: Icons.badge_outlined, title: 'Status Dosen', value: 'Dosen Tetap Utama'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutConfirmation(context), // Memicu pop up konfirmasi dialog
                  icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
                  label: const Text('Keluar Aplikasi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _generateQRCode() {
    if (_topikController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan isi topik bahasan kuliah hari ini terlebih dahulu!'), backgroundColor: Colors.redAccent));
      return;
    }
    setState(() {
      currentTopik = _topikController.text.trim();
      generatedData = 'ABSENSI|${selectedMatkul.replaceAll(' ', '_')}|TOPIK:${currentTopik.replaceAll(' ', '_')}|${DateTime.now().millisecondsSinceEpoch}';
      SharedState.apakahDosenSudahIsiTopik = true;
      SharedState.topikHariIni = currentTopik;
      SharedState.matkulAktif = selectedMatkul;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Materi untuk $selectedMatkul berhasil di-publish!'), backgroundColor: Colors.green));
  }

  @override
  void dispose() {
    _topikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard Dosen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showDosenProfileBottomSheet(context),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: Icon(Icons.supervisor_account, size: 35, color: Colors.white)),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Prof. Dr. Fachri Fatrian, M.T.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 4),
                            Text('NIDN: 99912345', style: TextStyle(color: AppColors.textGrey, fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.textGrey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Kontrol Presensi Kuliah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 4),
            const Text('Atur mata kuliah dan topik bahasan sebelum membuat QR Code presensi.', style: TextStyle(color: AppColors.textGrey)),
            const SizedBox(height: 20),
            const Text('Mata Kuliah', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMatkul,
                  isExpanded: true,
                  items: <String>['Pemrograman Mobile (Flutter)', 'Rekayasa Perangkat Lunak', 'Kecerdasan Buatan'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedMatkul = newValue;
                        generatedData = '';
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Topik Bahasan Hari Ini', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            TextField(
              controller: _topikController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Contoh: Implementasi State Management (Provider/Bloc) atau Pengenalan DFD',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _generateQRCode,
                icon: const Icon(Icons.qr_code_2, color: Colors.white),
                label: const Text('Generate QR Code Baru', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: generatedData.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Icon(Icons.qr_code, size: 100, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text('Belum ada QR Code aktif', style: TextStyle(color: AppColors.textGrey)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Silakan Tunjukkan QR Code Ini ke Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)]),
                          child: QrImageView(data: generatedData, version: QrVersions.auto, size: 200.0),
                        ),
                        const SizedBox(height: 16),
                        // SUDAH DIPERBAIKI: Menggunakan TextAlign.center yang valid, bukan CenterTextAlign yang typo
                        Text(selectedMatkul, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text('Materi: $currentTopik', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DosenInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _DosenInfoTile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textGrey),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ]),
        ],
      ),
    );
  }
}