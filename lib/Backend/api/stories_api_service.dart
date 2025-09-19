import 'dart:io';
import '../api_service.dart';

/// Comprehensive Stories API Service
/// Handles all story-related API calls from the Postman collection
class StoriesApiService {
  
  /// Create a new story
  /// POST /api/stories
  static Future<Map<String, dynamic>> createStory({
    required List<File> media,
    required String caption,
  }) async {
    try {
      final response = await ApiService.postMultipart(
        '/stories',
        fields: {
          'caption': caption,
        },
        files: {
          for (int i = 0; i < media.length; i++) 'media[$i]': media[i],
        },
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
  /// GET /api/stories
  static Future<Map<String, dynamic>> getAllStories() async {
    try {
      return await ApiService.get('/stories');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch stories: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get story by ID
  /// GET /api/stories/{id}
  static Future<Map<String, dynamic>> getStoryById(int storyId) async {
    try {
      return await ApiService.get('/stories/$storyId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch story: $e',
        'statusCode': 500,
      };
    }
  }

  /// Update story
  /// PUT /api/stories/{id}
  static Future<Map<String, dynamic>> updateStory({
    required int storyId,
    Map<String, dynamic>? updateData,
  }) async {
    try {
      return await ApiService.put('/stories/$storyId', body: updateData);
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update story: $e',
        'statusCode': 500,
      };
    }
  }

  /// Delete story
  /// DELETE /api/stories/{id}
  static Future<Map<String, dynamic>> deleteStory(int storyId) async {
    try {
      return await ApiService.delete('/stories/$storyId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete story: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get stories by creator
  /// GET /api/stories/creator/{creatorId}
  static Future<Map<String, dynamic>> getStoriesByCreator(int creatorId) async {
    try {
      return await ApiService.get('/stories/creator/$creatorId');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch creator stories: $e',
        'statusCode': 500,
      };
    }
  }

  /// Like/unlike story
  /// POST /api/stories/{id}/toggle-like
  static Future<Map<String, dynamic>> toggleStoryLike(int storyId) async {
    try {
      return await ApiService.post('/stories/$storyId/toggle-like');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to toggle story like: $e',
        'statusCode': 500,
      };
    }
  }

  /// Add comment to story
  /// POST /api/stories/{id}/comment
  static Future<Map<String, dynamic>> addStoryComment({
    required int storyId,
    required String comment,
  }) async {
    try {
      return await ApiService.post('/stories/$storyId/comment', body: {
        'comment': comment,
      });
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add story comment: $e',
        'statusCode': 500,
      };
    }
  }

  /// Get story comments
  /// GET /api/stories/{id}/comments
  static Future<Map<String, dynamic>> getStoryComments(int storyId) async {
    try {
      return await ApiService.get('/stories/$storyId/comments');
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to fetch story comments: $e',
        'statusCode': 500,
      };
    }
  }
}
