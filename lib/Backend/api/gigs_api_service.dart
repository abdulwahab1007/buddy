import 'dart:io';
import '../api_service.dart';

/// Comprehensive Gigs API Service
/// Handles all gig-related API calls from the Postman collection
class GigsApiService {
  
  /// Create a new gig
  /// POST /api/gigs
  static Future<Map<String, dynamic>> createGig({
    required String label,
    required String description,
    required String startingPrice,
    required File media,
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
          'media': media,
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
  /// GET /api/gigs
  static Future<Map<String, dynamic>> getAllGigs() async {
    try {
      return await ApiService.get('/gigs');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch gigs: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get gig by ID
  /// GET /api/gigs/{id}
  static Future<Map<String, dynamic>> getGigById(int gigId) async {
    try {
      return await ApiService.get('/gigs/$gigId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch gig: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update gig
  /// PUT /api/gigs/{id}
  static Future<Map<String, dynamic>> updateGig({
    required int gigId,
    Map<String, dynamic>? updateData,
  }) async {
    try {
      return await ApiService.put('/gigs/$gigId', body: updateData);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update gig: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete gig
  /// DELETE /api/gigs/{id}
  static Future<Map<String, dynamic>> deleteGig(int gigId) async {
    try {
      return await ApiService.delete('/gigs/$gigId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete gig: $e',
        'statusCode': 500,
      };
    }
  }

  /// Check gig filter
  /// POST /api/gigs/check-filter
  static Future<Map<String, dynamic>> checkGigFilter({
    required String label,
  }) async {
    try {
      return await ApiService.post('/gigs/check-filter', body: {
        'label': label,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to check gig filter: $e',
        'statusCode': 500,
      };
    }
  }

  /// Filter gigs
  /// POST /api/gigs/filter
  static Future<Map<String, dynamic>> filterGigs({
    Map<String, dynamic>? filterData,
  }) async {
    try {
      return await ApiService.post('/gigs/filter', body: filterData);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to filter gigs: $e',
        'statusCode': 500,
      };
    }
  }

  /// Toggle gig favorite
  /// POST /api/gigs/{id}/toggle-favorite
  static Future<Map<String, dynamic>> toggleGigFavorite(int gigId) async {
    try {
      return await ApiService.post('/gigs/$gigId/toggle-favorite');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to toggle gig favorite: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get creator home data
  /// GET /api/creator-home/{creatorId}
  static Future<Map<String, dynamic>> getCreatorHome(int creatorId) async {
    try {
      return await ApiService.get('/creator-home/$creatorId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator home: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get buyer content (stories and gigs)
  /// GET /api/buyer/content
  static Future<Map<String, dynamic>> getBuyerContent() async {
    try {
      return await ApiService.get('/buyer/content');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch buyer content: $e',
        'statusCode': 500,
      };
    }
  }
}
