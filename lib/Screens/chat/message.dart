import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// Import new API services
import 'package:buddy/Backend/index.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Map<String, dynamic>> chats = [];
  bool isLoading = true;
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      // Use new API service to get conversations
      final response = await NotificationService.getConversations();
      
      if (response['success'] == true) {
        final data = response['data'] as List<dynamic>;
        setState(() {
          chats = data.map((conversation) => {
            'id': conversation['id'],
            'name': conversation['participant_name'] ?? 'Unknown User',
            'message': conversation['last_message'] ?? 'No messages yet',
            'time': _formatTime(conversation['updated_at']),
            'image': 'assets/avature.png', // Default image
            'unread': conversation['unread_count'] ?? 0,
            'isOnline': false, // This would need to be determined by other means
          }).toList();
          unreadCount = chats.fold(0, (sum, chat) => sum + (chat['unread'] as int));
          isLoading = false;
        });
      } else {
        // Fallback to dummy data if API fails
        setState(() {
          chats = [
            {
              'name': 'Alice Johnson',
              'message': 'Hey! Are you free this weekend?',
              'time': '4:20 PM',
              'image': 'assets/avature.png',
              'unread': 2,
              'isOnline': true,
            },
            {
              'name': 'Bob Smith',
              'message': 'Got the files. Thanks!',
              'time': '3:15 PM',
              'image': 'assets/avature.png',
              'unread': 0,
              'isOnline': false,
            },
          ];
          unreadCount = 2;
          isLoading = false;
        });
      }
    } catch (e) {
      // Fallback to dummy data on error
      setState(() {
        chats = [
          {
            'name': 'Alice Johnson',
            'message': 'Hey! Are you free this weekend?',
            'time': '4:20 PM',
            'image': 'assets/avature.png',
            'unread': 2,
            'isOnline': true,
          },
        ];
        unreadCount = 2;
        isLoading = false;
      });
    }
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null) return 'Now';
    
    try {
      final date = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inMinutes < 1) {
        return 'Now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}';
      }
    } catch (e) {
      return 'Now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Messages",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "You have $unreadCount unread messages",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Online Users
            SizedBox(
              height: 90,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemCount: chats.where((chat) => chat['isOnline'] == true).length,
                itemBuilder: (context, index) {
                  final onlineUsers = chats.where((chat) => chat['isOnline'] == true).toList();
                  final chat = onlineUsers[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorsContants.primaryColor,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 26,
                                backgroundImage: AssetImage(chat['image']),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat['name'].split(' ')[0],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Recent Chats Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                "Recent Chats",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Chat List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Chat()),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage(chat['image']),
                                    ),
                                    if (chat['isOnline'])
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            chat['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            chat['time'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: chat['unread'] > 0
                                                  ? ColorsContants.primaryColor
                                                  : Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              chat['message'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: chat['unread'] > 0
                                                    ? Colors.black87
                                                    : Colors.grey[600],
                                                fontWeight: chat['unread'] > 0
                                                    ? FontWeight.w500
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          if (chat['unread'] > 0) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: ColorsContants.primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                chat['unread'].toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
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
      ),
    );
  }
}
