class StoriesGigsModel {
  List<Story>? stories;
  List<Gigs>? gigs;

  StoriesGigsModel({this.stories, this.gigs});

  StoriesGigsModel.fromJson(Map<String, dynamic> json) {
    if (json['stories'] != null) {
      stories = <Story>[];
      json['stories'].forEach((v) {
        stories!.add(Story.fromJson(v));
      });
    }
    if (json['gigs'] != null) {
      gigs = <Gigs>[];
      json['gigs'].forEach((v) {
        gigs!.add(Gigs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (stories != null) {
      data['stories'] = stories!.map((v) => v.toJson()).toList();
    }
    if (gigs != null) {
      data['gigs'] = gigs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Story {
  int? id;
  String? username;
  String? profileImage;

  Story({this.id, this.username, this.profileImage});

  Story.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_image': profileImage,
    };
  }
}

class Gigs {
  int? gigId;
  String? creatorName;
  String? mediaUrl;
  String? label;
  String? description;
  String? startingPrice;

  Gigs({
    this.gigId,
    this.creatorName,
    this.mediaUrl,
    this.label,
    this.description,
    this.startingPrice,
  });

  Gigs.fromJson(Map<String, dynamic> json) {
    gigId = json['gig_id'];
    creatorName = json['creator_name'];
    mediaUrl = json['media_url'];
    label = json['label'];
    description = json['description'];
    startingPrice = json['starting_price'];
  }

  Map<String, dynamic> toJson() {
    return {
      'gig_id': gigId,
      'creator_name': creatorName,
      'media_url': mediaUrl,
      'label': label,
      'description': description,
      'starting_price': startingPrice,
    };
  }
}
