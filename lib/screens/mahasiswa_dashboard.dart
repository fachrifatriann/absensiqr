import 'package:flutter/material.dart';
import '../constants.dart';
import 'share_state.dart';
import 'scan_qr_screen.dart';
import 'login_screen.dart';

class MahasiswaDashboard extends StatefulWidget {
  const MahasiswaDashboard({super.key});

  @override
  State<MahasiswaDashboard> createState() => _MahasiswaDashboardState();
}

class _MahasiswaDashboardState extends State<MahasiswaDashboard> {
  // REVISI KONDISI KHUSUS (STATE UI FASE 4)
  // Ubah ke true jika ingin mensimulasikan semua absensi hari ini selesai
  bool semuaAbsensiSelesai = false;

  // Mengubah mock data menjadi non-const agar bisa ditambah secara dinamis saat pengajuan sukses
  final List<Map<String, dynamic>> mockHistoryData = [
    {
      'date': '24 Juni 2026', 
      'time': '08:01 WIB', 
      'matkul': 'Pemrograman Mobile (Flutter)', 
      'status': 'Hadir',
      'topik': 'Integrasi QR Scanner & Manajemen State Lokal'
    },
    {
      'date': '23 Juni 2026', 
      'time': '10:46 WIB', 
      'matkul': 'Rekayasa Perangkat Lunak', 
      'status': 'Hadir',
      'topik': 'Perancangan Diagram DFD, ERD, dan Dokumen SRS'
    },
    {
      'date': '17 Juni 2026', 
      'time': '--:-- WIB', 
      'matkul': 'Pemrograman Mobile (Flutter)', 
      'status': 'Izin',
      'topik': 'Pengenalan Konstruktor Widget & Implementasi GridView'
    },
    {
      'date': '14 April 2026', 
      'time': '--:-- WIB', 
      'matkul': 'Kecerdasan Buatan', 
      'status': 'Alpa',
      'topik': 'Implementasi Convolutional Neural Network (CNN) untuk Computer Vision'
    },
    {
      'date': '10 April 2026', 
      'time': '--:-- WIB', 
      'matkul': 'Kecerdasan Buatan', 
      'status': 'Sakit',
      'topik': 'Pengenalan Computer Vision'
    },
  ];

  // Variabel penampung state form pengajuan
  String _selectedJenisKeterangan = 'Izin';
  String _selectedMatkulKeterangan = 'Pemrograman Mobile (Flutter)';
  final TextEditingController _alasanController = TextEditingController();
  String _namaFileBukti = 'Belum ada file dipilih';

