import '../../domain/entities/location_entity.dart';

class LocationDto {
  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;
  final bool isCurrentLocation;
  final bool isFavorite;
  final double? currentTemp;
  final String? condition;
  final String? iconCode;

  LocationDto({
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

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      latitude: (json['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['lon'] as num?)?.toDouble() ?? 0.0,
      cityName: json['name'] as String? ?? json['cityName'] as String? ?? 'Unknown',
      countryName: json['country'] as String? ?? json['countryName'] as String? ?? '',
      isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      currentTemp: (json['currentTemp'] as num?)?.toDouble(),
      condition: json['condition'] as String?,
      iconCode: json['iconCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lon': longitude,
      'cityName': cityName,
      'countryName': countryName,
      'isCurrentLocation': isCurrentLocation,
      'isFavorite': isFavorite,
      'currentTemp': currentTemp,
      'condition': condition,
      'iconCode': iconCode,
    };
  }

  LocationEntity toDomain() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      countryName: countryName,
      isCurrentLocation: isCurrentLocation,
      isFavorite: isFavorite,
      currentTemp: currentTemp,
      condition: condition,
      iconCode: iconCode,
    );
  }

  factory LocationDto.fromDomain(LocationEntity entity) {
    return LocationDto(
      latitude: entity.latitude,
      longitude: entity.longitude,
      cityName: entity.cityName,
      countryName: entity.countryName,
      isCurrentLocation: entity.isCurrentLocation,
      isFavorite: entity.isFavorite,
      currentTemp: entity.currentTemp,
      condition: entity.condition,
      iconCode: entity.iconCode,
    );
  }
}
