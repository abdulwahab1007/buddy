


import 'package:buddy/Models/gigModel.dart';


import 'package:buddy/screens/CreatorScreens/creatorNotification.dart';
import 'package:buddy/screens/CreatorScreens/creatorOrderStatus.dart';
import 'package:buddy/screens/CreatorScreens/creatorProfile.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/screens/chat/message.dart';
import 'package:flutter/material.dart';
import 'package:buddy/Models/StoryModel.dart';
import 'package:buddy/Screens/CreatorScreens/GigDetail/gig_list_screen.dart';
import 'package:buddy/Screens/CreatorScreens/Earnings/earnings_detail_screen.dart';

// Import the GigModel from the details screen (ensure this path is correct)
 // This should contain your updated GigModel
// Import for story functionality
import 'package:buddy/screens/CreatorScreens/Story/StoryViewScreen.dart';
import 'package:buddy/screens/CreatorScreens/Story/AddStoryScreen.dart';

// Import new API services
import 'package:buddy/Backend/index.dart';

class CreatorHome extends StatefulWidget {
  const CreatorHome({super.key});

  @override
  State<CreatorHome> createState() => _CreatorHomeState();
}

class _CreatorHomeState extends State<CreatorHome>
    with SingleTickerProviderStateMixin {
  String name = "";
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late TabController _tabController;

  bool _isLoadingGigs = false;
  String? _errorMessage;
  List<GigModel> gigData = []; // State to store any error message

  // Story data model (remains static for now as per your request)
  List<StoryModel> stories = [
    StoryModel(
      username: "You",
      imageUrl: "assets/avature.png",
      hasStory: false,
      isViewed: false,
      storyItems: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchGigs();
    _loadUserData(); // Call the API to fetch gigs when the screen initializes
  }

  Future<void> _loadUserData() async {
    try {
      // Use new API service to get creator profile
      final response = await CreatorService.getProfile();
      
      if (response['success'] == true) {
        final profileData = response['data'];
        setState(() {
          name = profileData['name'] ?? 'Guest';
        });
      } else {
        setState(() {
          name = 'Guest';
        });
      }
    } catch (e) {
      setState(() {
        name = 'Guest';
      });
    }
  }

  // Method to fetch gigs from the API
  Future<void> _fetchGigs() async {
    setState(() {
      _isLoadingGigs = true;
      _errorMessage = null;
    });

    try {
      // Use new API service to get creator gigs
      final response = await CreatorService.getGigs();
      
      if (response['success'] == true) {
        final data = response['data'] as List<dynamic>;
        final fetchedGigs = data.map((json) => GigModel.fromJson(json)).toList();
        
        setState(() {
          gigData = fetchedGigs;
          _isLoadingGigs = false;
          debugPrint("Fetched Gigs: $gigData");
        });
      } else {
        throw Exception(response['error'] ?? 'Failed to load gigs');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load gigs: ${e.toString()}";
        _isLoadingGigs = false;
      });

      // ✅ Show Snackbar safely
      if (_errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
    }
  }

  // Callback function to update gig data (e.g., after editing a gig)
  void updateGigData(int index, GigModel updatedGig) {
    setState(() {
      if (index >= 0 && index < gigData.length) {
        gigData[index] = updatedGig;
      }
    });
  }

  // New callback function to delete gig data
  void deleteGigData(int index) {
    setState(() {
      if (index >= 0 && index < gigData.length) {
        gigData.removeAt(index);
      }
    });
    // Show a confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Gig deleted successfully'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // This is just a placeholder for undo functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Undo is not implemented yet')),
            );
          },
        ),
      ),
    );
  }

  // Function to add a new story
  void addNewStory(StoryItem newStory) {
    setState(() {
      stories[0].storyItems.add(newStory);
      stories[0].hasStory = true;
      stories[0].isViewed = false;
    });
  }

  // Function to mark a story as viewed
  void markStoryAsViewed(int index) {
    setState(() {
      stories[index].isViewed = true;
    });
  }

  void _onNavTapped(int index) {
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
        children: [
          HomePage(
            name: name,
            gigData: gigData,
            onGigUpdated: updateGigData,
            onGigDeleted: deleteGigData,
            stories: stories,
            onAddStory: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddStoryScreen(),
                ),
              );
              if (result != null && result is StoryItem) {
                addNewStory(result);
              }
            },
            onViewStory: (index) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryViewScreen(
                    stories: stories,
                    initialIndex: index,
                    onStoryViewed: markStoryAsViewed,
                  ),
                ),
              );
            },
            isLoadingGigs: _isLoadingGigs,
            errorMessage: _errorMessage,
            onRefreshGigs: _fetchGigs,
          ),
          const CreatorOrderStatus(),
          const GigListScreen(),
          const MessageScreen(),
          const CreatorProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsContants.primaryColor,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: _onNavTapped,
        elevation: 8,
        iconSize: 28,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: _buildHighlightedIcon('', 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildHighlightedIcon('', 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildHighlightedIcon('', 2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildHighlightedIcon('', 3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildHighlightedIcon('', 4),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedIcon(String assetPath, int index) {
    final isSelected = _selectedIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getIconForIndex(index),
          size: 24,
          color: isSelected ? ColorsContants.primaryColor : Colors.black,
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

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.assignment_outlined;
      case 2:
        return Icons.work_outline; // Using Material work icon
      case 3:
        return Icons.chat_outlined;
      case 4:
        return Icons.person_outline;
      default:
        return Icons.circle;
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Tasks';
      case 2:
        return 'Gigs';
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
  final String name;
  final List<GigModel> gigData;
  final Function(int, GigModel) onGigUpdated;
  final Function(int) onGigDeleted;
  final List<StoryModel> stories;
  final VoidCallback onAddStory;
  final Function(int) onViewStory;
  final bool isLoadingGigs;
  final String? errorMessage;
  final Future<void> Function() onRefreshGigs;

  const HomePage({
    super.key,
    required this.gigData,
    required this.name,
    required this.onGigUpdated,
    required this.onGigDeleted,
    required this.stories,
    required this.onAddStory,
    required this.onViewStory,
    required this.isLoadingGigs,
    this.errorMessage,
    required this.onRefreshGigs,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _successScoreAnimation;
  late Animation<double> _ratingAnimation;
  late Animation<double> _responseRateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _successScoreAnimation = Tween<double>(
      begin: 0.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _ratingAnimation = Tween<double>(
      begin: 0.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _responseRateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.92,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(context, widget.name),
              const SizedBox(height: 24),
              _buildStatsCard(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Earnings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EarningsDetailScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsContants.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildEarningsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        children: [
          // Level and Success Score Section
          Row(
            children: [
              // Level
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Level",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsContants.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Level 2",
                        style: TextStyle(
                          color: ColorsContants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.grey[300],
              ),
              // Success Score
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Success Score",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "85%",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedBuilder(
                        animation: _successScoreAnimation,
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _successScoreAnimation.value,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                ColorsContants.primaryColor,
                              ),
                              minHeight: 6,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Rating and Response Rate Section
          Row(
            children: [
              // Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rating",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "4.8",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 120,
                      child: AnimatedBuilder(
                        animation: _ratingAnimation,
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _ratingAnimation.value,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                ColorsContants.primaryColor,
                              ),
                              minHeight: 6,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.grey[300],
              ),
              // Response Rate
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Response Rate",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "92%",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedBuilder(
                        animation: _responseRateAnimation,
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _responseRateAnimation.value,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                ColorsContants.primaryColor,
                              ),
                              minHeight: 6,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Container(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 24),

          // Stats Section
          Column(
            children: [
              _buildStatRow("Unique Orders", "9/10"),
              const SizedBox(height: 16),
              Container(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 16),
              _buildStatRow("Orders", "124"),
              const SizedBox(height: 16),
              Container(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 16),
              _buildStatRow("Earnings", "₹25,000"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildTopHeader(BuildContext context, String name) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage('assets/avature.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Hi, ${name.isNotEmpty ? name : 'Guest'} 👋",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreatorNotification()),
            );
          },
          child: Image.asset(
            'assets/icons/notification.png',
            height: 25,
            width: 25,
            color: ColorsContants.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EarningsDetailScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available for withdrawal",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "₹15,000",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorsContants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.grey[300],
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Earnings this Month",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "₹45,000",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(height: 1, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Avg. Selling Price",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "₹2,500",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.grey[300],
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Active Orders",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "12",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
