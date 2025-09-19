import 'package:buddy/Backend/api/notification_apis.dart';

import 'package:buddy/Models/notification_model.dart';
import 'package:buddy/helpers/auth_helper.dart';
import 'package:buddy/helpers/config/app_url.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreatorNotification extends StatefulWidget {
  const CreatorNotification({Key? key}) : super(key: key);

  @override
  _CreatorNotificationState createState() => _CreatorNotificationState();
}

class _CreatorNotificationState extends State<CreatorNotification> {
  late Future<List<NotificationItem>> futureNotifications;

  @override
  void initState() {
    super.initState();
    futureNotifications = fetchNotifications();
  }

  // Function to mark a notification as read
  Future<void> _markNotificationAsRead(String id) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${ApiConfig.notificationUrl}/$id/read',
        ),
        headers: await getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        // Refresh notifications to reflect updated isRead status
        setState(() {
          futureNotifications = fetchNotifications();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to mark notification as read')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureNotifications = fetchNotifications();
          });
        },
        child: FutureBuilder<List<NotificationItem>>(
          future: futureNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureNotifications = fetchNotifications();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              final notifications = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return GestureDetector(
                    onTap: () {
                      if (!item.isRead) {
                        _markNotificationAsRead(item.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.isRead
                            ? Colors.white
                            : ColorsContants.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage('assets/avature.png'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.title} ${item.user}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: item.isRead
                                        ? Colors.black
                                        : ColorsContants.primaryColor,
                                  ),
                                ),
                                if (item.message.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      item.message,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: item.isRead
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _ActionButton(
                                      text: 'Approve',
                                      color: Colors.green,
                                      onTap: () {
                                        // TODO: Implement approve action
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _ActionButton(
                                      text: 'Deny',
                                      color: Colors.red,
                                      onTap: () {
                                        // TODO: Implement deny action
                                      },
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
            }
          },
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
