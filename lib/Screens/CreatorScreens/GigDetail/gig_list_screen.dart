import 'dart:developer';
import 'package:buddy/Backend/api/gigs_service.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:buddy/Models/gigModel.dart';
import 'package:buddy/Screens/CreatorScreens/create_gig_screen.dart';
import 'package:buddy/Screens/CreatorScreens/GigDetail/gigDetails.dart';
import 'package:buddy/res/contants/colors_contants.dart';

class GigListScreen extends StatefulWidget {
  const GigListScreen({Key? key}) : super(key: key);

  @override
  State<GigListScreen> createState() => _GigListScreenState();
}

class _GigListScreenState extends State<GigListScreen> {
  Future<List<GigModel>>? _gigsFuture;

  @override
  void initState() {
    super.initState();
    _loadGigs();
  }

  Future<void> _loadGigs() async {
    try {
      setState(() {
        _gigsFuture = fetchGigs();
      });
    } catch (e) {
      log("Error loading gigs: $e");
    }
  }

  Future<void> _refreshGigs() async {
    await _loadGigs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorsContants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.work_outline,
                      color: ColorsContants.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "My Gigs",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: ColorsContants.primaryColor,
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateGigScreen(),
                        ),
                      ).then((_) => _refreshGigs());
                    },
                  ),
                ],
              ),
            ),

            // Gig List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshGigs,
                color: ColorsContants.primaryColor,
                child: FutureBuilder<List<GigModel>>(
                  future: _gigsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    size: 60, color: Colors.red[300]),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: _refreshGigs,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorsContants.primaryColor,
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final gigs = snapshot.data ?? [];

                    if (gigs.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.work_off_outlined,
                                    size: 60, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                const Text(
                                  'No gigs yet',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Create your first gig to start earning',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: gigs.length,
                      itemBuilder: (context, index) {
                        final gig = gigs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GigDetails(
                                  // startingPrice: gig.price,
                                  gigId: gig.id,
                                  index: index,
                                  onGigUpdated: (_, __) => _refreshGigs(),
                                  onGigDeleted: (_) => _refreshGigs(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: CachedNetworkImage(
                                    imageUrl: gig.media_path.startsWith('http')
                                        ? gig.media_path
                                        : 'https://buddy.nexltech.com/storage/${gig.media_path}',
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Starting at \$${gig.price}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsContants.primaryColor,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: ColorsContants.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 16,
                                                  color: ColorsContants
                                                      .primaryColor,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "4.8",
                                                  style: TextStyle(
                                                    color: ColorsContants
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
