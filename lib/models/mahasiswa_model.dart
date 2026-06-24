class MahasiswaModel {
  final String nim;
  final String nama;
  final String prodi;
  final String fakultas;

  MahasiswaModel({
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.fakultas,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      nim: json['nim'] ?? '',
      nama: json['nama'] ?? '',
      prodi: json['prodi'] ?? '',
      fakultas: json['fakultas'] ?? '',
    );
  }
}