/// Query Client Configuration
///
/// This library provides the global configuration for FQuery, which handles
/// API data fetching, caching, and state management throughout the betaversion application.
///
/// The query client is configured with optimized defaults for educational content:
/// - 20-minute cache duration for relatively stable data
/// - 5-minute automatic refetch interval to keep content updated
/// - Refetch on mount only when data is stale
/// - 5-minute stale duration before considering data outdated
///
/// This configuration balances performance with data freshness, ensuring users
/// get responsive interactions while keeping content reasonably up-to-date.
///
/// Key features:
/// - Intelligent caching strategy for educational content
/// - Automatic background refetching for data freshness
/// - Stale-while-revalidate pattern for optimal UX
/// - Configurable retry behavior (currently disabled)
///
/// Example usage:
/// ```dart
/// // Used automatically by QueryClientProvider in main.dart
/// runApp(
///   QueryClientProvider(
///     queryClient: queryClient,
///     child: MyApp(),
///   ),
/// );
/// ```
library;

import 'package:fquery/fquery.dart';

/// Global query client instance for the betaversion application.
///
/// This client manages all API data fetching, caching, and synchronization
/// throughout the application. It's configured with default options optimized
/// for educational content that doesn't change frequently.
///
/// Configuration:
/// - [cacheDuration]: 20 minutes - How long data stays in cache
/// - [refetchInterval]: 5 minutes - Automatic refetch frequency
/// - [refetchOnMount]: Only when stale - When to refetch on component mount
/// - [staleDuration]: 5 minutes - When cached data is considered stale
/// - [retryCount]: Disabled - No automatic retries on failure
///
/// The client uses a stale-while-revalidate strategy, showing cached data
/// immediately while fetching fresh data in the background when needed.
final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(
    cacheDuration: const Duration(minutes: 20),
    refetchInterval: const Duration(minutes: 10),
    staleDuration: const Duration(minutes: 10),
    retryCount: 0,
  ),
);
