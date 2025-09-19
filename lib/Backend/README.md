# Buddy App Backend API Services

A comprehensive, professional-grade API service layer for the Buddy app that handles all backend communication with proper error handling, authentication, and response management.

## 🏗️ Architecture

The API service layer follows a modular, service-oriented architecture:

```
lib/Backend/
├── api_service.dart              # Core API service with HTTP methods
├── services/                     # Feature-specific service classes
│   ├── auth_service.dart         # Authentication & user management
│   ├── creator_service.dart      # Content creator operations
│   ├── buyer_service.dart        # Buyer operations
│   ├── admin_service.dart        # Admin operations
│   ├── notification_service.dart # Notifications & chat
│   └── payment_service.dart      # Payments & subscriptions
├── models/                       # Response models
│   └── api_response.dart         # Standardized response models
├── exceptions/                   # Custom exception classes
│   └── api_exceptions.dart       # API-specific exceptions
├── utils/                        # Utility functions
│   └── api_utils.dart            # Helper functions
└── index.dart                    # Main export file
```

## 🚀 Quick Start

### Import the API services

```dart
import 'package:buddy/Backend/index.dart';
```

### Basic Usage

```dart
// Authentication
final authResponse = await AuthService.login(
  email: 'user@example.com',
  password: 'password123',
);

if (authResponse['success']) {
  // Handle successful login
  print('Login successful: ${authResponse['data']}');
} else {
  // Handle error
  print('Login failed: ${authResponse['error']}');
}
```

## 📋 Service Overview

### 1. Authentication Service (`AuthService`)

Handles user authentication and account management.

**Key Methods:**
- `register()` - User registration
- `login()` - User login
- `logout()` - User logout
- `getCurrentUser()` - Get current user profile
- `socialLogin()` - Social media login
- `refreshToken()` - Refresh authentication token
- `forgotPassword()` - Password reset request
- `resetPassword()` - Reset password with token

**Example:**
```dart
// Register new user
final response = await AuthService.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  role: 'Buyer',
);

// Login user
final loginResponse = await AuthService.login(
  email: 'john@example.com',
  password: 'password123',
);
```

### 2. Creator Service (`CreatorService`)

Manages content creator operations including gigs, profiles, and orders.

**Key Methods:**
- **Gigs:** `createGig()`, `getGigs()`, `updateGig()`, `deleteGig()`
- **Stories:** `createStory()`, `getStories()`
- **Profile:** `createProfile()`, `getProfile()`, `updateProfile()`
- **Skills:** `addSkill()`, `updateSkill()`, `deleteSkill()`
- **Services:** `createService()`, `getServices()`, `updateService()`
- **Orders:** `getMyOrders()`, `respondToOrder()`, `uploadWork()`

**Example:**
```dart
// Create a gig
final gigResponse = await CreatorService.createGig(
  label: 'Web Design',
  description: 'Professional web design services',
  startingPrice: '100.00',
  mediaFile: File('path/to/image.jpg'),
);

// Get creator orders
final ordersResponse = await CreatorService.getMyOrders();
```

### 3. Buyer Service (`BuyerService`)

Handles buyer operations including orders, profiles, and search.

**Key Methods:**
- **Orders:** `createOrder()`, `getOrderDetails()`, `getAllOrders()`
- **Profile:** `createProfile()`, `getProfile()`, `updateProfile()`
- **Search:** `searchServices()`, `getServiceRecommendations()`
- **Chat:** `sendMessage()`, `getConversations()`, `startConversationFromGig()`
- **Disputes:** `createDispute()`, `getDisputes()`

**Example:**
```dart
// Create an order
final orderResponse = await BuyerService.createOrder(
  gigId: 1,
  buyerName: 'Jane Doe',
  email: 'jane@example.com',
  projectDetails: 'Need a logo for my startup',
  budget: 150.0,
  expectedDeliveryDate: '2024-02-01',
);

// Search services
final searchResponse = await BuyerService.searchServices(
  keyword: 'web design',
);
```

### 4. Admin Service (`AdminService`)

Manages administrative operations and platform oversight.

