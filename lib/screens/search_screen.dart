import 'package:flutter/material.dart';
import 'package:proyek_pab1_wisata_jawa/data/provinsi_data.dart';
import 'package:proyek_pab1_wisata_jawa/utils/app_colors.dart';
import 'package:proyek_pab1_wisata_jawa/models/tempat_models.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TempatModels> searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults = [];
        for (var provinsi in provinsis) {
          for (var tempat in provinsi.tempat_models) {
            if (tempat.nama.toLowerCase().contains(query.toLowerCase()) ||
                tempat.deskripsi.toLowerCase().contains(query.toLowerCase())) {
              searchResults.add(tempat);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari Wisata',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary.withOpacity(0.1),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Cari tempat wisata...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Search Results
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchController.text.isEmpty
                              ? Icons.search
                              : Icons.search_off,
                          size: 64,
                          color: AppColors.hint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Mulai cari tempat wisata'
                              : 'Tidak ada hasil pencarian',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.subtitle,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final tempat = searchResults[index];
                      return _buildSearchResultCard(tempat);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(TempatModels tempat) {
    return GestureDetector(
      onTap: () => _showDetailDialog(tempat),
      child: Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Row(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              tempat.gambarUtama,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(Icons.image_not_supported),
                  ),
                );
              },
            ),
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tempat.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.title,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tempat.deskripsi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Favorite Button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
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
              icon: Icon(
                tempat.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: tempat.isFavorite ? AppColors.error : AppColors.hint,
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
                                    tempat.isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: tempat.isFavorite ? AppColors.error : AppColors.hint,
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
                                          errorBuilder: (context, error, stackTrace) {
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
