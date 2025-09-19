class ApiConfig {
  static const String baseUrl = "https://buddy.nexltech.com/public/api";

  static const String signupUrl = "$baseUrl/register";
  static const String loginUrl = "$baseUrl/login";

  static const String myOrdersUrl = "$baseUrl/creator/my-orders";
  static const String createOrderUrl = "$baseUrl/orders";

//Bayer urls
  static const String Bayerurl = "$baseUrl/buyer/content";
  static const String BayerOrderHistoryUrl = "$baseUrl/buyer/all/orders";
  static const String BayerProfileUrl = "$baseUrl/buyer-profile";

//Notification URL
  static const String notificationUrl = "$baseUrl/notifications";

//Gigs URL

  //Content-creator profile url
  static const String userProfileUrl = "$baseUrl/creator-profile";

  //content-creator skills
  static const String createskillsUrl = "$baseUrl/skills";
  static const String deleteskillsUrl = "$baseUrl/skills";

  //edit profile content-creator
  static const String getCreatorServiceUrl = "$baseUrl/creator/services";
  static const String createCreatorServiceUrl = "$baseUrl/creator/services";
  static const String deleteCreatorServiceUrl = "$baseUrl/creator/services";

  //Content-creator conversation
  static const String contentCreatorConversationUrl = "$baseUrl/messages/send";

  //Gigs
  static const String gigsUrl = "$baseUrl/gigs";
  static const String createGigUrl = "$baseUrl/gigs/create";
  static const String updateGigUrl = "$baseUrl/gigs/update";
  static const String deleteGigUrl = "$baseUrl/gigs/delete";

  //Order
  static const String orderDetailsUrl = "$baseUrl/orders/details";
}