**Key Methods:**
- **Dashboard:** `getDashboard()`, `getAdminHome()`
- **Users:** `getAllUsers()`, `updateUserStatus()`, `deactivateUser()`
- **Disputes:** `getAllDisputes()`, `resolveDispute()`
- **Analytics:** `getPlatformStatistics()`, `getRevenueReports()`
- **Content:** `getReportedContent()`, `moderateContent()`

**Example:**
```dart
// Get admin dashboard
final dashboardResponse = await AdminService.getDashboard();

// Resolve dispute
final disputeResponse = await AdminService.resolveDispute(
  disputeId: 1,
  resolutionComment: 'Issue resolved through mediation',
  status: 'resolved',
);
```

### 5. Notification Service (`NotificationService`)

Handles notifications and real-time communication.

**Key Methods:**
- **Notifications:** `getNotifications()`, `markAsRead()`, `createNotification()`
- **Chat:** `sendMessage()`, `getConversations()`, `markMessageAsRead()`

**Example:**
```dart
// Get notifications
final notificationsResponse = await NotificationService.getNotifications();

// Send chat message
final chatResponse = await ChatService.sendMessage(
  conversationId: 1,
  message: 'Hello, I have a question about your service',
);
```

### 6. Payment Service (`PaymentService`)

Manages payments, subscriptions, and financial operations.

**Key Methods:**
- **Payments:** `createPaymentIntent()`, `confirmPayment()`, `getPaymentStatus()`
- **Subscriptions:** `createSubscription()`, `updateSubscription()`, `cancelSubscription()`
- **Invoices:** `getInvoices()`, `downloadInvoice()`
- **Refunds:** `createRefund()`, `getRefunds()`

**Example:**
```dart
// Create payment intent
final paymentResponse = await PaymentService.createPaymentIntent(
  amount: 100.0,
  plan: 'premium',
  currency: 'usd',
  gigId: 1,
);

// Get earnings
final earningsResponse = await PaymentService.getEarnings();
```

## 🔧 Core API Service

The `ApiService` class provides the foundation for all HTTP operations:

### HTTP Methods

```dart
// GET request
final response = await ApiService.get('/endpoint');

// POST request
final response = await ApiService.post('/endpoint', body: {'key': 'value'});

// PUT request
final response = await ApiService.put('/endpoint', body: {'key': 'value'});

// DELETE request
final response = await ApiService.delete('/endpoint');

// PATCH request
final response = await ApiService.patch('/endpoint', body: {'key': 'value'});

// Multipart POST (for file uploads)
final response = await ApiService.postMultipart(
  '/endpoint',
  fields: {'key': 'value'},
  files: {'file': File('path/to/file')},
);
```

### Response Format

All API responses follow a consistent format:

```dart
{
  'success': true,           // Boolean indicating success/failure
  'data': {...},            // Response data (if successful)
  'error': 'Error message', // Error message (if failed)
  'statusCode': 200,        // HTTP status code
  'message': 'Success',     // Optional message
  'meta': {...}             // Optional metadata
}
```

## 🛡️ Error Handling

The API service includes comprehensive error handling with custom exception classes:

### Exception Types

- `NetworkException` - Network connectivity issues
- `AuthenticationException` - Authentication failures (401)
- `AuthorizationException` - Permission denied (403)
- `ValidationException` - Input validation errors (422)
- `NotFoundException` - Resource not found (404)
- `ServerException` - Server errors (500+)

### Error Handling Example

```dart
try {
  final response = await AuthService.login(
    email: 'user@example.com',
    password: 'password',
  );
  
  if (response['success']) {
    // Handle success
  } else {
    // Handle API error
    print('Error: ${response['error']}');
  }
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
} on AuthenticationException catch (e) {
  print('Auth error: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

## 🔐 Authentication

The API service automatically handles authentication tokens:

1. **Token Storage:** Tokens are stored in SharedPreferences
2. **Automatic Headers:** Authorization headers are added automatically
3. **Token Refresh:** Automatic token refresh when needed
4. **Logout:** Tokens are cleared on logout

### Authentication Flow

```dart
// Login and store token
final loginResponse = await AuthService.login(
  email: 'user@example.com',
  password: 'password',
);

