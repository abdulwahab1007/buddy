import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/screens/auth/login.dart';
import 'package:flutter/material.dart';

class ListCreators extends StatelessWidget {
  final List<Map<String, String>> creators = [
    {
      'name': 'Alex Design',
      'skill': 'UI/UX Designer',
      'description': 'Crafts beautiful and user-friendly interfaces.',
      'image': 'assets/avature.png'
    },
    {
      'name': 'John Dev',
      'skill': 'Mobile App Developer',
      'description': 'Builds fast, scalable, and beautiful apps.',
      'image': 'assets/avature.png'
    },
    {
      'name': 'Sophia Writes',
      'skill': 'Copywriter',
      'description': 'Turns ideas into compelling content.',
      'image': 'assets/avature.png'
    },
    {
      'name': 'Emily VFX',
      'skill': 'Video Editor',
      'description': 'Transforms footage into cinematic magic.',
      'image': 'assets/avature.png'
    },
  ];

  ListCreators({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Text(
                'Top Freelancers',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorsContants.primaryColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: creators.length,
                itemBuilder: (context, index) {
                  final creator = creators[index];
                  return GestureDetector(
                    onTap: () => _navigateToLogin(context),
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage(creator['image']!),
                                  radius: 30,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        creator['name']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: ColorsContants.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        creator['skill']!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: ColorsContants.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        creator['description']!,
                                        style: const TextStyle(fontSize: 13),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () => _navigateToLogin(context),
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Chat Now'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorsContants.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  textStyle: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
