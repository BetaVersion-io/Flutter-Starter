import 'package:betaversion/core/common/query/query_state_builder.dart';
import 'package:betaversion/hooks/network/use_cancel_token.dart';
import 'package:betaversion/services/network/api_exceptions.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';

/// Enhanced useQuery that automatically provides cancelToken and transforms DioExceptions
UseQueryResult<TData, ApiException> useFetchQuery<TData>(
  List<Object> queryKey,
  Future<TData> Function({CancelToken? cancelToken}) queryFn, {
  Duration? staleDuration,
  Duration? cacheDuration,
  // RetryConfig? retryConfig,
  bool enabled = true,
  TData? initialData,
  bool keepPreviousData = false,
  void Function(TData)? onSuccess,
  void Function(ApiException)? onError,
  Duration? refetchInterval,
  Duration? retryDelay,
  int? retryCount,
  RefetchOnMount? refetchOnMount,
}) {
  final cancelToken = useCancelToken();

  return useQuery<TData, ApiException>(
    queryKey,
    () async {
      try {
        final data = await queryFn(cancelToken: cancelToken);
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
    staleDuration: staleDuration,
    cacheDuration: cacheDuration,
    enabled: enabled,
    refetchInterval: refetchInterval,
    refetchOnMount: refetchOnMount,
    retryCount: retryCount,
    retryDelay: retryDelay,
  );
}

extension QueryStateBuilderExtension<T> on UseQueryResult<T, ApiException> {
  Widget builder({
    required Widget Function(T data) onSuccess,
    Widget Function()? onLoading,
    Widget Function(Object error)? onError,
    Widget Function()? onEmpty,
    Widget Function()? onInitial,
  }) {
    return QueryStateBuilder<T>(
      queryResult: this,
      onSuccess: onSuccess,
      onLoading: onLoading,
      onError: onError,
      onEmpty: onEmpty,
      onInitial: onInitial,
    );
  }
}