// Token is automatically stored and used for subsequent requests
final profileResponse = await AuthService.getCurrentUser();

// Logout clears token
await AuthService.logout();
```

## 📱 File Uploads

The API service supports file uploads through multipart requests:

```dart
// Upload single file
final response = await ApiService.postMultipart(
  '/upload',
  fields: {'description': 'Profile picture'},
  files: {'image': File('path/to/image.jpg')},
);

// Upload multiple files
final response = await ApiService.postMultipart(
  '/upload-multiple',
  fields: {'caption': 'Story content'},
  files: {
    'media[0]': File('path/to/image1.jpg'),
    'media[1]': File('path/to/image2.jpg'),
  },
);
```

## 🔄 Pagination

The API service supports pagination for list endpoints:

```dart
// Get paginated results
final response = await ApiService.get(
  '/items',
  queryParams: {
    'page': 1,
    'limit': 20,
  },
);

// Response includes pagination metadata
final pagination = response['data']['pagination'];
print('Total items: ${pagination['total']}');
print('Current page: ${pagination['currentPage']}');
```

## 🧪 Testing

The API service is designed to be easily testable:

```dart
// Mock API responses for testing
class MockApiService {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    // Return mock data
    return {
      'success': true,
      'data': {'mock': 'data'},
      'statusCode': 200,
    };
  }
}
```

## 📊 Monitoring & Logging

The API service includes built-in logging and monitoring:

```dart
// Enable debug logging
ApiService.enableDebugLogging = true;

// Custom error tracking
ApiService.onError = (error, stackTrace) {
  // Send to crash reporting service
  FirebaseCrashlytics.instance.recordError(error, stackTrace);
};
```

## 🚀 Performance Optimization

- **Request Caching:** Automatic caching of GET requests
- **Connection Pooling:** Reuse HTTP connections
- **Request Timeout:** Configurable timeout settings
- **Retry Logic:** Automatic retry for failed requests

## 📝 Best Practices

1. **Always check response success:** `if (response['success']) { ... }`
2. **Handle errors gracefully:** Use try-catch blocks
3. **Validate input:** Check parameters before API calls
4. **Use appropriate service:** Use feature-specific services
5. **Handle loading states:** Show loading indicators during API calls
6. **Cache when appropriate:** Cache frequently accessed data

## 🔧 Configuration

### Base URL Configuration

```dart
// Development
ApiService.baseUrl = 'http://127.0.0.1:8000/api';

// Production
ApiService.baseUrl = 'https://buddy.nexltech.com/public/api';
```

### Timeout Configuration

```dart
// Set request timeout
ApiService.requestTimeout = Duration(seconds: 30);
```

## 📚 API Endpoints Reference

The API service covers all endpoints from your Postman collection:

### Authentication
- `POST /register` - User registration
- `POST /login` - User login
- `POST /logout` - User logout
- `GET /user` - Get current user

### Content Creator
- `POST /gigs` - Create gig
- `GET /gigs` - Get gigs
- `PUT /gigs/{id}` - Update gig
- `DELETE /gigs/{id}` - Delete gig
- `POST /stories` - Create story
- `POST /creator/profile` - Create profile
- `GET /creator/profile` - Get profile

### Buyer
- `POST /orders` - Create order
- `GET /orders` - Get orders
- `POST /buyer-profile` - Create profile
- `POST /services/search` - Search services

### Admin
- `GET /admin/dashboard` - Get dashboard
- `GET /admin/users` - Get users
- `POST /admin/resolve-dispute` - Resolve dispute

### Notifications & Chat
- `GET /notifications` - Get notifications
- `POST /realtime-chat/send` - Send message
- `GET /chat/conversations` - Get conversations

### Payments
- `POST /create-payment-intent` - Create payment
- `POST /subscriptions` - Create subscription
- `GET /earnings` - Get earnings

## 🤝 Contributing

When adding new API endpoints:

1. Add methods to the appropriate service class
2. Follow the existing naming conventions
3. Include proper error handling
4. Add documentation comments
5. Update this README if needed

## 📄 License

This API service layer is part of the Buddy app project and follows the same licensing terms.
