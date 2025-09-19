# Buddy App API Documentation

This document provides comprehensive documentation for all API endpoints used in the Buddy App, based on the Postman collection.

## Table of Contents

1. [Authentication APIs](#authentication-apis)
2. [Gigs APIs](#gigs-apis)
3. [Stories APIs](#stories-apis)
4. [Orders APIs](#orders-apis)
5. [Chat APIs](#chat-apis)
6. [Notifications APIs](#notifications-apis)
7. [Profile APIs](#profile-apis)
8. [Payment APIs](#payment-apis)
9. [Admin APIs](#admin-apis)

## Base URL
```
Production: https://buddy.nexltech.com/public/api
Development: http://127.0.0.1:8000/api
```

## Authentication
All authenticated endpoints require a Bearer token in the Authorization header:
```
Authorization: Bearer {token}
```

---

## Authentication APIs

### Register User
- **POST** `/api/register`
- **Body:**
```json
{
  "name": "User Name",
  "email": "user@example.com",
  "password": "password",
  "password_confirmation": "password",
  "role": "Buyer" | "Content Creator"
}
```

### Login User
- **POST** `/api/login`
- **Body:**
```json
{
  "email": "user@example.com",
  "password": "password"
}
```

### Get Current User
- **GET** `/api/user`
- **Headers:** Authorization required

### Social Login
- **GET** `/api/social-login`

---

## Gigs APIs

### Create Gig
- **POST** `/api/gigs`
- **Headers:** Authorization required
- **Body:** Multipart form data
  - `label`: String
  - `description`: String
  - `starting_price`: String
  - `media`: File

### Get All Gigs
- **GET** `/api/gigs`
- **Headers:** Authorization required

### Get Gig by ID
- **GET** `/api/gigs/{id}`
- **Headers:** Authorization required

### Update Gig
- **PUT** `/api/gigs/{id}`
- **Headers:** Authorization required
- **Body:**
```json
{
  "label": "Updated Label"
}
```

### Delete Gig
- **DELETE** `/api/gigs/{id}`
- **Headers:** Authorization required

### Check Gig Filter
- **POST** `/api/gigs/check-filter`
- **Headers:** Authorization required
- **Body:**
```json
{
  "label": "video Editor"
}
```

### Filter Gigs
- **POST** `/api/gigs/filter`
- **Headers:** Authorization required

### Toggle Gig Favorite
- **POST** `/api/gigs/{id}/toggle-favorite`
- **Headers:** Authorization required

### Get Creator Home
- **GET** `/api/creator-home/{creatorId}`
- **Headers:** Authorization required

### Get Buyer Content
- **GET** `/api/buyer/content`
- **Headers:** Authorization required

---

## Stories APIs

### Create Story
- **POST** `/api/stories`
- **Headers:** Authorization required
- **Body:** Multipart form data
  - `media`: File(s)
  - `caption`: String

### Get All Stories
- **GET** `/api/stories`
- **Headers:** Authorization required

### Get Story by ID
- **GET** `/api/stories/{id}`
- **Headers:** Authorization required

### Update Story
- **PUT** `/api/stories/{id}`
- **Headers:** Authorization required

### Delete Story
- **DELETE** `/api/stories/{id}`
- **Headers:** Authorization required

### Get Stories by Creator
- **GET** `/api/stories/creator/{creatorId}`
- **Headers:** Authorization required

### Toggle Story Like
- **POST** `/api/stories/{id}/toggle-like`
- **Headers:** Authorization required

### Add Story Comment
- **POST** `/api/stories/{id}/comment`
- **Headers:** Authorization required
- **Body:**
```json
{
  "comment": "Great story!"
}
```

### Get Story Comments
- **GET** `/api/stories/{id}/comments`
- **Headers:** Authorization required

---

## Orders APIs

### Create Order
- **POST** `/api/orders`
- **Headers:** Authorization required
- **Body:**
```json
{
  "gig_id": 9,
  "buyer_name": "Buyer Name",
  "email": "buyer@example.com",
  "project_details": "Project description",
  "budget": 50.0,
  "expected_delivery_date": "2025-07-07"
}
```

### Get Order by ID
- **GET** `/api/order/{id}`
- **Headers:** Authorization required

### Get Buyer All Orders
- **GET** `/api/buyer/all/orders`
- **Headers:** Authorization required

### Get Creator Orders
- **GET** `/api/creator/my-orders`
- **Headers:** Authorization required

### Respond to Order
- **POST** `/api/orders/{id}/respond`
- **Headers:** Authorization required
- **Body:**
```json
{
  "action": "accept" | "reject"
}
```

### Send Message to Buyer
- **POST** `/api/orders/{id}/message`
- **Headers:** Authorization required
- **Body:**
```json
{
  "sender_id": 1,
  "receiver_id": 2,
  "message": "Hello, I have an update on your order."
}
```

### Send Reply to Creator
- **POST** `/api/orders/{id}/send-reply`
- **Headers:** Authorization required
- **Body:**
```json
{
  "message": "Thanks! Looking forward to it."
}
```

### Update Order Milestone
- **PATCH** `/api/orders/{id}/milestone`
- **Headers:** Authorization required
- **Body:**
```json
{
  "milestone": "final"
}
```

### Update Order Progress Status
- **PATCH** `/api/orders/{id}/progress-status`
- **Headers:** Authorization required
- **Body:**
```json
{
  "progress_status": "completed"
}
```

### Upload Work for Order
- **POST** `/api/orders/{id}/upload-work`
- **Headers:** Authorization required
- **Body:** Multipart form data
  - `file`: File
  - `message`: String

### View Order Submissions
- **GET** `/api/orders/{id}/view-submissions`
- **Headers:** Authorization required

### Create Dispute
- **POST** `/api/orders/{id}/disputes`
- **Headers:** Authorization required
- **Body:**
```json
{
  "message": "The delivery was missing major content.",
  "dispute_type": "Incomplete Delivery"
}
```

### Get All Disputes
- **GET** `/api/disputes`
- **Headers:** Authorization required

### Resolve Dispute (Admin)
- **POST** `/api/disputes/{id}/resolve`
- **Headers:** Authorization required
- **Body:**
```json
{
  "resolution_comment": "The dispute has been resolved.",
  "status": "resolved"
}
```

---

## Chat APIs

### Send Chat Message
- **POST** `/api/realtime-chat/send`
- **Headers:** Authorization required
- **Body:**
```json
{
  "conversation_id": 1,
  "message": "Hello, I'm interested in your gig"
}
```

### Send Chat with Gig Context
- **POST** `/api/realtime-chat/send`
- **Headers:** Authorization required
- **Body:**
```json
{
  "gig_id": 7,
  "sender_id": 1,
  "receiver_id": 2,
  "chat": "Hola! :( issue of pusher"
}
```

### Mark Message as Read
- **PUT** `/api/chat/messages/read/{conversationId}`
- **Headers:** Authorization required

### Get Unread Count
- **GET** `/api/chat/unread-count`
- **Headers:** Authorization required

### Archive Conversation
- **PUT** `/api/chat/archive/{conversationId}`
- **Headers:** Authorization required

### Delete Conversation
- **DELETE** `/api/chat/delete/{conversationId}`
- **Headers:** Authorization required

### Start Conversation from Gig
- **POST** `/api/chat/start/{gigId}`
- **Headers:** Authorization required

### Get All Conversations
- **GET** `/api/chat/conversations`
- **Headers:** Authorization required

### Get Conversation Messages
- **GET** `/api/chat/conversation/{conversationId}`
- **Headers:** Authorization required

---

## Notifications APIs

### Get Notifications
- **GET** `/api/notifications?receiver_id={id}`
- **Headers:** Authorization required

### Mark Notification as Read
- **PUT** `/api/notifications/{id}/read`
- **Headers:** Authorization required

### Mark All Notifications as Read
- **PUT** `/api/notifications/read-all`
- **Headers:** Authorization required

### Delete Notification
- **DELETE** `/api/notifications/{id}`
- **Headers:** Authorization required

### Get Notification Settings
- **GET** `/api/notifications/settings`
- **Headers:** Authorization required

### Update Notification Settings
- **PUT** `/api/notifications/settings`
- **Headers:** Authorization required
- **Body:**
```json
{
  "email_notifications": true,
  "push_notifications": false
}
```

### Get Unread Notification Count
- **GET** `/api/notifications/unread-count`
- **Headers:** Authorization required

---

## Profile APIs

### Creator Profile

#### Get Creator Profile
- **GET** `/api/creator-profile/{id}`
- **Headers:** Authorization required

#### Create Creator Profile
- **POST** `/api/creator-profile`
- **Headers:** Authorization required
- **Body:**
```json
{
  "expertise": "Web Development",
  "about_me": "I am a passionate Laravel developer."
}
```

#### Update Creator Profile
- **PUT** `/api/creator-profile/{id}`
- **Headers:** Authorization required
- **Body:**
```json
{
  "expertise": "Your expertise",
  "about_me": "Your about me text",
  "skills": ["Skill 1", "Skill 2", "Skill 3"]
}
```

#### Delete Creator Profile
- **DELETE** `/api/creator-profile`
- **Headers:** Authorization required

#### Get Current Creator Profile
- **GET** `/api/creator/profile`
- **Headers:** Authorization required

#### Update Current Creator Profile
- **PUT** `/api/creator/profile`
- **Headers:** Authorization required
- **Body:**
```json
{
  "expertise": "Video Editing, Motion Graphics",
  "about_me": "I'm a passionate content creator focused on storytelling and visual design.",
  "title": "Senior Content Creator",
  "profile_picture": "https://example.com/images/profile.jpg",
  "address": "123 Main Street, Karachi, Pakistan",
  "skills": [
    { "name": "Adobe Premiere Pro" },
    { "name": "After Effects" },
    { "name": "Final Cut Pro" }
  ]
}
```

### Buyer Profile

#### Create Buyer Profile
- **POST** `/api/buyer-profile`
- **Headers:** Authorization required
- **Body:**
```json
{
  "contact_number": "03126419805",
  "about": "I am a Professional web Developer"
}
```

#### Get Buyer Profile
- **GET** `/api/buyer-profile/{id}`
- **Headers:** Authorization required

#### Update Buyer Profile
- **PUT** `/api/buyer-profile/{id}`
- **Headers:** Authorization required
- **Body:**
```json
{
  "name": "John Doe Updated",
  "contact_number": "9876543210",
  "about": "Updated about me section."
}
```

#### Delete Buyer Profile
- **DELETE** `/api/buyer-profile/{id}`
- **Headers:** Authorization required

### Skills

#### Add Skill
- **POST** `/api/skills`
- **Headers:** Authorization required
- **Body:**
```json
{
  "name": "Animation"
}
```

#### Update Skill
- **PUT** `/api/skills/{id}`
- **Headers:** Authorization required
- **Body:**
```json
{
  "name": "Vue.js"
}
```

#### Delete Skill
- **DELETE** `/api/skills/{id}`
- **Headers:** Authorization required

### Creator Services

#### Create Creator Service
- **POST** `/api/creator/services`
- **Headers:** Authorization required
- **Body:**
```json
{
  "service_title": "Web Designing",
  "service_price": 2000
}
```

#### Get Creator Services
- **GET** `/api/creator/services`
- **Headers:** Authorization required

#### Update Creator Service
- **PUT** `/api/creator/services/{id}`
- **Headers:** Authorization required
- **Body:**
```json
{
  "service_title": "Advanced Yoga Class",
  "service_price": 40.00
}
```

#### Delete Creator Service
- **DELETE** `/api/creator/services/{id}`
- **Headers:** Authorization required

### Search

#### Search Services
- **POST** `/api/services/search`
- **Headers:** Authorization required
- **Body:**
```json
{
  "keyword": "Web Designing"
}
```

#### Get Service Recommendations
- **GET** `/api/services/recommendations`
- **Headers:** Authorization required

---

## Payment APIs

### Create Payment Intent
- **POST** `/api/create-payment-intent`
- **Headers:** Authorization required
- **Body:**
```json
{
  "amount": 10,
  "plan": "premium",
  "currency": "usd",
  "gig_id": 2
}
```

### Process Stripe Webhook
- **POST** `/stripe/webhook`
- **Body:**
```json
{
  "type": "payment_intent.succeeded",
  "data": {
    "object": {
      "id": "pi_1Jgoy2IdH6O3J9rc5uHDZ3mR"
    }
  }
}
```

### Get Payment History
- **GET** `/api/payments/history`
- **Headers:** Authorization required

### Get Payment by ID
- **GET** `/api/payments/{id}`
- **Headers:** Authorization required

### Refund Payment
- **POST** `/api/payments/{id}/refund`
- **Headers:** Authorization required
- **Body:**
```json
{
  "amount": 10.0,
  "reason": "Customer request"
}
```

### Get Subscription Status
- **GET** `/api/subscription/status`
- **Headers:** Authorization required

### Cancel Subscription
- **POST** `/api/subscription/cancel`
- **Headers:** Authorization required

### Upgrade Subscription
- **POST** `/api/subscription/upgrade`
- **Headers:** Authorization required
- **Body:**
```json
{
  "new_plan": "premium"
}
```

### Get Available Plans
- **GET** `/api/subscription/plans`
- **Headers:** Authorization required

---

## Admin APIs

### Get Admin Dashboard
- **GET** `/api/admin/home`
- **Headers:** Authorization required

### Get Admin Dashboard (Alternative)
- **GET** `/api/admin/dashboard`
- **Headers:** Authorization required

### Get All Users
- **GET** `/api/admin/users`
- **Headers:** Authorization required

### Get Users by Role
- **GET** `/api/admin/users/{role}`
- **Headers:** Authorization required

### Get Admin Profile
- **GET** `/api/admin/me`
- **Headers:** Authorization required

### Update User Status
- **PUT** `/api/admin/user/status`
- **Headers:** Authorization required
- **Body:**
```json
{
  "user_id": 8,
  "status": "inactive"
}
```

### Deactivate User
- **PUT** `/api/admin/user/{id}/deactivate`
- **Headers:** Authorization required

### Reactivate User
- **PUT** `/api/admin/user/{id}/reactivate`
- **Headers:** Authorization required

### Change User Role
- **PUT** `/api/admin/user/{id}/change-role`
- **Headers:** Authorization required
- **Body:**
```json
{
  "role": "Buyer"
}
```

### Soft Delete User
- **DELETE** `/api/admin/user/delete?email={email}`
- **Headers:** Authorization required

### Restore User
- **POST** `/api/admin/restore-user`
- **Headers:** Authorization required
- **Body:**
```json
{
  "email": "asim@gmail.com"
}
```

### Get User Overview
- **GET** `/api/admin/user-overview`
- **Headers:** Authorization required

### Get Filtered User Overview
- **GET** `/api/admin/user-overview/filtered`
- **Headers:** Authorization required

### Resolve Dispute
- **POST** `/api/admin/resolve-dispute`
- **Headers:** Authorization required
- **Body:**
```json
{
  "dispute_id": 1,
  "resolution_comment": "Refund approved due to non-delivery of service."
}
```

### Get Creator Home Data (Admin View)
- **GET** `/api/creator-home`
- **Headers:** Authorization required

---

## Error Responses

All API endpoints return consistent error responses:

```json
{
  "success": false,
  "error": "Error message description",
  "statusCode": 400,
  "data": null
}
```

## Success Responses

Successful API calls return:

```json
{
  "success": true,
  "data": {
    // Response data
  },
  "statusCode": 200
}
```

## Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `500` - Internal Server Error

---

## Usage Examples

### Flutter/Dart Usage

```dart
import 'package:buddy/Backend/api/index.dart';

// Authentication
final authResult = await AuthApiService.login(
  email: 'user@example.com',
  password: 'password'
);

// Create Gig
final gigResult = await GigsApiService.createGig(
  label: 'Web Development',
  description: 'Professional web development services',
  startingPrice: '100.00',
  media: imageFile,
);

// Get Orders
final ordersResult = await OrdersApiService.getCreatorOrders();

// Send Chat Message
final chatResult = await ChatApiService.sendChatMessage(
  conversationId: 1,
  message: 'Hello!',
);
```

This documentation covers all the API endpoints from your Postman collection. Each service is properly organized and includes comprehensive error handling and response formatting.
