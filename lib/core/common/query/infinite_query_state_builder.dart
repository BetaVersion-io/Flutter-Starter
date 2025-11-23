import 'package:betaversion/core/ui/state/empty_state.dart';
import 'package:betaversion/core/ui/state/error_state.dart';
import 'package:betaversion/core/ui/state/no_internet_content.dart';
import 'package:betaversion/services/network/api_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:iconsax/iconsax.dart';

/// A widget that handles different states of infinite queries
///
/// This builder handles:
/// - Initial loading state
/// - Error state with retry
/// - Empty state when no data
/// - Success state with paginated data
/// - Loading next page state
///
/// Example usage:
/// ```dart
/// final query = useInfiniteFetchQuery(...);
///
/// return InfiniteQueryStateBuilder<MyData>(
///   queryResult: query,
///   onSuccess: (pages, hasNextPage, fetchNextPage, isFetchingNextPage) {
///     return ListView.builder(
///       itemCount: pages.length + (hasNextPage ? 1 : 0),
///       itemBuilder: (context, index) {
///         if (index < pages.length) {
///           return MyItem(data: pages[index]);
///         }
///         // Show loading indicator at the end
///         if (isFetchingNextPage) {
///           return CircularProgressIndicator();
///         }
///         // Load more button
///         return ElevatedButton(
///           onPressed: fetchNextPage,
///           child: Text('Load More'),
///         );
///       },
///     );
///   },
/// );
/// ```
class InfiniteQueryStateBuilder<T> extends StatelessWidget {
  /// The infinite query result from useInfiniteQuery
  final UseInfiniteQueryResult<T, ApiException, dynamic> queryResult;

  /// Builder for the success state with all pages data
  ///
  /// Parameters:
  /// - pages: List of all fetched pages
  /// - hasNextPage: Whether there are more pages to fetch
  /// - fetchNextPage: Function to fetch the next page
  /// - isFetchingNextPage: Whether the next page is currently being fetched
  final Widget Function(
    List<T> pages,
    bool hasNextPage,
    VoidCallback fetchNextPage,
    bool isFetchingNextPage,
  )
  onSuccess;

  /// Custom loading widget for initial load
  final Widget Function()? onLoading;

  /// Custom error widget
  final Widget Function(Object error)? onError;

  /// Custom empty state widget
  final Widget Function()? onEmpty;

  /// Custom initial state widget (before first fetch)
  final Widget Function()? onInitial;

  const InfiniteQueryStateBuilder({
    super.key,
    required this.queryResult,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onEmpty,
    this.onInitial,
  });

  @override
  Widget build(BuildContext context) {
    // Initial loading state (first page)
    if (queryResult.isLoading) {
      return onLoading?.call() ?? _buildDefaultLoading();
    }

    // Error state
    if (queryResult.isError) {
      return onError?.call(queryResult.error!) ?? _buildDefaultError(context);
    }

    // Empty state - no pages or first page is empty
    if (queryResult.data == null || queryResult.data!.pages.isEmpty) {
      return onEmpty?.call() ?? _buildDefaultEmpty();
    }

    // Success state with data
    return onSuccess(
      queryResult.data!.pages,
      queryResult.hasNextPage,
      queryResult.fetchNextPage,
      queryResult.isFetchingNextPage,
    );
  }

  Widget _buildDefaultLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildDefaultError(BuildContext context) {
    // Check if it's a network error
    if (queryResult.error!.isNetworkError) {
      return NoInternetContent();
    }

    // Check if it's a forbidden error (403)
    if (queryResult.error!.isForbidden) {
      return ErrorStateWidget(
        icon: Iconsax.lock,
        title: 'Access Denied',
        message: queryResult.error!.message,
        actionLabel: 'Go Back',
        onRetry: () => Navigator.of(context).pop(),
      );
    }

    // Show regular error state for other errors
    return ErrorStateWidget(
      icon: Iconsax.info_circle,
      title: 'Something went wrong',
      message: queryResult.error!.message,
    );
  }

  Widget _buildDefaultEmpty() {
    return EmptyStateWidget(
      icon: Icons.inbox_outlined,
      title: 'No data available',
    );
  }
}

