
import 'package:buddy/Backend/index.dart';
import 'package:buddy/Models/gigModel.dart';
import 'package:buddy/screens/CreatorScreens/creatorProfile.dart';
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/Screens/UserScreens/bayerHome.dart';

// import 'package:buddy/Backend/api_service.dart' as api_service;
import 'package:buddy/Screens/CreatorScreens/GigDetail/GigDetails.dart';
//import 'package:buddy/screens/user_profile.dart'; // Adjust path if needed

class BayerSearch extends StatefulWidget {
  const BayerSearch({super.key});

  @override
  State<BayerSearch> createState() => _BayerSearchState();
}

class _BayerSearchState extends State<BayerSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<GigModel> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Use new API service to search services
      final response = await BuyerService.searchServices(keyword: query);
      
      if (response['success'] == true) {
        final data = response['data'] as List<dynamic>;
        final results = data.map((json) => GigModel.fromJson(json)).toList();
        
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      } else {
        throw Exception(response['error'] ?? 'Search failed');
      }
    } catch (e) {
      setState(() {
        _error = 'Error searching gigs: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    // Find the nearest ancestor BayerHome widget and access its state
                    final bayerHomeState =
                        context.findAncestorStateOfType<BayerHomeState>();
                    if (bayerHomeState != null) {
                      bayerHomeState.onNavTapped(0);
                    }
                  },
                ),
                // Search Bar
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for services...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        _performSearch(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 48, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      )
                    : _searchResults.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search,
                                    size: 48, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                      ? 'Start typing to search'
                                      : 'No results found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final gig = _searchResults[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GigDetails(
                                          gigId: gig.id,
                                          index: index,
                                          onGigUpdated: (_, __) {
                                            _performSearch(
                                                _searchController.text);
                                          },
                                          onGigDeleted: (_) {
                                            _performSearch(
                                                _searchController.text);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Gig Image
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Image.network(
                                            'https://buddy.nexltech.com/public/storage/gigs/${gig.media_path}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  size: 40,
                                                  color: Colors.grey[400],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),

                                      // Gig Details
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              gig.title,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              gig.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      size: 16,
                                                      color: Colors.amber,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '4.5',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'Starting at ₹${gig.price}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorsContants
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String title;
  final String creator;
  final String description;
  final String category;
  final double rating;

  const ServiceTile({
    super.key,
    required this.title,
    required this.creator,
    required this.description,
    required this.category,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧑‍🎨 Avatar and Name on Top
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CreatorProfile()));
              },
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/avature.png'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "@$creator",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ColorsContants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorsContants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🎯 Title and Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: ColorsContants.primaryColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(rating.toString(),
                        style: const TextStyle(fontSize: 13)),
                  ],
                )
              ],
            ),

            const SizedBox(height: 8),

            // 📝 Description
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
