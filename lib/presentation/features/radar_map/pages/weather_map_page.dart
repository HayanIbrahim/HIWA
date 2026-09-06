import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';
import '../../weather/bloc/weather_bloc.dart';
import '../bloc/map_bloc.dart';

class WeatherMapPage extends StatefulWidget {
  const WeatherMapPage({super.key});

  @override
  State<WeatherMapPage> createState() => _WeatherMapPageState();
}

class _WeatherMapPageState extends State<WeatherMapPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use CartoDB Dark Matter for dark mode and Positron for light mode
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
                    top: 16,
                    left: 16,
                    right: 16,
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

                  // Floating Zoom & Opacity Controls
                  Positioned(
                    bottom: 24,
                    right: 16,
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
