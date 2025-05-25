enum NotificationType { success, error, warning, info }

class Notification {
  final String message;
  final NotificationType type;

  Notification({required this.message, required this.type});
}
