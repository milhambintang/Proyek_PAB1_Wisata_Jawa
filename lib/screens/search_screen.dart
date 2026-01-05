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
    return Card(
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
    );
  }
}
