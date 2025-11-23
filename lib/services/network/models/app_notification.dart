/// Types of notifications that can be sent from the backend
enum NotificationType {
  /// Informational message (blue, non-blocking)
  info,

  /// Warning message (orange, non-blocking by default)
  warning,

  /// Error message (red, may be blocking)
  error,

  /// Success message (green, non-blocking)
  success,

  /// Blocking message that prevents further action
  blocked,
}

/// Severity level determines how the notification is displayed
enum NotificationSeverity {
  /// User can dismiss and continue
  nonBlocking,

  /// User must acknowledge, blocks further action
  blocking,

  /// App navigation is blocked until resolved
  critical,
}

/// Display type for the notification
enum NotificationDisplayType {
  /// Show as a snackbar (brief, auto-dismiss)
  snackbar,

  /// Show as a dialog (modal)
  dialog,

  /// Show as a bottom sheet
  bottomSheet,

  /// Show as a banner at top
  banner,
}

/// Action button configuration
class NotificationAction {
  final String label;
  final String action; // 'dismiss', 'navigate', 'retry', 'logout', etc.
  final String? route; // Route to navigate to if action is 'navigate'
  final Map<String, dynamic>? data; // Additional data for the action

  NotificationAction({
    required this.label,
    required this.action,
    this.route,
    this.data,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) {
    return NotificationAction(
      label: json['label'] as String,
      action: json['action'] as String,
      route: json['route'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'action': action,
      if (route != null) 'route': route,
      if (data != null) 'data': data,
    };
  }
}

/// Complete notification model
class AppNotification {
  final NotificationType type;
  final NotificationSeverity severity;
  final NotificationDisplayType displayType;
  final String title;
  final String message;
  final bool dismissible;
  final List<NotificationAction> actions;
  final Map<String, dynamic>? metadata;

  AppNotification({
    required this.type,
    required this.severity,
    required this.displayType,
    required this.title,
    required this.message,
    this.dismissible = true,
    this.actions = const [],
    this.metadata,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.info,
      ),
      severity: NotificationSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => NotificationSeverity.nonBlocking,
      ),
      displayType: NotificationDisplayType.values.firstWhere(
        (e) => e.name == json['displayType'],
        orElse: () => NotificationDisplayType.dialog,
      ),
      title: json['title'] as String,
      message: json['message'] as String,
      dismissible: json['dismissible'] as bool? ?? true,
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map(
                (e) => NotificationAction.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'severity': severity.name,
      'displayType': displayType.name,
      'title': title,
      'message': message,
      'dismissible': dismissible,
      'actions': actions.map((e) => e.toJson()).toList(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Helper to check if this notification blocks user action
  bool get isBlocking =>
      severity == NotificationSeverity.blocking ||
      severity == NotificationSeverity.critical;
}

/// Response wrapper that includes data and notifications
class ApiResponse<T> {
  final T? data;
  final List<AppNotification> notifications;
  final Map<String, dynamic>? meta;

  ApiResponse({this.data, this.notifications = const [], this.meta});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return ApiResponse<T>(
      data: dataParser != null && json['data'] != null
          ? dataParser(json['data'])
          : json['data'] as T?,
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'notifications': notifications.map((e) => e.toJson()).toList(),
      if (meta != null) 'meta': meta,
    };
  }

  /// Check if response has any blocking notifications
  bool get hasBlockingNotifications => notifications.any((n) => n.isBlocking);
}
