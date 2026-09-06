import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';
import '../../locations/bloc/location_bloc.dart';
import '../../weather/bloc/weather_bloc.dart';
import '../bloc/map_bloc.dart';

class WeatherMapPage extends StatefulWidget {
  const WeatherMapPage({super.key});

  @override
  State<WeatherMapPage> createState() => _WeatherMapPageState();
}

class _WeatherMapPageState extends State<WeatherMapPage> {
  final MapController _mapController = MapController();
  bool _isPlaying = false;
  double _timelineOffset = 0.0; // -2.0 to +1.0
  Timer? _playbackTimer;

  final List<LocationEntity> _quickCities = const [
    LocationEntity(cityName: 'Cairo', countryName: 'Egypt', latitude: 30.0444, longitude: 31.2357),
    LocationEntity(cityName: 'Alexandria', countryName: 'Egypt', latitude: 31.2001, longitude: 29.9187),
    LocationEntity(cityName: 'Dubai', countryName: 'UAE', latitude: 25.2048, longitude: 55.2708),
    LocationEntity(cityName: 'London', countryName: 'UK', latitude: 51.5074, longitude: -0.1278),
    LocationEntity(cityName: 'Paris', countryName: 'France', latitude: 48.8566, longitude: 2.3522),
    LocationEntity(cityName: 'New York', countryName: 'USA', latitude: 40.7128, longitude: -74.0060),
    LocationEntity(cityName: 'Tokyo', countryName: 'Japan', latitude: 35.6762, longitude: 139.6503),
  ];

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playbackTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
          setState(() {
            _timelineOffset += 0.5;
            if (_timelineOffset > 1.0) {
              _timelineOffset = -2.0;
            }
          });
        });
      } else {
        _playbackTimer?.cancel();
      }
    });
  }

  String _formatTimelineOffset(double val) {
    if (val.abs() < 0.1) return 'Now';
    if (val < 0) return '${val.abs().toStringAsFixed(1)}h ago';
    return '+${val.toStringAsFixed(1)}h';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseTileUrl = isDark
        ? 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
        : 'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.navRadar ?? 'Radar Map'),
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, weatherState) {
          if (weatherState is WeatherLoaded) {
            final target = LatLng(
              weatherState.fullWeather.current.dt > 0
                  ? (context.read<MapBloc>().state.center.latitude)
                  : 30.0444,
              context.read<MapBloc>().state.center.longitude,
            );
            _mapController.move(target, 6.0);
          }
        },
        builder: (context, weatherState) {
          String cityName = 'Cairo';

          if (weatherState is WeatherLoaded) {
            cityName = weatherState.fullWeather.current.cityName;
          }

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              final weatherTileUrl =
                  'https://tile.openweathermap.org/map/${mapState.activeLayer}/{z}/{x}/{y}.png?appid=$apiKey';

              return Stack(
                children: [
                  // Interactive Flutter Map
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: mapState.center,
                      initialZoom: mapState.zoom,
                      minZoom: 3.0,
                      maxZoom: 16.0,
                      onPositionChanged: (pos, _) {
                        context.read<MapBloc>().add(MoveMapCenterEvent(pos.center));
                      },
                    ),
                    children: [
                      // Base Map Tiles
                      TileLayer(
                        urlTemplate: baseTileUrl,
                        userAgentPackageName: 'com.hiweather.app',
                      ),

                      // OpenWeather Layer Overlay with Opacity
                      Opacity(
                        opacity: mapState.layerOpacity,
                        child: TileLayer(
                          urlTemplate: weatherTileUrl,
                          userAgentPackageName: 'com.hiweather.app',
                        ),
                      ),

                      // Pin for current location
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: mapState.center,
                            width: 80,
                            height: 80,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    cityName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Floating Layer Selector at Top
                  Positioned(
                    top: 14,
                    left: 14,
                    right: 14,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildLayerChip(
                            context: context,
                            label: l10n?.layerPrecipitation ?? 'Precipitation',
                            layerId: MapTileLayers.precipitation,
                            icon: Icons.water_drop_rounded,
                            activeLayer: mapState.activeLayer,
                          ),
                          const SizedBox(width: 8),
                          _buildLayerChip(
                            context: context,
                            label: l10n?.layerTemperature ?? 'Temperature',
                            layerId: MapTileLayers.temperature,
                            icon: Icons.thermostat_rounded,
                            activeLayer: mapState.activeLayer,
                          ),
                          const SizedBox(width: 8),
                          _buildLayerChip(
                            context: context,
                            label: l10n?.layerWind ?? 'Wind',
                            layerId: MapTileLayers.wind,
                            icon: Icons.air_rounded,
                            activeLayer: mapState.activeLayer,
                          ),
                          const SizedBox(width: 8),
                          _buildLayerChip(
                            context: context,
                            label: l10n?.layerClouds ?? 'Clouds',
                            layerId: MapTileLayers.clouds,
                            icon: Icons.cloud_rounded,
                            activeLayer: mapState.activeLayer,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Floating Quick Cities Bar
                  Positioned(
                    top: 66,
                    left: 14,
                    right: 14,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _quickCities.map((city) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ActionChip(
                              label: Text(city.cityName),
                              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              backgroundColor: Colors.black.withOpacity(0.55),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              onPressed: () {
                                final target = LatLng(city.latitude, city.longitude);
                                _mapController.move(target, 7.0);
                                context.read<WeatherBloc>().add(
                                      FetchWeatherEvent(
                                        latitude: city.latitude,
                                        longitude: city.longitude,
                                        cityName: city.cityName,
                                        countryName: city.countryName,
                                      ),
                                    );
                                context.read<LocationBloc>().add(SelectLocationEvent(city));
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Floating Zoom Controls
                  Positioned(
                    right: 16,
                    bottom: 180,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'map_zoom_in',
                          onPressed: () {
                            final newZoom = (_mapController.camera.zoom + 1.0).clamp(3.0, 16.0);
                            _mapController.move(_mapController.camera.center, newZoom);
                          },
                          child: const Icon(Icons.add_rounded),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: 'map_zoom_out',
                          onPressed: () {
                            final newZoom = (_mapController.camera.zoom - 1.0).clamp(3.0, 16.0);
                            _mapController.move(_mapController.camera.center, newZoom);
                          },
                          child: const Icon(Icons.remove_rounded),
                        ),
                      ],
                    ),
                  ),

                  // Radar Timeline Playback Controller at Bottom
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 96,
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      borderRadius: 20,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                            iconSize: 34,
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: _togglePlayback,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Radar Loop: ${_formatTimelineOffset(_timelineOffset)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    const Text(
                                      'Live Sim',
                                      style: TextStyle(fontSize: 10, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 3,
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  ),
                                  child: Slider(
                                    value: _timelineOffset,
                                    min: -2.0,
                                    max: 1.0,
                                    divisions: 6,
                                    onChanged: (val) {
                                      setState(() {
                                        _timelineOffset = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLayerChip({
    required BuildContext context,
    required String label,
    required String layerId,
    required IconData icon,
    required String activeLayer,
  }) {
    final isSelected = activeLayer == layerId;
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: () {
        context.read<MapBloc>().add(ChangeMapLayerEvent(layerId));
      },
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        borderRadius: 20,
        backgroundColor: isSelected
            ? primary.withOpacity(0.85)
            : Theme.of(context).colorScheme.surface.withOpacity(0.7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
