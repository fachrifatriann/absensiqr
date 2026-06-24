class MatakuliahModel {
  final String kodeMatkul;
  final String namaMatkul;
  final String dosen;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;

  MatakuliahModel({
    required this.kodeMatkul,
    required this.namaMatkul,
    required this.dosen,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
  });

  factory MatakuliahModel.fromJson(Map<String, dynamic> json) {
    return MatakuliahModel(
      kodeMatkul: json['kode_matkul'] ?? '',
      namaMatkul: json['nama_matkul'] ?? '',
      dosen: json['dosen'] ?? '',
      jamMulai: json['jam_mulai'] ?? '',
      jamSelesai: json['jam_selesai'] ?? '',
      ruangan: json['ruangan'] ?? '',
    );
  }
}