import 'dart:async';

import 'package:betaversion/hooks/network/use_cancel_token.dart';
import 'package:betaversion/services/network/api_exceptions.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:go_router/go_router.dart';

/// Enhanced useMutation that automatically provides cancelToken and transforms DioExceptions
UseMutationResult<TData, ApiException, TVariables>
useFetchMutation<TData, TVariables, TContext>(
  Future<TData> Function(TVariables variables, {CancelToken? cancelToken})
  mutationFn, {
  String? successMessage,
  String Function(TData data, TVariables variables)? dynamicSuccessMessage,
  String? errorMessage,
  String Function(ApiException error, TVariables variables)?
  dynamicErrorMessage,
  bool popOnSuccess = false,
  bool popOnError = false,
  bool Function(TData data, TVariables variables)? dynamicPopCondition,
  void Function(ApiException, TVariables, TContext?)? onError,
  FutureOr<TContext>? Function(TVariables)? onMutate,
  void Function(TData?, ApiException?, TVariables, TContext?)? onSettled,
  void Function(TData, TVariables, TContext?)? onSuccess,
}) {
  final cancelToken = useCancelToken();
  final context = useContext();

  return useMutation<TData, ApiException, TVariables, TContext>(
    (TVariables variables) async {
      try {
        final data = await mutationFn(variables, cancelToken: cancelToken);
        return data;
      } on ApiException catch (_) {
        rethrow;
      } on DioException catch (dioException) {
        throw ApiException.fromDioError(dioException);
      } catch (unknownException) {
        final errorMessage = unknownException.toString();
        throw ApiException('Error: $errorMessage');
      }
    },
    onError:
        (ApiException error, TVariables variables, TContext? mutationContext) {
          AppLogger.e(error.message);
          // Show error snackbar if BuildContext is provided
          if (context.mounted) {
            final message =
                dynamicErrorMessage?.call(error, variables) ??
                errorMessage ??
                error.message;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: context.customColors.error,
              ),
            );

            if (popOnError) {
              context.pop();
            }
          }

          // Call custom onError if provided
          onError?.call(error, variables, mutationContext);
        },
    onMutate: onMutate,
    onSettled: onSettled,
    onSuccess: (TData data, TVariables variables, TContext? mutationContext) {
      // Show success snackbar if BuildContext is provided
      if (context.mounted) {
        final message =
            dynamicSuccessMessage?.call(data, variables) ?? successMessage;

        if (message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: context.customColors.success,
            ),
          );
        }

        // Handle screen pop based on conditions
        final shouldPop =
            dynamicPopCondition?.call(data, variables) ?? popOnSuccess;
        if (shouldPop) {
          context.pop();
        }
      }

      // Call custom onSuccess if provided
      onSuccess?.call(data, variables, mutationContext);
    },
  );
}
