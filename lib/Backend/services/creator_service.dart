import 'dart:io';
import '../api_service.dart';

/// Content Creator Service
/// Handles all content creator related API calls
class CreatorService {
  // ==================== GIGS MANAGEMENT ====================

  /// Create a new gig
  static Future<Map<String, dynamic>> createGig({
    required String label,
    required String description,
    required String startingPrice,
    required File mediaFile,
  }) async {
    try {
      final response = await ApiService.postMultipart(
        '/gigs',
        fields: {
          'label': label,
          'description': description,
          'starting_price': startingPrice,
        },
        files: {
          'media': mediaFile,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create gig: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get all gigs
  static Future<Map<String, dynamic>> getGigs() async {
    try {
      final response = await ApiService.get('/gigs');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch gigs: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get gig by ID
  static Future<Map<String, dynamic>> getGigById(int gigId) async {
    try {
      final response = await ApiService.get('/gigs/$gigId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch gig: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get gig details (alias for getGigById)
  static Future<Map<String, dynamic>> getGigDetails(int gigId) async {
    return getGigById(gigId);
  }

  /// Get creator profile
  static Future<Map<String, dynamic>> getCreatorProfile(int creatorId) async {
    try {
      final response = await ApiService.get('/creator-profile/$creatorId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator services
  static Future<Map<String, dynamic>> getCreatorServices() async {
    try {
      final response = await ApiService.get('/creator/services');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator services: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator orders
  static Future<Map<String, dynamic>> getCreatorOrders() async {
    try {
      final response = await ApiService.get('/creator/my-orders');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator orders: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update gig
  static Future<Map<String, dynamic>> updateGig({
    required int gigId,
    String? label,
    String? description,
    String? startingPrice,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (label != null) body['label'] = label;
      if (description != null) body['description'] = description;
      if (startingPrice != null) body['starting_price'] = startingPrice;

      final response = await ApiService.put('/gigs/$gigId', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update gig: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete gig
  static Future<Map<String, dynamic>> deleteGig(int gigId) async {
    try {
      final response = await ApiService.delete('/gigs/$gigId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete gig: $e',
        'statusCode': 500,
      };
    }
  }

  /// Toggle gig favorite
  static Future<Map<String, dynamic>> toggleGigFavorite(int gigId) async {
    try {
      final response = await ApiService.post('/gigs/$gigId/toggle-favorite');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to toggle gig favorite: $e',
        'statusCode': 500,
      };
    }
  }

  /// Filter gigs
  static Future<Map<String, dynamic>> filterGigs({
    String? label,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (label != null) body['label'] = label;
      if (category != null) body['category'] = category;
      if (minPrice != null) body['min_price'] = minPrice;
      if (maxPrice != null) body['max_price'] = maxPrice;

      final response = await ApiService.post('/gigs/filter', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to filter gigs: $e',
        'statusCode': 500,
      };
    }
  }

  /// Check gig filter
  static Future<Map<String, dynamic>> checkGigFilter({
    required String label,
  }) async {
    try {
      final response = await ApiService.post(
        '/gigs/check-filter',
        body: {'label': label},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to check gig filter: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== STORIES MANAGEMENT ====================

  /// Create a new story
  static Future<Map<String, dynamic>> createStory({
    required List<File> mediaFiles,
    required String caption,
  }) async {
    try {
      final files = <String, File>{};
      for (int i = 0; i < mediaFiles.length; i++) {
        files['media[$i]'] = mediaFiles[i];
      }

      final response = await ApiService.postMultipart(
        '/stories',
        fields: {
          'caption': caption,
        },
        files: files,
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create story: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get all stories
  static Future<Map<String, dynamic>> getStories() async {
    try {
      final response = await ApiService.get('/stories');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch stories: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== PROFILE MANAGEMENT ====================

  /// Create creator profile
  static Future<Map<String, dynamic>> createProfile({
    required String expertise,
    required String aboutMe,
    String? title,
    String? profilePicture,
    String? address,
    List<Map<String, String>>? skills,
  }) async {
    try {
      final body = <String, dynamic>{
        'expertise': expertise,
        'about_me': aboutMe,
      };

      if (title != null) body['title'] = title;
      if (profilePicture != null) body['profile_picture'] = profilePicture;
      if (address != null) body['address'] = address;
      if (skills != null) body['skills'] = skills.map((skill) => skill['name']).where((name) => name != null).cast<String>().toList();

      final response = await ApiService.post('/creator/profile', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.get('/creator/profile');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator profile by ID (public)
  static Future<Map<String, dynamic>> getPublicProfile(int creatorId) async {
    try {
      final response = await ApiService.get('/creator-profile/$creatorId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch public profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update creator profile
  static Future<Map<String, dynamic>> updateProfile({
    String? expertise,
    String? aboutMe,
    String? title,
    String? profilePicture,
    String? address,
    List<Map<String, String>>? skills,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (expertise != null) body['expertise'] = expertise;
      if (aboutMe != null) body['about_me'] = aboutMe;
      if (title != null) body['title'] = title;
      if (profilePicture != null) body['profile_picture'] = profilePicture;
      if (address != null) body['address'] = address;
      if (skills != null) body['skills'] = skills.map((skill) => skill['name']).where((name) => name != null).cast<String>().toList();

      final response = await ApiService.put('/creator/profile', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete creator profile
  static Future<Map<String, dynamic>> deleteProfile() async {
    try {
      final response = await ApiService.delete('/creator/profile');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete profile: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SKILLS MANAGEMENT ====================

  /// Add skill
  static Future<Map<String, dynamic>> addSkill({
    required String name,
  }) async {
    try {
      final response = await ApiService.post(
        '/skills',
        body: {'name': name},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add skill: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update skill
  static Future<Map<String, dynamic>> updateSkill({
    required int skillId,
    required String name,
  }) async {
    try {
      final response = await ApiService.put(
        '/skills/$skillId',
        body: {'name': name},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update skill: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete skill
  static Future<Map<String, dynamic>> deleteSkill(int skillId) async {
    try {
      final response = await ApiService.delete('/skills/$skillId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete skill: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SERVICES MANAGEMENT ====================

  /// Create service
  static Future<Map<String, dynamic>> createService({
    required String serviceTitle,
    required double servicePrice,
  }) async {
    try {
      final response = await ApiService.post(
        '/creator/services',
        body: {
          'service_title': serviceTitle,
          'service_price': servicePrice,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create service: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get services
  static Future<Map<String, dynamic>> getServices() async {
    try {
      final response = await ApiService.get('/creator/services');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch services: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update service
  static Future<Map<String, dynamic>> updateService({
    required int serviceId,
    String? serviceTitle,
    double? servicePrice,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (serviceTitle != null) body['service_title'] = serviceTitle;
      if (servicePrice != null) body['service_price'] = servicePrice;

      final response = await ApiService.put('/creator/services/$serviceId', body: body);
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update service: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete service
  static Future<Map<String, dynamic>> deleteService(int serviceId) async {
    try {
      final response = await ApiService.delete('/creator/services/$serviceId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete service: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== ORDERS MANAGEMENT ====================

  /// Get creator orders
  static Future<Map<String, dynamic>> getMyOrders() async {
    try {
      final response = await ApiService.get('/creator/my-orders');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch orders: $e',
        'statusCode': 500,
      };
    }
  }

  /// Respond to order
  static Future<Map<String, dynamic>> respondToOrder({
    required int orderId,
    required String action, // 'accept' or 'reject'
  }) async {
    try {
      final response = await ApiService.post(
        '/orders/$orderId/respond',
        body: {'action': action},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to respond to order: $e',
        'statusCode': 500,
      };
    }
  }

  /// Send message to buyer
  static Future<Map<String, dynamic>> sendMessageToBuyer({
    required int orderId,
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    try {
      final response = await ApiService.post(
        '/orders/$orderId/message',
        body: {
          'sender_id': senderId,
          'receiver_id': receiverId,
          'message': message,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to send message: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update order milestone
  static Future<Map<String, dynamic>> updateOrderMilestone({
    required int orderId,
    required String milestone,
  }) async {
    try {
      final response = await ApiService.patch(
        '/orders/$orderId/milestone',
        body: {'milestone': milestone},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update milestone: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update order progress status
  static Future<Map<String, dynamic>> updateOrderProgressStatus({
    required int orderId,
    required String progressStatus,
  }) async {
    try {
      final response = await ApiService.patch(
        '/orders/$orderId/progress-status',
        body: {'progress_status': progressStatus},
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update progress status: $e',
        'statusCode': 500,
      };
    }
  }

  /// Upload work for order
  static Future<Map<String, dynamic>> uploadWork({
    required int orderId,
    required File file,
    required String message,
  }) async {
    try {
      final response = await ApiService.postMultipart(
        '/orders/$orderId/upload-work',
        fields: {
          'message': message,
        },
        files: {
          'file': file,
        },
      );
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to upload work: $e',
        'statusCode': 500,
      };
    }
  }

  /// View order submissions
  static Future<Map<String, dynamic>> viewOrderSubmissions(int orderId) async {
    try {
      final response = await ApiService.get('/orders/$orderId/view-submissions');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to view submissions: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== CREATOR HOME ====================

  /// Get creator home data
  static Future<Map<String, dynamic>> getCreatorHome(int creatorId) async {
    try {
      final response = await ApiService.get('/creator-home/$creatorId');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator home data: $e',
        'statusCode': 500,
      };
    }
  }
}
