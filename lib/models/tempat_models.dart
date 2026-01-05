class TempatModels {
  final String nama;
  final String alamat;
  final String jamBuka;
  final String hargaTiket;
  final String deskripsi;
  final String gambarUtama;
  final String fasilitas;
  final List<String> gambarGaleri;
  bool isFavorite;

  TempatModels({
    required this.nama,
    this.alamat = '',
    this.jamBuka = '',
    this.hargaTiket = '',
    this.deskripsi = '',
    this.gambarUtama = '',
    this.fasilitas = '',
    this.gambarGaleri = const [],
    this.isFavorite = false,
  });
}