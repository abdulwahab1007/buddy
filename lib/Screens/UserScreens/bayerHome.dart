

 // Still needed if GigDetails is used later
// import 'package:buddy/Models/gigModel.dart';
import 'package:buddy/Models/story_gig_model.dart';
import 'package:buddy/Screens/CreatorScreens/GigDetail/GigDetails.dart'; // Still needed if GigDetails is used later


import 'package:buddy/screens/UserScreens/bayerProfile.dart';
import 'package:buddy/screens/UserScreens/bayerOrderHistory.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/screens/UserScreens/bayerNotification.dart';
import 'package:buddy/screens/UserScreens/bayerSearch.dart';
import 'package:buddy/screens/chat/message.dart';
// Import new API services
import 'package:buddy/Backend/index.dart';
import 'package:flutter/material.dart';
import 'dart:math';


import 'package:shared_preferences/shared_preferences.dart';

class BayerHome extends StatefulWidget {
  const BayerHome({super.key});

  @override
  State<BayerHome> createState() => BayerHomeState();
}

class BayerHomeState extends State<BayerHome> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: const [
          HomePage(),
          BayerSearch(),
          BayerOrderHistory(),
          MessageScreen(),
          BayerProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: onNavTapped,
        elevation: 8,
        iconSize: 28,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: _buildHighlightedIcon('assets/icons/home.png', 0),
              label: ''),
          BottomNavigationBarItem(
              icon: _buildHighlightedIcon(
                  'assets/icons/search-interface-symbol.png', 1),
              label: ''),
          BottomNavigationBarItem(
              icon: _buildHighlightedIcon('assets/icons/clipboard.png', 2),
              label: ''),
          BottomNavigationBarItem(
              icon: _buildHighlightedIcon('assets/icons/chat.png', 3),
              label: ''),
          BottomNavigationBarItem(
              icon: _buildHighlightedIcon('assets/icons/user.png', 4),
              label: ''),
        ],
      ),
    );
  }

  Widget _buildHighlightedIcon(String assetPath, int index) {
    final isSelected = _selectedIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.green : Colors.black,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            assetPath,
            width: 24,
            height: 24,
          ),
        ),
        if (isSelected) const SizedBox(height: 4),
        if (isSelected)
          Text(
            _getLabelForIndex(index),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: ColorsContants.primaryColor,
            ),
          ),
      ],
    );
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Search';
      case 2:
        return 'Order';
      case 3:
        return 'Chat';
      case 4:
        return 'Profile';
      default:
        return '';
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userName = "Dummy user";
  List<Gigs> gigs = [];
  List<Story> stories = []; // Add this in your state

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchGigsFromApi();
    stories = StoriesGigsModel().stories ?? [];
  }

  Future<void> _fetchGigsFromApi() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name') ?? "User";

      // Use new API service to get buyer content (gigs and stories)
      final response = await BuyerService.getBuyerContent();
      
      if (response['success'] == true) {
        final data = response['data'];
        debugPrint("📦 Full JSON: $data");

        final storiesGigsModel = StoriesGigsModel.fromJson(data);

        setState(() {
          gigs = storiesGigsModel.gigs ?? [];
          stories = storiesGigsModel.stories ?? [];
          userName = name;
          isLoading = false;
        });
      } else {
        throw Exception(response['error'] ?? 'Failed to load content');
      }
    } catch (e) {
      debugPrint("❌ Fetch error: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load gigs: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Removed RefreshIndicator as no backend to refresh
      child: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Keep for scrollability
        slivers: [
          // App Bar with Greeting and Notification
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, $userName!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Find your perfect service',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BayerNotification()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/icons/notification.png',
                        width: 24,
                        height: 24,
                        color: ColorsContants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stories Section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Stories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorsContants.primaryColor,
                                    Colors.blue,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(Icons.person,
                                      color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'User ${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Gigs Section Title
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Popular Gigs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          // Gigs Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // No need for isLoading check here, as data is instant
                  // Show only first 4 gigs or all if less than 4
                  if (index < min(4, gigs.length)) {
                    final gig = gigs[index];
                    return _buildGigCard(gig);
                  }
                  return null; // Don't build if index out of bounds
                },
                childCount: min(4, gigs.length), // Directly use gigs.length
              ),
            ),
          ),

          // More Section
          if (gigs.length > 4) // Only show if there are more than 4 gigs
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: () {
                    final bayerHomeState =
                        context.findAncestorStateOfType<BayerHomeState>();
                    if (bayerHomeState != null) {
                      bayerHomeState.onNavTapped(1); // Navigate to Search page
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View More Gigs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorsContants.primaryColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: ColorsContants.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom Padding
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGigCard(Gigs gig) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GigDetails(
              gigId: gig.gigId ?? 0,
              index: gigs.indexOf(gig),
              onGigUpdated: (_, __) {
                // For dummy data, refresh is not needed
                // _loadGigs(); // REMOVED
              },
              onGigDeleted: (_) {
                // For dummy data, refresh is not needed
                // _loadGigs(); // REMOVED
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gig Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Image.network(
                  // Use the imageUrl directly as it's now a full dummy URL
                  // If you switch to local assets, change this to Image.asset
                  gig.mediaUrl.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Image Error: $error');
                    return Container(
                      color: Colors.grey[200],
                      child:
                          const Icon(Icons.image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),

            // Gig Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      gig.label.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '4.5', // Hardcoded for dummy
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Starting at ₹${gig.startingPrice.toString()}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: ColorsContants.primaryColor,
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


}
