class LocationEntity {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;
  final bool isCurrentLocation;
  final bool isFavorite;
  final double? currentTemp;
  final String? condition;
  final String? iconCode;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
    this.isCurrentLocation = false,
    this.isFavorite = false,
    this.currentTemp,
    this.condition,
    this.iconCode,
  });

  LocationEntity copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? countryName,
    bool? isCurrentLocation,
    bool? isFavorite,
    double? currentTemp,
    String? condition,
    String? iconCode,
  }) {
    return LocationEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
      isFavorite: isFavorite ?? this.isFavorite,
      currentTemp: currentTemp ?? this.currentTemp,
      condition: condition ?? this.condition,
      iconCode: iconCode ?? this.iconCode,
    );
  }
}