  void _showLogoutDialog(BuildContext context) {
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
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun Mahasiswa?',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
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

  void _showProfileBottomSheet(BuildContext context) {
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
                child: CircleAvatar(radius: 44, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: const Icon(Icons.person, size: 55, color: AppColors.primary)),
              ),
              const SizedBox(height: 14),
              const Text('Mahasiswa Informatika', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: const Text('NIM: 123456789', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                child: const Column(
                  children: [
                    _ProfileInfoTile(icon: Icons.school_outlined, title: 'Program Studi', value: 'Teknik Informatika'),
                    _ProfileInfoTile(icon: Icons.account_balance_outlined, title: 'Fakultas', value: 'Teknik dan Ilmu Komputer'),
                    _ProfileInfoTile(icon: Icons.calendar_today_outlined, title: 'Angkatan', value: '2024 / Reguler'),
                    _ProfileInfoTile(icon: Icons.verified_user_outlined, title: 'Status Mahasiswa', value: 'Aktif Akademik'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
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

  void _showPengajuanBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.vertical(top: Radius.circular(28))
              ),
              padding: EdgeInsets.only(
                left: 24.0, 
                right: 24.0, 
                top: 16.0, 
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.0
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),
                  const Text('Form Pengajuan Izin / Sakit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  const Text('Unggah berkas bukti ketidakhadiran kuliah untuk divalidasi oleh dosen.', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                  const SizedBox(height: 20),
                  
                  const Text('Jenis Keterangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedJenisKeterangan,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: ['Izin', 'Sakit'].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
                    onChanged: (val) => setModalState(() => _selectedJenisKeterangan = val!),
                  ),
                  const SizedBox(height: 16),

                  const Text('Mata Kuliah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedMatkulKeterangan,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: ['Pemrograman Mobile (Flutter)', 'Rekayasa Perangkat Lunak']
                        .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                        .toList(),
                    onChanged: (val) => setModalState(() => _selectedMatkulKeterangan = val!),
                  ),
                  const SizedBox(height: 16),

                  const Text('Alasan Tambahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _alasanController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Mengikuti dinas kerja, Demam tinggi, dll.',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Dokumen Bukti (.jpg, .png, .pdf)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setModalState(() {
                            _namaFileBukti = _selectedJenisKeterangan == 'Sakit' 
                                ? 'Surat_Keterangan_Dokter_Klinik.pdf' 
                                : 'Surat_Dispensasi_Kegiatan.png';
                          });
                        },
                        icon: const Icon(Icons.cloud_upload_outlined, size: 18, color: Colors.white),
                        label: const Text('Pilih Berkas', style: TextStyle(color: Colors.white, fontSize: 13)),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _namaFileBukti, 
                          style: TextStyle(fontSize: 13, color: _namaFileBukti.contains('Belum') ? Colors.red : Colors.green, fontWeight: FontWeight.w500),
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_namaFileBukti.contains('Belum')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gagal! Harap unggah dokumen bukti fisik terlebih dahulu.'), backgroundColor: Colors.orange),
                          );
                          return;
                        }

                        setState(() {
                          mockHistoryData.insert(0, {
                            'date': 'Hari Ini (2026)', 
                            'time': '--:-- WIB', 
                            'matkul': _selectedMatkulKeterangan, 
                            'status': _selectedJenisKeterangan,
                            'topik': _alasanController.text.isNotEmpty ? _alasanController.text : 'Pengajuan berkas online'
                          });
                        });

                        Navigator.pop(context); 
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sukses mengirimkan data $_selectedJenisKeterangan! Status menunggu konfirmasi dosen.'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        _alasanController.clear();
                        _namaFileBukti = 'Belum ada file dipilih';
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Kirim Pengajuan Keterangan', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToHistory(BuildContext context, String statusFilter) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryDetailScreen(statusFilter: statusFilter, historyList: mockHistoryData)));
  }

  void _downloadMateriPDF(String matkul) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mengunduh materi PDF untuk $matkul...'), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalHadir = mockHistoryData.where((e) => e['status'] == 'Hadir').length;
    int totalIzin = mockHistoryData.where((e) => e['status'] == 'Izin').length;
    int totalSakit = mockHistoryData.where((e) => e['status'] == 'Sakit').length;
    int totalAlpa = mockHistoryData.where((e) => e['status'] == 'Alpa').length;

    int totalSesi = totalHadir + totalIzin + totalSakit + totalAlpa;
    double persentaseKehadiran = totalSesi > 0 ? (totalHadir / totalSesi) * 100 : 0.0;
    bool apakahAman = persentaseKehadiran >= 75.0;

    String materiFlutter = SharedState.apakahDosenSudahIsiTopik && SharedState.matkulAktif == 'Pemrograman Mobile (Flutter)'
        ? SharedState.topikHariIni
        : 'Dosen belum mengisi topik kuliah hari ini.';

    String materiRPL = SharedState.apakahDosenSudahIsiTopik && SharedState.matkulAktif == 'Rekayasa Perangkat Lunak'
        ? SharedState.topikHariIni
        : 'Belum ada catatan materi perkuliahan.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard Kehadiran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showProfileBottomSheet(context),
                  child: const Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: Icon(Icons.person, size: 35, color: Colors.white)),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mahasiswa Informatika', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                SizedBox(height: 4),
                                Text('NIM: 123456789', style: TextStyle(color: AppColors.textGrey)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: AppColors.textGrey),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    _buildStatCard(context, totalAlpa.toString(), 'Alpa', Colors.red),
                    _buildStatCard(context, totalHadir.toString(), 'Hadir', Colors.green),
                    _buildStatCard(context, totalIzin.toString(), 'Izin', Colors.orange),
                    _buildStatCard(context, totalSakit.toString(), 'Sakit', Colors.blue),
                  ],
                ),
                
