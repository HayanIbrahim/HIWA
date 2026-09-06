class WeatherAlertEntity {
  final String senderName;
  final String event;
  final int start;
  final int end;
  final String description;

  const WeatherAlertEntity({
    required this.senderName,
    required this.event,
    required this.start,
    required this.end,
    required this.description,
  });
}
