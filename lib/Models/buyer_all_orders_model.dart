class BuyerAllOrders {
  bool? status;
  String? message;
  List<Data>? data;

  BuyerAllOrders({this.status, this.message, this.data});

  BuyerAllOrders.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? buyerId;
  String? gigId;
  String? buyerName;
  String? email;
  String? projectDetails;
  String? budget;
  String? expectedDeliveryDate;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? label;
  String? startDate;
  String? endDate;
  String? milestone;
  String? progressStatus;
  Gig? gig;
  String? contentCreator;

  Data(
      {this.id,
      this.buyerId,
      this.gigId,
      this.buyerName,
      this.email,
      this.projectDetails,
      this.budget,
      this.expectedDeliveryDate,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.label,
      this.startDate,
      this.endDate,
      this.milestone,
      this.progressStatus,
      this.gig,
      this.contentCreator});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buyerId = json['buyer_id'];
    gigId = json['gig_id'];
    buyerName = json['buyer_name'];
    email = json['email'];
    projectDetails = json['project_details'];
    budget = json['budget'];
    expectedDeliveryDate = json['expected_delivery_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    label = json['label'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    milestone = json['milestone'];
    progressStatus = json['progress_status'];
    gig = json['gig'] != null ? Gig.fromJson(json['gig']) : null;
    contentCreator = json['content_creator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['buyer_id'] = buyerId;
    data['gig_id'] = gigId;
    data['buyer_name'] = buyerName;
    data['email'] = email;
    data['project_details'] = projectDetails;
    data['budget'] = budget;
    data['expected_delivery_date'] = expectedDeliveryDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['label'] = label;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['milestone'] = milestone;
    data['progress_status'] = progressStatus;
    if (gig != null) {
      data['gig'] = gig!.toJson();
    }
    data['content_creator'] = contentCreator;
    return data;
  }
}

class Gig {
  int? id;
  String? userId;
  String? label;
  String? description;
  String? mediaPath;
  String? startingPrice;
  int? rating;
  int? review;
  bool? isFavorite;
  String? createdAt;
  String? updatedAt;

  Gig(
      {this.id,
      this.userId,
      this.label,
      this.description,
      this.mediaPath,
      this.startingPrice,
      this.rating,
      this.review,
      this.isFavorite,
      this.createdAt,
      this.updatedAt});

  Gig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    label = json['label'];
    description = json['description'];
    mediaPath = json['media_path'];
    startingPrice = json['starting_price'];
    rating = json['rating'];
    review = json['review'];
    isFavorite = json['is_favorite'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['label'] = label;
    data['description'] = description;
    data['media_path'] = mediaPath;
    data['starting_price'] = startingPrice;
    data['rating'] = rating;
    data['review'] = review;
    data['is_favorite'] = isFavorite;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