                const SizedBox(height: 10),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          apakahAman ? Icons.verified_rounded : Icons.warning_amber_rounded,
                          color: apakahAman ? Colors.green : Colors.redAccent,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                              children: [
                                const TextSpan(text: 'Persentase Kehadiran: '),
                                TextSpan(
                                  text: '${persentaseKehadiran.toStringAsFixed(0)}% ',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: apakahAman ? Colors.green : Colors.redAccent),
                                ),
                                TextSpan(
                                  text: apakahAman ? '(Aman / ≥75%)' : '(Peringatan / <75%)',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: apakahAman ? Colors.green : Colors.redAccent),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text('Jadwal Kuliah Hari Ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                
                _buildMatkulCard('Pemrograman Mobile (Flutter)', '08:00 - 10:30 WIB', 'Ruang LAB 03', true, topikMateri: materiFlutter),
                _buildMatkulCard('Rekayasa Perangkat Lunak', '10:45 - 13:15 WIB', 'Ruang Teori 02', false, topikMateri: materiRPL),
                const SizedBox(height: 110), 
              ],
            ),
          ),
          
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => _showPengajuanBottomSheet(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.orange.withValues(alpha: 0.05),
                      ),
                      icon: const Icon(Icons.assignment_late_outlined, color: Colors.orange, size: 20),
                      label: const Text('Ajukan Izin/Sakit', style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // REVISI TOMBOL SCAN BERUBAH MENJADI ABU-ABU (STATE UI FASE 4)
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: semuaAbsensiSelesai 
                          ? null 
                          : () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanQrScreen()));
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: semuaAbsensiSelesai ? Colors.grey.shade400 : AppColors.primary, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
                        elevation: semuaAbsensiSelesai ? 0 : 2,
                      ),
                      icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                      label: Text(
                        semuaAbsensiSelesai ? 'Semua Absensi Hari Ini Selesai' : 'Scan QR Absen', 
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => _navigateToHistory(context, label),
        borderRadius: BorderRadius.circular(12),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    const Icon(Icons.keyboard_arrow_right, size: 14, color: AppColors.textGrey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatkulCard(String title, String time, String room, bool isDone, {required String topikMateri}) {
    bool apakahMateriKosongAtauBelumAda = topikMateri.contains('belum') || topikMateri.contains('Belum');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: isDone ? const Color(0xffE8F5E9) : const Color(0xffE8F4FF), child: Icon(isDone ? Icons.check_circle : Icons.book, color: isDone ? Colors.green : AppColors.primary)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text('$time • $room', style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                    ],
                  ),
                ),
                Text(isDone ? 'Sudah Absen' : 'Belum Absen', style: TextStyle(color: isDone ? Colors.green : AppColors.textGrey, fontWeight: FontWeight.bold, fontSize: 13))
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.menu_book_outlined, size: 16, color: apakahMateriKosongAtauBelumAda ? AppColors.textGrey : Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Materi: $topikMateri',
                    style: TextStyle(
                      fontSize: 13, 
                      fontWeight: FontWeight.w500,
                      color: apakahMateriKosongAtauBelumAda ? AppColors.textGrey : Colors.blueAccent,
                      fontStyle: apakahMateriKosongAtauBelumAda ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
                if (isDone && !apakahMateriKosongAtauBelumAda) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _downloadMateriPDF(title),
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 24),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _ProfileInfoTile({required this.icon, required this.title, required this.value});

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

class HistoryDetailScreen extends StatelessWidget {
  final String statusFilter;
  final List<Map<String, dynamic>> historyList;
  const HistoryDetailScreen({super.key, required this.statusFilter, required this.historyList});

  @override
  Widget build(BuildContext context) {
    final filteredList = historyList.where((item) => item['status'] == statusFilter).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Riwayat Kategori: $statusFilter', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: AppColors.primary, iconTheme: const IconThemeData(color: Colors.white)),
      body: filteredList.isEmpty
          ? Center(child: Text('Tidak ada riwayat untuk kategori $statusFilter', style: const TextStyle(color: AppColors.textGrey, fontSize: 16)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: statusFilter == 'Hadir' 
                          ? Colors.green.withValues(alpha: 0.1) 
                          : statusFilter == 'Izin' 
                              ? Colors.orange.withValues(alpha: 0.1) 
                              : statusFilter == 'Sakit'
                                  ? Colors.blue.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                      child: Icon(
                        statusFilter == 'Hadir' 
                            ? Icons.check_circle_outline 
                            : statusFilter == 'Izin' 
                                ? Icons.info_outline 
                                : statusFilter == 'Sakit'
                                    ? Icons.healing_outlined
                                    : Icons.cancel_outlined, 
                        color: statusFilter == 'Hadir' ? Colors.green : statusFilter == 'Izin' ? Colors.orange : statusFilter == 'Sakit' ? Colors.blue : Colors.red
                      ),
                    ),
                    title: Text(item['matkul'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text('Keterangan: ${item['topik']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xff1E90FF))),
                        const SizedBox(height: 6),
                        Row(children: [const Icon(Icons.calendar_month, size: 14, color: AppColors.textGrey), const SizedBox(width: 4), Text(item['date'], style: const TextStyle(fontSize: 12, color: AppColors.textDark))]),
                        const SizedBox(height: 2),
                        Row(children: [const Icon(Icons.access_time, size: 14, color: AppColors.textGrey), const SizedBox(width: 4), Text('Jam Absen: ${item['time']}', style: const TextStyle(fontSize: 12, color: AppColors.textGrey))]),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusFilter == 'Hadir' ? Colors.green : statusFilter == 'Izin' ? Colors.orange : statusFilter == 'Sakit' ? Colors.blue : Colors.red, 
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text(statusFilter, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}