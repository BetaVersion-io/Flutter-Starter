import 'package:betaversion/core/common/query/infinite_query_state_builder.dart';
import 'package:betaversion/hooks/network/use_cancel_token.dart';
import 'package:betaversion/services/network/api_exceptions.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';

/// Enhanced useInfiniteQuery that automatically provides cancelToken and transforms DioExceptions
UseInfiniteQueryResult<TData, ApiException, int> useInfiniteFetchQuery<TData>(
  List<Object> queryKey,
  Future<TData> Function(int page, {CancelToken? cancelToken}) queryFn, {
  required int? Function(
    TData lastPage,
    List<TData> allPages,
    int lastPageParam,
    List<int> allPageParams,
  )
  getNextPageParam,
  int initialPageParam = 1,
  Duration? staleDuration,
  Duration? cacheDuration,
  bool enabled = true,
  TData? initialData,
  void Function(TData)? onSuccess,
  void Function(ApiException)? onError,
  Duration? refetchInterval,
  Duration? retryDelay,
  int? retryCount,
  RefetchOnMount? refetchOnMount,
}) {
  final cancelToken = useCancelToken();

  return useInfiniteQuery<TData, ApiException, int>(
    queryKey,
    (page) async {
      try {
        final data = await queryFn(page, cancelToken: cancelToken);
        onSuccess?.call(data);
        return data;
      } on ApiException catch (apiException) {
        AppLogger.e(apiException.message);
        onError?.call(apiException); // Call onError for ApiException
        rethrow;
      } on DioException catch (dioException) {
        final apiException = ApiException.fromDioError(dioException);
        onError?.call(apiException); // Call onError for DioException
        throw apiException;
      } catch (unknownException) {
        AppLogger.e(unknownException.toString());
        final apiException = ApiException('Unknown Error Occurred');
        onError?.call(apiException); // Call onError for unknown errors
        throw apiException;
      }
    },
    getNextPageParam: getNextPageParam,
    initialPageParam: initialPageParam,
    staleDuration: staleDuration,
    cacheDuration: cacheDuration,
    enabled: enabled,
    refetchInterval: refetchInterval,
    refetchOnMount: refetchOnMount,
    retryCount: retryCount,
    retryDelay: retryDelay,
  );
}

/// Extension to add builder method to UseInfiniteQueryResult
///
/// This allows you to easily build UI based on infinite query state:
///
/// Example usage:
/// ```dart
/// final query = useInfiniteFetchQuery(...);
///
/// return query.builder(
///   onSuccess: (pages, hasNextPage, fetchNextPage, isFetchingNextPage) {
///     return ListView.builder(
///       itemCount: pages.length,
///       itemBuilder: (context, index) => MyItem(data: pages[index]),
///     );
///   },
/// );
/// ```
extension InfiniteQueryStateBuilderExtension<T>
    on UseInfiniteQueryResult<T, ApiException, dynamic> {
  /// Build a widget based on the infinite query state
  ///
  /// Parameters:
  /// - onSuccess: Required builder for success state with paginated data
  /// - onLoading: Optional custom loading widget
  /// - onError: Optional custom error widget
  /// - onEmpty: Optional custom empty state widget
  /// - onInitial: Optional custom initial state widget
  Widget builder({
    required Widget Function(
      List<T> pages,
      bool hasNextPage,
      VoidCallback fetchNextPage,
      bool isFetchingNextPage,
    )
    onSuccess,
    Widget Function()? onLoading,
    Widget Function(Object error)? onError,
    Widget Function()? onEmpty,
    Widget Function()? onInitial,
  }) {
    return InfiniteQueryStateBuilder<T>(
      queryResult: this,
      onSuccess: onSuccess,
      onLoading: onLoading,
      onError: onError,
      onEmpty: onEmpty,
      onInitial: onInitial,
    );
  }

  /// Build an infinite list view automatically
  ///
  /// This is a convenience method that handles pagination automatically.
  ///
  /// Example usage:
  /// ```dart
  /// final query = useInfiniteFetchQuery(...);
  ///
  /// return query.listBuilder(
  ///   itemBuilder: (context, data, index) {
  ///     return ListTile(title: Text(data.name));
  ///   },
  ///   separatorBuilder: (context, index) => Divider(),
  /// );
  /// ```
  Widget listBuilder({
    required Widget Function(BuildContext context, T data, int index)
    itemBuilder,
    Widget Function(BuildContext context, int index)? separatorBuilder,
    Widget Function()? onLoading,
    Widget Function(Object error)? onError,
    Widget Function()? onEmpty,
    Widget Function()? loadMoreIndicator,
    bool autoLoadMore = true,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return InfiniteListBuilder<T>(
      queryResult: this,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      onLoading: onLoading,
      onError: onError,
      onEmpty: onEmpty,
      loadMoreIndicator: loadMoreIndicator,
      autoLoadMore: autoLoadMore,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
    );
  }
}
