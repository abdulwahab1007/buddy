import 'package:flutter/material.dart';
import 'package:buddy/Models/StoryModel.dart';

class StoryViewScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;
  final Function(int) onStoryViewed;

  const StoryViewScreen({
    super.key,
    required this.stories,
    required this.initialIndex,
    required this.onStoryViewed,
  });

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  int _currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(vsync: this);

    _loadStory(animateToPage: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          if (_currentStoryIndex + 1 <
              widget.stories[_currentIndex].storyItems.length) {
            _currentStoryIndex += 1;
            _loadStory();
          } else {
            // If it's the last story item, move to the next user's story
            if (_currentIndex + 1 < widget.stories.length) {
              _currentIndex += 1;
              _currentStoryIndex = 0;
              _loadStory(animateToPage: true);
            } else {
              // If we're at the last user's last story, close the screen
              Navigator.pop(context);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadStory({bool animateToPage = false}) {
    // Mark the story as viewed
    widget.onStoryViewed(_currentIndex);

    // Get the current story item
    final story = widget.stories[_currentIndex];
    if (story.storyItems.isEmpty) return;

    final storyItem = story.storyItems[_currentStoryIndex];

    // Set the animation duration based on the story item
    _animationController.duration = storyItem.duration;

    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Start the animation
    _animationController.forward();
  }

  void _onTapDown(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    // If tapped on the left 1/3 of the screen
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentStoryIndex > 0) {
          _currentStoryIndex--;
          _loadStory();
        } else {
          // If it's the first story item, go to the previous user's last story
          if (_currentIndex > 0) {
            _currentIndex--;
            _currentStoryIndex =
                widget.stories[_currentIndex].storyItems.length - 1;
            _loadStory(animateToPage: true);
          }
        }
      });
    }
    // If tapped on the right 2/3 of the screen
    else {
      setState(() {
        if (_currentStoryIndex + 1 <
            widget.stories[_currentIndex].storyItems.length) {
          _currentStoryIndex++;
          _loadStory();
        } else {
          // If it's the last story item, go to the next user's first story
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex++;
            _currentStoryIndex = 0;
            _loadStory(animateToPage: true);
          } else {
            // If we're at the last user's last story, close the screen
            Navigator.pop(context);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.stories.length,
          itemBuilder: (context, index) {
            final story = widget.stories[index];
            return Stack(
              children: [
                // Story content
                story.storyItems.isNotEmpty
                    ? Center(
                        child: Image.asset(
                          story.storyItems[_currentStoryIndex].imageUrl,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No stories available',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                // Progress indicator
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: List.generate(
                      story.storyItems.length,
                      (i) => Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: i < _currentStoryIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: i == _currentStoryIndex
                              ? AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return FractionallySizedBox(
                                      widthFactor: _animationController.value,
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),

                // User info
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 10,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(story.imageUrl),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        story.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Close button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
