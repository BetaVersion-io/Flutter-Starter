import 'package:betaversion/core/ui/state/empty_state.dart';
import 'package:betaversion/core/ui/state/error_state.dart';
import 'package:betaversion/core/ui/state/no_internet_content.dart';
import 'package:betaversion/services/network/api_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:iconsax/iconsax.dart';

class QueryStateBuilder<T> extends StatelessWidget {
  final UseQueryResult<T, ApiException> queryResult;
  final Widget Function(T data) onSuccess;
  final Widget Function()? onLoading;
  final Widget Function(Object error)? onError;
  final Widget Function()? onEmpty;
  final Widget Function()? onInitial;

  const QueryStateBuilder({
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
    // Loading state
    if (queryResult.isLoading) {
      return onLoading?.call() ?? _buildDefaultLoading();
    }

    // Error state
    if (queryResult.isError) {
      return onError?.call(queryResult.error!) ?? _buildDefaultError(context);
    }

    // Empty state
    if (queryResult.data == null ||
        (queryResult.data is List && (queryResult.data as List).isEmpty)) {
      return onEmpty?.call() ?? _buildDefaultEmpty();
    }

    // Success state
    return onSuccess(queryResult.data as T);
  }

  Widget _buildDefaultLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildDefaultError(BuildContext context) {
    // Check if it's a network error
    if (queryResult.error!.isNetworkError) {
      return NoInternetContent(onRetry: queryResult.refetch);
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
      actionLabel: 'Retry',
      onRetry: queryResult.refetch,
    );
  }

  Widget _buildDefaultEmpty() {
    return EmptyStateWidget(
      icon: Icons.inbox_outlined,
      title: 'No data available',
    );
  }
}
