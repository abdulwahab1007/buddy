import '../api_service.dart';

/// Comprehensive Profile API Service
/// Handles all profile-related API calls from the Postman collection
class ProfileApiService {
  
  // ==================== CREATOR PROFILE ====================
  
  /// Get creator profile
  /// GET /api/creator-profile/{id}
  static Future<Map<String, dynamic>> getCreatorProfile(int creatorId) async {
    try {
      return await ApiService.get('/creator-profile/$creatorId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Create creator profile
  /// POST /api/creator-profile
  static Future<Map<String, dynamic>> createCreatorProfile({
    required String expertise,
    required String aboutMe,
  }) async {
    try {
      return await ApiService.post('/creator-profile', body: {
        'expertise': expertise,
        'about_me': aboutMe,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create creator profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update creator profile
  /// PUT /api/creator-profile/{id}
  static Future<Map<String, dynamic>> updateCreatorProfile({
    required int profileId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      return await ApiService.put('/creator-profile/$profileId', body: updateData);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update creator profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete creator profile
  /// DELETE /api/creator-profile
  static Future<Map<String, dynamic>> deleteCreatorProfile() async {
    try {
      return await ApiService.delete('/creator-profile');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete creator profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get current creator profile
  /// GET /api/creator/profile
  static Future<Map<String, dynamic>> getCurrentCreatorProfile() async {
    try {
      return await ApiService.get('/creator/profile');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch current creator profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update current creator profile
  /// PUT /api/creator/profile
  static Future<Map<String, dynamic>> updateCurrentCreatorProfile({
    required Map<String, dynamic> updateData,
  }) async {
    try {
      return await ApiService.put('/creator/profile', body: updateData);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update current creator profile: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== BUYER PROFILE ====================
  
  /// Create buyer profile
  /// POST /api/buyer-profile
  static Future<Map<String, dynamic>> createBuyerProfile({
    required String contactNumber,
    required String about,
  }) async {
    try {
      return await ApiService.post('/buyer-profile', body: {
        'contact_number': contactNumber,
        'about': about,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create buyer profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get buyer profile
  /// GET /api/buyer-profile/{id}
  static Future<Map<String, dynamic>> getBuyerProfile(int buyerId) async {
    try {
      return await ApiService.get('/buyer-profile/$buyerId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch buyer profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update buyer profile
  /// PUT /api/buyer-profile/{id}
  static Future<Map<String, dynamic>> updateBuyerProfile({
    required int buyerId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      return await ApiService.put('/buyer-profile/$buyerId', body: updateData);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update buyer profile: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete buyer profile
  /// DELETE /api/buyer-profile/{id}
  static Future<Map<String, dynamic>> deleteBuyerProfile(int buyerId) async {
    try {
      return await ApiService.delete('/buyer-profile/$buyerId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete buyer profile: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SKILLS ====================
  
  /// Add skill
  /// POST /api/skills
  static Future<Map<String, dynamic>> addSkill({
    required String name,
  }) async {
    try {
      return await ApiService.post('/skills', body: {
        'name': name,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add skill: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update skill
  /// PUT /api/skills/{id}
  static Future<Map<String, dynamic>> updateSkill({
    required int skillId,
    required String name,
  }) async {
    try {
      return await ApiService.put('/skills/$skillId', body: {
        'name': name,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update skill: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete skill
  /// DELETE /api/skills/{id}
  static Future<Map<String, dynamic>> deleteSkill(int skillId) async {
    try {
      return await ApiService.delete('/skills/$skillId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete skill: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SERVICES ====================
  
  /// Create creator service
  /// POST /api/creator/services
  static Future<Map<String, dynamic>> createCreatorService({
    required String serviceTitle,
    required double servicePrice,
  }) async {
    try {
      return await ApiService.post('/creator/services', body: {
        'service_title': serviceTitle,
        'service_price': servicePrice,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create service: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator services
  /// GET /api/creator/services
  static Future<Map<String, dynamic>> getCreatorServices() async {
    try {
      return await ApiService.get('/creator/services');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator services: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update creator service
  /// PUT /api/creator/services/{id}
  static Future<Map<String, dynamic>> updateCreatorService({
    required int serviceId,
    required String serviceTitle,
    required double servicePrice,
  }) async {
    try {
      return await ApiService.put('/creator/services/$serviceId', body: {
        'service_title': serviceTitle,
        'service_price': servicePrice,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update service: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete creator service
  /// DELETE /api/creator/services/{id}
  static Future<Map<String, dynamic>> deleteCreatorService(int serviceId) async {
    try {
      return await ApiService.delete('/creator/services/$serviceId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete service: $e',
        'statusCode': 500,
      };
    }
  }

  // ==================== SEARCH ====================
  
  /// Search services
  /// POST /api/services/search
  static Future<Map<String, dynamic>> searchServices({
    required String keyword,
  }) async {
    try {
      return await ApiService.post('/services/search', body: {
        'keyword': keyword,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to search services: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get service recommendations
  /// GET /api/services/recommendations
  static Future<Map<String, dynamic>> getServiceRecommendations() async {
    try {
      return await ApiService.get('/services/recommendations');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch service recommendations: $e',
        'statusCode': 500,
      };
    }
  }
}