/// A specialized builder for infinite list views
///
/// This widget automatically handles:
/// - List rendering with all items from all pages
/// - Loading indicator at the bottom while fetching next page
/// - Automatic load more when scrolling to the bottom
/// - Empty state
/// - Error state
///
/// Example usage:
/// ```dart
/// final query = useInfiniteFetchQuery(...);
///
/// return InfiniteListBuilder<MyData>(
///   queryResult: query,
///   itemBuilder: (context, data, index) {
///     return ListTile(title: Text(data.title));
///   },
///   separatorBuilder: (context, index) => Divider(),
/// );
/// ```
class InfiniteListBuilder<T> extends StatefulWidget {
  /// The infinite query result
  final UseInfiniteQueryResult<T, ApiException, dynamic> queryResult;

  /// Builder for individual items
  ///
  /// Parameters:
  /// - context: Build context
  /// - data: The data item
  /// - index: The global index across all pages
  final Widget Function(BuildContext context, T data, int index) itemBuilder;

  /// Optional separator builder between items
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Custom loading widget for initial load
  final Widget Function()? onLoading;

  /// Custom error widget
  final Widget Function(Object error)? onError;

  /// Custom empty state widget
  final Widget Function()? onEmpty;

  /// Custom loading indicator for fetching next page
  final Widget Function()? loadMoreIndicator;

  /// Whether to automatically load more when reaching the end
  final bool autoLoadMore;

  /// Padding for the list view
  final EdgeInsetsGeometry? padding;

  /// Whether to shrink wrap the list view
  final bool shrinkWrap;

  /// Scroll physics
  final ScrollPhysics? physics;

  const InfiniteListBuilder({
    super.key,
    required this.queryResult,
    required this.itemBuilder,
    this.separatorBuilder,
    this.onLoading,
    this.onError,
    this.onEmpty,
    this.loadMoreIndicator,
    this.autoLoadMore = true,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<InfiniteListBuilder<T>> createState() => _InfiniteListBuilderState<T>();
}

class _InfiniteListBuilderState<T> extends State<InfiniteListBuilder<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.autoLoadMore) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (widget.queryResult.hasNextPage &&
          !widget.queryResult.isFetchingNextPage) {
        widget.queryResult.fetchNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfiniteQueryStateBuilder<T>(
      queryResult: widget.queryResult,
      onLoading: widget.onLoading,
      onError: widget.onError,
      onEmpty: widget.onEmpty,
      onSuccess: (pages, hasNextPage, fetchNextPage, isFetchingNextPage) {
        // Flatten all pages into a single list
        final allItems = pages.expand((page) {
          // Handle both single items and lists
          if (page is List) {
            return page.cast<T>();
          }
          return [page];
        }).toList();

        // Calculate total item count (items + load more indicator if needed)
        final itemCount = allItems.length + (hasNextPage ? 1 : 0);

        if (widget.separatorBuilder != null) {
          return ListView.separated(
            controller: _scrollController,
            padding: widget.padding,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics,
            itemCount: itemCount,
            separatorBuilder: (context, index) {
              // Don't show separator for the last item (load more indicator)
              if (index >= allItems.length - 1 && hasNextPage) {
                return const SizedBox.shrink();
              }
              return widget.separatorBuilder!(context, index);
            },
            itemBuilder: (context, index) {
              if (index < allItems.length) {
                return widget.itemBuilder(context, allItems[index], index);
              }
              // Load more indicator
              return _buildLoadMoreIndicator(isFetchingNextPage, fetchNextPage);
            },
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: widget.padding,
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index < allItems.length) {
              return widget.itemBuilder(context, allItems[index], index);
            }
            // Load more indicator
            return _buildLoadMoreIndicator(isFetchingNextPage, fetchNextPage);
          },
        );
      },
    );
  }

  Widget _buildLoadMoreIndicator(
    bool isFetchingNextPage,
    VoidCallback fetchNextPage,
  ) {
    if (widget.loadMoreIndicator != null) {
      return widget.loadMoreIndicator!();
    }

    if (isFetchingNextPage) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Manual load more button (only shown when autoLoadMore is false)
    if (!widget.autoLoadMore) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ElevatedButton(
            onPressed: fetchNextPage,
            child: const Text('Load More'),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
