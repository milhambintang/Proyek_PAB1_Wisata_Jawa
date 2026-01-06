import 'package:flutter/material.dart';
import 'package:proyek_pab1_wisata_jawa/data/provinsi_data.dart';
import 'package:proyek_pab1_wisata_jawa/utils/app_colors.dart';
import 'package:proyek_pab1_wisata_jawa/models/tempat_models.dart';
import 'package:proyek_pab1_wisata_jawa/screens/search_screen.dart';
import 'package:proyek_pab1_wisata_jawa/screens/favorite_screen.dart';
import 'package:proyek_pab1_wisata_jawa/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedProvinsiIndex = 0;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
              title: const Text(
                "Wisata Jawa",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.primary,
              elevation: 0,
            )
          : null,
      body: _buildScreens()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.hint,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      _buildHomeContent(),
      const SearchScreen(),
      const FavoriteScreen(),
      const ProfileScreen(),
    ];
  }

  Widget _buildHomeContent() {
    // Return body-only widget (AppBar moved to main Scaffold)
    return SafeArea(
      child: Column(
        children: [
          // Provinsi Tabs
          Container(
            color: AppColors.primary.withOpacity(0.1),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  provinsis.length,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        selectedProvinsiIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selectedProvinsiIndex == index
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        provinsis[index].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selectedProvinsiIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedProvinsiIndex == index
                              ? AppColors.primary
                              : AppColors.subtitle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Grid Wisata
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + kBottomNavigationBarHeight),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: provinsis[selectedProvinsiIndex].tempat_models.length,
              itemBuilder: (context, index) {
                final tempat = provinsis[selectedProvinsiIndex].tempat_models[index];
                return _buildWisataCard(tempat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWisataCard(TempatModels tempat) {
  return Card(
    clipBehavior: Clip.antiAlias, // Tambahkan ini agar gambar tidak keluar border
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bagian Gambar (Tetap)
        SizedBox(
          height: 120, // Kurangi sedikit tingginya agar teks punya ruang
          child: Stack(              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    tempat.gambarUtama,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 140,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        tempat.isFavorite = !tempat.isFavorite;
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
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tempat.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: tempat.isFavorite ? AppColors.error : AppColors.hint,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // Bagian Informasi
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tempat.nama,
                  maxLines: 1, // Batasi 1 baris agar hemat ruang
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Expanded( // Gunakan Expanded agar deskripsi mengambil sisa ruang yang ada saja
                  child: Text(
                    tempat.deskripsi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                // Tombol Lihat Detail
                SizedBox(
                  width: double.infinity,
                  height: 30, // Tentukan tinggi tetap agar tidak overflow
                  child: ElevatedButton(
                    onPressed: () => _showDetailDialog(tempat),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, // Minimalisir padding
                    ),
                    child: const Text('Lihat Detail', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
                        _buildDetailRow(Icons.location_on, 'Alamat', tempat.alamat, ),
                        const SizedBox(height: 12),

                        // Jam Buka
                        _buildDetailRow(Icons.access_time, 'Jam Buka', tempat.jamBuka),
                        const SizedBox(height: 12),

                        // Harga Tiket
                        _buildDetailRow(Icons.local_offer, 'Harga Tiket', tempat.hargaTiket),
                        const SizedBox(height: 12),

                        // Fasilitas
                        _buildDetailRow(Icons.home, 'Fasilitas', tempat.fasilitas),
                        const SizedBox(height: 20),

                        // galeri gambar
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