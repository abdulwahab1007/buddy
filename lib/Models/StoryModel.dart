// Story model class
class StoryModel {
  final String username;
  final String imageUrl;
  bool hasStory;
  bool isViewed;
  List<StoryItem> storyItems;
////
  StoryModel({
    required this.username,
    required this.imageUrl,
    required this.hasStory,
    required this.isViewed,
    required this.storyItems,
  });
}

// Story item class
class StoryItem {
  final String imageUrl;
  final Duration duration;

  StoryItem({
    required this.imageUrl,
    required this.duration,
  });
}
