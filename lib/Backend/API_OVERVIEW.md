# Buddy App API Overview

## Complete API Integration

All APIs from your Postman collection have been integrated into the Flutter app with comprehensive services:

### Available API Services

1. **AuthApiService** - Authentication (login, register, social login)
2. **GigsApiService** - Gigs management (CRUD, filters, favorites)
3. **StoriesApiService** - Stories (create, view, like, comment)
4. **OrdersApiService** - Orders (create, manage, disputes)
5. **ChatApiService** - Real-time chat functionality
6. **NotificationsApiService** - Notifications management
7. **ProfileApiService** - User profiles (creator/buyer)
8. **PaymentApiService** - Payment processing (Stripe)
9. **AdminApiService** - Admin panel functionality

### Usage Example

```dart
import 'package:buddy/Backend/api/index.dart';

// Login
final result = await AuthApiService.login(
  email: 'user@example.com', 
  password: 'password'
);

// Create gig
final gigResult = await GigsApiService.createGig(
  label: 'Web Development',
  description: 'Professional services',
  startingPrice: '100.00',
  media: imageFile,
);
```

### Base URL Configuration
- Production: `https://buddy.nexltech.com/public/api`
- Development: `http://127.0.0.1:8000/api`

All endpoints support Bearer token authentication and comprehensive error handling.
