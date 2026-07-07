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
  String? uploadedFileName; // Menyimpan nama file PDF yang diunggah

  // Data tiruan untuk simulasi tampilan list mahasiswa (Live Log)
  final List<Map<String, String>> mockDataScanMahasiswa = [
    {'nama': 'Ahmad Fauzi', 'nim': '123456781', 'waktu': '08:01 WIB', 'status': 'Hadir'},
    {'nama': 'Rian Hidayat', 'nim': '123456782', 'waktu': '08:03 WIB', 'status': 'Hadir'},
    {'nama': 'Siti Aminah', 'nim': '123456783', 'waktu': '--:-- WIB', 'status': 'Izin'},
    {'nama': 'Budi Santoso', 'nim': '123456784', 'waktu': '--:-- WIB', 'status': 'Sakit'},
    {'nama': 'Dedi Kurniawan', 'nim': '123456785', 'waktu': '--:-- WIB', 'status': 'Alpa'},
  ];

  // Data tiruan untuk mahasiswa yang mengajukan Izin/Sakit dan butuh validasi dosen
  final List<Map<String, dynamic>> mockPengajuanSurat = [
    {
      'id': 1,
      'nama': 'Siti Aminah',
      'nim': '123456783',
      'jenis': 'Izin',
      'alasan': 'Mengikuti lomba debat nasional mewakili kampus.',
      'file': 'Surat_Dispensasi_WD3.pdf'
    },
    {
      'id': 2,
      'nama': 'Budi Santoso',
      'nim': '123456784',
      'jenis': 'Sakit',
      'alasan': 'Gejala tifus dan harus bedrest total selama 3 hari.',
      'file': 'Surat_Dokter_Klinik.png'
    },
  ];

  // Fungsi simulasi untuk mengunggah PDF
  void _uploadPDF() {
    setState(() {
      uploadedFileName = "Materi_${selectedMatkul.replaceAll(' ', '_')}.pdf";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Berhasil mengunggah: $uploadedFileName'), backgroundColor: Colors.blue),
    );
  }

  // Fungsi untuk mengubah status mahasiswa secara manual di Live Log
  void _ubahStatusMahasiswa(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Ubah Status ${mockDataScanMahasiswa[index]['nama']}'),
          children: ['Hadir', 'Terlambat', 'Izin', 'Sakit', 'Alpa'].map((String status) {
            return SimpleDialogOption(
              onPressed: () {
                setState(() {
                  mockDataScanMahasiswa[index]['status'] = status;
                  if (status == 'Hadir' || status == 'Terlambat') {
                    mockDataScanMahasiswa[index]['waktu'] = '08:15 WIB (Manual)';
                  } else {
                    mockDataScanMahasiswa[index]['waktu'] = '--:-- WIB';
                  }
                });
                Navigator.pop(context);
              },
              child: Text(status),
            );
          }).toList(),
        );
      },
    );
  }

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
                  Navigator.pop(context); 
                  Navigator.pop(context); 
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
                  onPressed: () => _showLogoutConfirmation(context),
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

  void _akhiriPresensi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Icon(Icons.gavel_rounded, color: Colors.orangeAccent, size: 40),
              SizedBox(height: 14),
              Text('Akhiri Sesi Kuliah?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
            ],
          ),
          content: const Text(
            'QR Code akan dinonaktifkan and rekapitulasi absensi mahasiswa hari ini akan dikunci.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  generatedData = ''; 
                  _topikController.clear(); 
                  uploadedFileName = null;
                  SharedState.apakahDosenSudahIsiTopik = false; 
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sesi presensi kuliah telah ditutup dan dikunci!'), backgroundColor: Colors.orange),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Ya, Akhiri', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hadir': return Colors.green;
      case 'Terlambat': return Colors.amber;
      case 'Izin': return Colors.orange;
      case 'Sakit': return Colors.blue;
      case 'Alpa': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  void dispose() {
    _topikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalAlpa = mockDataScanMahasiswa.where((m) => m['status'] == 'Alpa').length;
    int totalHadir = mockDataScanMahasiswa.where((m) => m['status'] == 'Hadir' || m['status'] == 'Terlambat').length;
    int totalIzin = mockDataScanMahasiswa.where((m) => m['status'] == 'Izin').length;
    int totalSakit = mockDataScanMahasiswa.where((m) => m['status'] == 'Sakit').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard Dosen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        // INTEGRASI: Tombol Verifikasi Berkas Ber-Badge Notifikasi
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${mockPengajuanSurat.length}'), 
              backgroundColor: Colors.redAccent,
              isLabelVisible: mockPengajuanSurat.isNotEmpty,
              child: const Icon(Icons.assignment_turned_in_rounded, color: Colors.white, size: 24),
            ),
            tooltip: 'Validasi Surat Izin/Sakit',
            onPressed: () async {
              // Menuju halaman validasi dan membawa fungsi callback update status
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ValidasiDokumenScreen(
                    daftarPengajuan: mockPengajuanSurat,
                    onActionProcessed: (String nim, String jenis, bool disetujui) {
                      setState(() {
                        // Cari index mahasiswa di live log utama berdasarkan NIM
                        int idx = mockDataScanMahasiswa.indexWhere((m) => m['nim'] == nim);
                        if (idx != -1) {
                          if (disetujui) {
                            mockDataScanMahasiswa[idx]['status'] = jenis; // Set 'Izin' atau 'Sakit'
                          } else {
                            mockDataScanMahasiswa[idx]['status'] = 'Alpa'; // Tetap Terkunci Alpa
                          }
                        }
                        // Hapus dari antrean pengajuan surat
                        mockPengajuanSurat.removeWhere((p) => p['nim'] == nim);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Profil Dosen
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
            
            // Dropdown Mata Kuliah
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
            
            // Input Topik Bahasan
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
            const SizedBox(height: 10),

            // Tombol Upload File PDF Materi
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _uploadPDF,
                  icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                  label: const Text('Upload File PDF Materi'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                if (uploadedFileName != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      uploadedFileName!,
                      style: const TextStyle(fontSize: 13, color: Colors.green, fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
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
                        Text(selectedMatkul, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text('Materi: $currentTopik', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
                        ),
                        
                        // Tombol Aksi Menutup Sesi Manual di bawah QR Code
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _akhiriPresensi,
                            icon: const Icon(Icons.lock_clock_rounded, color: Colors.white),
                            label: const Text('Akhiri Sesi Presensi (Manual)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),
                        
                        // Live Log Daftar Hadir Mahasiswa & Rekapitulasi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Live Log Daftar Hadir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Fitur Live Log lengkap sedang memuat data terbaru...')),
                                );
                              },
                              icon: const Icon(Icons.sync_rounded, size: 16, color: AppColors.primary),
                              label: const Text('Refresh Log', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildDosenStatBox('Alpa', totalAlpa.toString(), Colors.red),
                            _buildDosenStatBox('Hadir', totalHadir.toString(), Colors.green),
                            _buildDosenStatBox('Izin', totalIzin.toString(), Colors.orange),
                            _buildDosenStatBox('Sakit', totalSakit.toString(), Colors.blue),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // List Log Absensi Mahasiswa
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mockDataScanMahasiswa.length,
                          itemBuilder: (context, index) {
                            final mahasiswa = mockDataScanMahasiswa[index];
                            Color statusColor = _getStatusColor(mahasiswa['status']!);
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade100)),
                              color: Colors.white,
                              elevation: 0,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: statusColor.withOpacity(0.1),
                                  child: Icon(Icons.person_outline_rounded, color: statusColor),
                                ),
                                title: Text(mahasiswa['nama']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                                subtitle: Text('NIM: ${mahasiswa['nim']} • Scan: ${mahasiswa['waktu']}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                                trailing: InkWell(
                                  onTap: () => _ubahStatusMahasiswa(index), 
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(mahasiswa['status']!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.edit_rounded, color: Colors.white, size: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDosenStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w500)),
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


// ==========================================
// SCREEN HALAMAN VALIDASI DOKUMEN MAHASISWA
// ==========================================
class ValidasiDokumenScreen extends StatelessWidget {
  final List<Map<String, dynamic>> daftarPengajuan;
  final Function(String nim, String jenis, bool disetujui) onActionProcessed;

  const ValidasiDokumenScreen({
    super.key, 
    required this.daftarPengajuan, 
    required this.onActionProcessed
  });

  void _previewDokumen(BuildContext context, String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Preview Dokumen Bukti', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Container(
          width: double.maxFinite,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                fileName.contains('.pdf') ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
                size: 50,
                color: fileName.contains('.pdf') ? Colors.redAccent : Colors.blueAccent,
              ),
              const SizedBox(height: 12),
              Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              const Text('[ Simulasi Dokumen Lampiran ]', style: TextStyle(color: AppColors.textGrey, fontSize: 11, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Validasi Izin & Sakit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: daftarPengajuan.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_rounded, size: 70, color: Colors.green.withOpacity(0.4)),
                  const SizedBox(height: 12),
                  const Text('Semua Beres!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                  const Text('Tidak ada dokumen masuk yang perlu diperiksa.', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: daftarPengajuan.length,
              itemBuilder: (context, index) {
                final item = daftarPengajuan[index];
                final bool isSakit = item['jenis'] == 'Sakit';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                                Text('NIM: ${item['nim']}', style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSakit ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['jenis'].toUpperCase(),
                                style: TextStyle(color: isSakit ? Colors.blue : Colors.orange, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            )
                          ],
                        ),
                        const Divider(height: 24),
                        const Text('Alasan Ketidakhadiran:', style: TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('"${item['alasan']}"', style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: AppColors.textDark)),
                        const SizedBox(height: 14),
                        
                        // Tombol Cek Berkas Bukti Fisik
                        InkWell(
                          onTap: () => _previewDokumen(context, item['file']),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.attach_file_rounded, size: 18, color: isSakit ? Colors.blue : Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(child: Text(item['file'], style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500))),
                                const Icon(Icons.visibility_outlined, size: 16, color: AppColors.textGrey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Tombol Tindakan Dosen (Tolak / Setujui)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  onActionProcessed(item['nim'], item['jenis'], false);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Pengajuan ${item['nama']} ditolak. Status tetap Alpa.'), backgroundColor: Colors.redAccent),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.redAccent),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Tolak', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  onActionProcessed(item['nim'], item['jenis'], true);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Status ${item['nama']} berhasil diubah menjadi ${item['jenis']}.'), backgroundColor: Colors.green),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Setujui', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}