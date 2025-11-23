# BetaVersion App Architecture

## Overview

The BetaVersion mobile application follows a **Feature-First Clean Architecture** approach, combining the benefits of modular development with clean architecture principles. This document outlines the architectural decisions, patterns, and best practices used throughout the codebase.

## Table of Contents

- [Architecture Layers](#architecture-layers)
- [Feature-First Organization](#feature-first-organization)
- [Design Patterns](#design-patterns)
- [State Management](#state-management)
- [Navigation](#navigation)
- [Data Flow](#data-flow)
- [Dependency Injection](#dependency-injection)
- [Error Handling](#error-handling)
- [Testing Strategy](#testing-strategy)

## Architecture Layers

The application is organized into the following layers:

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  (UI, Widgets, State Management)    │
└─────────────────────────────────────┘
              ↓↑
┌─────────────────────────────────────┐
│       Domain Layer                  │
│  (Business Logic, Use Cases)        │
└─────────────────────────────────────┘
              ↓↑
┌─────────────────────────────────────┐
│        Data Layer                   │
│  (Repositories, API, Storage)       │
└─────────────────────────────────────┘
```

### Presentation Layer

**Responsibility**: Display UI and handle user interactions

**Components**:

- **Pages/Screens**: Full-screen views
- **Widgets**: Reusable UI components
- **Providers**: State management using Riverpod
- **View Models**: Presentation logic

**Location**: `lib/features/*/presentation/`

**Key Principles**:

- UI components should be stateless when possible
- Use hooks for local state management
- Separate UI logic from business logic
- Responsive design for multiple screen sizes

### Domain Layer

**Responsibility**: Business logic and rules

**Components**:

- **Entities**: Core business objects
- **Use Cases**: Application-specific business rules
- **Repository Interfaces**: Contracts for data access
- **Domain Models**: Pure Dart objects

**Location**: `lib/features/*/domain/`

**Key Principles**:

- No dependencies on external frameworks
- Pure Dart code (framework-agnostic)
- Testable without UI or external dependencies
- Single Responsibility Principle

### Data Layer

**Responsibility**: Data access and persistence

**Components**:

- **Repositories**: Implement domain interfaces
- **Data Sources**: API clients, local storage
- **DTOs**: Data Transfer Objects for API communication
- **Mappers**: Convert between DTOs and domain models

**Location**: `lib/features/*/data/`

**Key Principles**:

- Abstract data sources behind repository pattern
- Handle data transformation
- Manage caching strategies
- Error handling and retry logic

## Feature-First Organization

Each feature is self-contained with its own presentation, domain, and data layers.

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_dto.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       ├── widgets/
│   │       │   └── login_form.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   ├── qbank/
│   ├── test/
│   └── ...
└── core/
    ├── common/
    ├── network/
    ├── storage/
    └── utils/
```

## Design Patterns

### Repository Pattern

Abstracts data sources and provides a clean API for data access.

```dart
// Domain layer - Interface
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
}

// Data layer - Implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userDto = await remoteDataSource.login(email, password);
      final user = userDto.toDomain();
      await localDataSource.saveUser(user);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

### Provider Pattern (Riverpod)

Used for dependency injection and state management.

```dart
// Provider definitions
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
  );
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
```

### Factory Pattern

Used for creating instances, especially for API clients and services.

```dart
class ApiClientFactory {
  static Dio create({required String baseUrl}) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      CacheInterceptor(),
    ]);
    return dio;
  }
}
```

### Observer Pattern

Implemented through Riverpod's state management for reactive updates.

### Singleton Pattern

Used for services that should have a single instance.

```dart
@Riverpod(keepAlive: true)
StorageService storageService(StorageServiceRef ref) {
  return StorageService();
}
```

## State Management

### Riverpod

Primary state management solution for the application.

**Types of Providers**:

1. **Provider**: Immutable data

   ```dart
   final configProvider = Provider((ref) => AppConfig());
   ```

2. **StateProvider**: Simple mutable state

   ```dart
   final counterProvider = StateProvider<int>((ref) => 0);
   ```

3. **StateNotifierProvider**: Complex state with business logic

   ```dart
   final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
     return AuthNotifier(ref.watch(authRepositoryProvider));
   });
   ```

4. **FutureProvider**: Async data fetching

   ```dart
   final userProvider = FutureProvider<User>((ref) async {
     return ref.watch(authRepositoryProvider).getCurrentUser();
   });
   ```

5. **StreamProvider**: Streaming data
   ```dart
   final notificationsProvider = StreamProvider<Notification>((ref) {
     return ref.watch(notificationServiceProvider).watchNotifications();
   });
   ```

### Flutter Hooks

Used for local widget state and lifecycle management.

```dart
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isVisible = useState(false);

    useEffect(() {
      // Setup and cleanup logic
      return () {
        // Cleanup
      };
    }, []);

    return TextField(controller: controller);
  }
}
```

## Navigation

### Go Router

Declarative routing with deep linking support.

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'qbank',
            builder: (context, state) => const QBankPage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
      if (!isAuthenticated && state.location != '/login') {
        return '/login';
      }
      return null;
    },
  );
});
```

**Route Structure**:

- `/splash` - Splash screen
- `/onboarding` - Onboarding flow
- `/login` - Authentication
- `/home` - Main app (bottom navigation)
  - `/home/qbank` - Question bank
  - `/home/tests` - Tests
  - `/home/videos` - Video lectures
  - `/home/profile` - User profile

## Data Flow

### Unidirectional Data Flow

```
User Action → Provider → Repository → API/Storage
                ↓
              State Update
                ↓
              UI Rebuild
```

### Example Flow: User Login

1. User enters credentials and taps "Login"
2. UI calls provider method: `authNotifier.login(email, password)`
3. Provider calls repository: `authRepository.login(email, password)`
4. Repository calls API: `authRemoteDataSource.login(email, password)`
5. API returns response
6. Repository maps DTO to domain model
7. Repository saves to local storage
8. Repository returns result to provider
9. Provider updates state
10. UI rebuilds with new state

## Dependency Injection

Using Riverpod for dependency injection.

### Service Location

```dart
// Define providers
final dioProvider = Provider<Dio>((ref) {
  return ApiClientFactory.create(baseUrl: Environment.apiUrl);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
  );
});

// Use in widget
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    // ...
  }
}
```

### Benefits

- Easy to test (mock dependencies)
- Loose coupling
- Single source of truth
- Lifecycle management

## Error Handling

### Result Type Pattern

Using `Either` from `dartz` package for explicit error handling.

```dart
// Domain layer
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

// Repository
Future<Either<Failure, User>> login(String email, String password) async {
  try {
    final user = await remoteDataSource.login(email, password);
    return Right(user);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } on NetworkException {
    return Left(NetworkFailure());
  } catch (e) {
    return Left(UnknownFailure());
  }
}

// Presentation
final result = await authRepository.login(email, password);
result.fold(
  (failure) => showError(failure.message),
  (user) => navigateToHome(),
);
```

### Global Error Handling

```dart
// main.dart
void main() {
  FlutterError.onError = (details) {
    // Log to crash reporting service
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    // Handle uncaught errors
    FirebaseCrashlytics.instance.recordError(error, stack);
  });
}
```

## Testing Strategy

### Unit Tests

Test business logic in isolation.

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('should return User when login is successful', () async {
    // Arrange
    when(mockRepository.login(any, any))
        .thenAnswer((_) async => Right(testUser));

    // Act
    final result = await useCase(email: 'test@test.com', password: 'pass');

    // Assert
    expect(result, Right(testUser));
    verify(mockRepository.login('test@test.com', 'pass'));
  });
}
```

### Widget Tests

Test UI components and interactions.

```dart
testWidgets('LoginPage displays correctly', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: LoginPage()),
    ),
  );

  expect(find.text('Login'), findsOneWidget);
  expect(find.byType(TextField), findsNWidgets(2));
});
```

### Integration Tests

Test complete user flows.

```dart
testWidgets('User can login successfully', (tester) async {
  await tester.pumpWidget(MyApp());

  // Navigate to login
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  // Enter credentials
  await tester.enterText(find.byKey(Key('email')), 'test@test.com');
  await tester.enterText(find.byKey(Key('password')), 'password');

  // Submit
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  // Verify navigation to home
  expect(find.text('Home'), findsOneWidget);
});
```

## Performance Considerations

### Lazy Loading

- Features loaded on demand
- Routes loaded when accessed
- Images loaded with pagination

### Caching

- API response caching with Dio Cache Interceptor
- Image caching with cached_network_image
- Local data caching with Hive/SharedPreferences

### Optimization

- Use `const` constructors where possible
- Implement `shouldRepaint` for custom painters
- Use `RepaintBoundary` for expensive widgets
- Implement pagination for large lists
- Use `AnimatedList` for list animations

## Security Considerations

- Secure storage for sensitive data (tokens, user info)
- SSL certificate pinning for API calls
- Input validation and sanitization
- No hardcoded secrets in code
- Environment-based configuration
- Token refresh mechanism

## Best Practices

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Dependency Inversion**: High-level modules don't depend on low-level modules
3. **Interface Segregation**: Use specific interfaces, not general ones
4. **Single Responsibility**: Each class has one reason to change
5. **Open/Closed**: Open for extension, closed for modification

## Future Improvements

- [ ] Implement offline-first architecture with sync
- [ ] Add GraphQL support
- [ ] Implement micro-frontends architecture
- [ ] Add A/B testing framework
- [ ] Implement feature flags system
- [ ] Add analytics pipeline
- [ ] Implement CI/CD with automated testing

## References

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Riverpod Documentation](https://riverpod.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)

---

**Last Updated**: November 2024

For questions about architecture decisions, contact the mobile team lead or start a discussion in #mobile-architecture Slack channel.
