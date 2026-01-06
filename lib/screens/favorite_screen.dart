import 'package:flutter/material.dart';
import 'package:proyek_pab1_wisata_jawa/data/provinsi_data.dart';
import 'package:proyek_pab1_wisata_jawa/utils/app_colors.dart';
import 'package:proyek_pab1_wisata_jawa/models/tempat_models.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<TempatModels> _getFavorites() {
    List<TempatModels> favorites = [];
    for (var provinsi in provinsis) {
      for (var tempat in provinsi.tempat_models) {
        if (tempat.isFavorite) {
          favorites.add(tempat);
        }
      }
    }
    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorit Saya',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppColors.hint,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada wisata favorit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.title,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tambahkan wisata ke favorit untuk melihatnya di sini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.subtitle,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final tempat = favorites[index];
                return _buildFavoriteCard(tempat);
              },
            ),
    );
  }

Widget _buildFavoriteCard(TempatModels tempat) {
    return Card(
      // Tambahkan clipBehavior agar gambar tetap di dalam radius
      clipBehavior: Clip.antiAlias, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell( // Gunakan InkWell agar ada efek sentuhan
        onTap: () => _showDetailDialog(tempat),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama (Tinggi dikurangi sedikit menjadi 120)
            SizedBox(
              height: 120,
              child: Stack(
                children: [
                  Image.network(
                    tempat.gambarUtama,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surface,
                      child: const Center(child: Icon(Icons.image_not_supported)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: AppColors.error, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Informasi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tempat.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.title,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        tempat.deskripsi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.subtitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tombol Hapus (Dibuat lebih ringkas)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tempat.isFavorite = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${tempat.nama} dihapus')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          minimumSize: const Size(0, 32), // Tinggi tombol tetap
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Hapus', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(TempatModels tempat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Close Button dan Favorite Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Expanded(
                              child: Center(
                                child: Text(
                                  tempat.nama,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.title,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),

                        // Gambar Utama dengan Tombol Favorit di Detail
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                tempat.gambarUtama,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 250,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.surface,
                                    height: 250,
                                    child: const Center(
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    tempat.isFavorite = !tempat.isFavorite;
                                    setState(() {});
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        tempat.isFavorite
                                            ? '${tempat.nama} ditambahkan ke favorit'
                                            : '${tempat.nama} dihapus dari favorit',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    tempat.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: tempat.isFavorite
                                        ? AppColors.error
                                        : AppColors.hint,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Deskripsi
                        Text(
                          'Deskripsi',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.title,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tempat.deskripsi,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.subtitle,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Alamat
                        _buildDetailRow(Icons.location_on, 'Alamat', tempat.alamat),
                        const SizedBox(height: 12),

                        // Jam Buka
                        _buildDetailRow(Icons.access_time, 'Jam Buka', tempat.jamBuka),
                        const SizedBox(height: 12),

                        // Harga Tiket
                        _buildDetailRow(Icons.local_offer, 'Harga Tiket', tempat.hargaTiket),
                        const SizedBox(height: 12),

                        // Fasilitas
                        _buildDetailRow(Icons.home, 'Fasilitas', tempat.fasilitas),
                        const SizedBox(height: 16),

                        // Galeri Gambar
                        Text(
                          'Galeri Gambar',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.title,
                          ),
                        ),
                        const SizedBox(height: 8),
                        tempat.gambarGaleri.isEmpty
                            ? Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Tidak ada galeri gambar',
                                    style: TextStyle(
                                      color: AppColors.subtitle,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tempat.gambarGaleri.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          tempat.gambarGaleri[index],
                                          width: 180,
                                          height: 180,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 180,
                                              height: 180,
                                              color: AppColors.surface,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: AppColors.hint,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.title,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.subtitle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
