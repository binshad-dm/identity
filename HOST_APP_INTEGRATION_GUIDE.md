# Host Application Integration Guide for `identity`

This guide explains how to integrate and use the **Identity** package in your Flutter host application.

---

## 1. Add Dependency

In your host application's `pubspec.yaml`, add the `identity` package as a path or git dependency:

```yaml
dependencies:
  flutter:
    sdk: flutter
  identity:
    path: ../identity # Adjust path to where identity is located
```

Run in terminal:
```bash
flutter pub get
```

---

## 2. Configuration & Initialization

Initialize the Identity SDK before navigating to any Identity screen (e.g., in `main()` or right after the user logs in to the host app).

### Option A: Programmatic Initialization (Recommended)

```dart
import 'package:identity/identity.dart';

Future<void> setupIdentity(HostAuthService authService, HostUser user) async {
  await IdentityAdmin.initialize(
    config: IdentityConfig(
      // Backend base URL
      baseUrl: 'https://api.yourdomain.com',

      // Optional dedicated microservice URLs (fallback to baseUrl if omitted):
      // authBaseUrl: 'https://auth.yourdomain.com',
      // userBaseUrl: 'https://users.yourdomain.com',
      // roleBaseUrl: 'https://roles.yourdomain.com',

      // Token supplier from host auth session
      getAccessToken: () async => await authService.getAccessToken(),

      // Optional: Handle 401 token refresh
      onRefreshToken: () async => await authService.refreshAccessToken(),

      // Optional: Session expired callback
      onSessionExpired: () {
        // e.g. Navigator.pushReplacementNamed(context, '/login');
      },

      // Currently logged-in host user
      currentUser: IdentityUser(
        id: user.id,
        userName: user.username,
        email: user.email,
      ),
    ),
  );
}
```

---

### Option B: YAML Asset Initialization

If you prefer configuring service endpoints via a YAML file:

1. Create `assets/config/identity.yaml` in your host app:
```yaml
identity:
  base_url: "https://api.yourdomain.com"
  auth_base_url: "https://auth.yourdomain.com"
  user_service_url: "https://users.yourdomain.com"
  role_service_url: "https://roles.yourdomain.com"
```

2. Register the asset in your host app's `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/config/identity.yaml
```

3. Initialize from YAML in your host app:
```dart
import 'package:identity/identity.dart';

await IdentityAdmin.initializeFromYaml(
  'assets/config/identity.yaml',
  getAccessToken: () async => await authService.getAccessToken(),
  onRefreshToken: () async => await authService.refreshAccessToken(),
  onSessionExpired: () => myRouter.goToLogin(),
  currentUser: IdentityUser(id: user.id, userName: user.username),
);
```

---

## 3. Configure Localization in `MaterialApp`

To enable translations and localized texts inside Identity views, include Identity's localization delegates in your root `MaterialApp` or `GetMaterialApp`:

```dart
import 'package:flutter/material.dart';
import 'package:identity/identity.dart';

class HostApp extends StatelessWidget {
  const HostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Host Application',
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        // Your host application localizations delegates here...
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HostHomePage(),
    );
  }
}
```

---

## 4. Navigating to Identity Views

The package exports both an **all-in-one dashboard** and **individual feature screens**.

### 4.1 All-in-One Dashboard (Responsive Web / Tablet / Mobile)

Provides a responsive layout (collapsible sidebar on desktop/tablet web, drawer on mobile) containing User Master, User Roles, and Login History:

```dart
import 'package:flutter/material.dart';
import 'package:identity/identity.dart';

// Using standard Navigator
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const IdentityDashboardPage()),
);

// Or with GetX:
// Get.to(() => const IdentityDashboardPage());
```

---

### 4.2 Standalone Feature Views

If your host application has its own navigation structure (custom drawer, tabs, or routes), you can embed the individual views directly:

#### A. User Master (`UserListPage`)
```dart
import 'package:identity/identity.dart';

// Standalone screen with default appbar
const UserListPage()

// Or embedded inside host app's scaffold (hide appbar or provide custom leading)
UserListPage(
  showAppBar: false, // Set false if host page has its own AppBar
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Navigator.pop(context),
  ),
)
```

#### B. User Roles Master (`RoleListPage`)
```dart
import 'package:identity/identity.dart';

const RoleListPage()
```

#### C. Login History (`LoginHistoryPage`)
```dart
import 'package:identity/identity.dart';

const LoginHistoryPage()
```

---

## 5. Handle Logout / Reset

When the user logs out of the host application, call `IdentityAdmin.reset()` to clear all cached tokens, HTTP interceptors, user data, and dependency states:

```dart
import 'package:identity/identity.dart';

Future<void> onHostUserLogout() async {
  // 1. Reset Identity SDK
  await IdentityAdmin.reset();

  // 2. Perform host app logout logic (clear local storage, redirect to login, etc.)
}
```
