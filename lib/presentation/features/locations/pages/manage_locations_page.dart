import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/location_entity.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';
import '../../weather/bloc/weather_bloc.dart';
import '../bloc/location_bloc.dart';

class ManageLocationsPage extends StatefulWidget {
  const ManageLocationsPage({super.key});

  @override
  State<ManageLocationsPage> createState() => _ManageLocationsPageState();
}

class _ManageLocationsPageState extends State<ManageLocationsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(LoadSavedLocationsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onLocationSelected(LocationEntity location) {
    context.read<WeatherBloc>().add(
          FetchWeatherEvent(
            latitude: location.latitude,
            longitude: location.longitude,
            cityName: location.cityName,
            countryName: location.countryName,
          ),
        );
    context.read<LocationBloc>().add(SelectLocationEvent(location));
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.savedLocations ?? 'Saved Locations'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n?.searchLocationHint ?? 'Search city or region...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          context.read<LocationBloc>().add(const SearchCitiesEvent(''));
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
                ),
              ),
              onChanged: (query) {
                context.read<LocationBloc>().add(SearchCitiesEvent(query));
                setState(() {});
              },
            ),
          ),

          // Search Suggestions or Saved Locations
          Expanded(
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state.isSearching) {
                  return const Center(child: CircularProgressIndicator());
                }

                // If user is actively typing a query and has results
                if (_searchController.text.trim().isNotEmpty) {
                  if (state.searchResults.isEmpty) {
                    return Center(
                      child: Text(
                        'No results found for "${_searchController.text}"',
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: state.searchResults.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = state.searchResults[index];
                      final isSaved = state.savedLocations.any((l) =>
                          l.cityName.toLowerCase() == item.cityName.toLowerCase());

                      return GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.location_city_rounded,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            item.cityName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            item.countryName,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                              color: isSaved ? Colors.amber : null,
                            ),
                            onPressed: () {
                              context.read<LocationBloc>().add(ToggleSaveLocationEvent(item));
                            },
                          ),
                          onTap: () => _onLocationSelected(item),
                        ),
                      );
                    },
                  );
                }

                // Saved Locations List
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GPS Current Location quick button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: InkWell(
                        onTap: () {
                          context.read<WeatherBloc>().add(FetchCurrentDeviceWeatherEvent());
                          context.go('/');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.15),
                                theme.colorScheme.primary.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.my_location_rounded, color: theme.colorScheme.primary),
                              const SizedBox(width: 14),
                              Text(
                                l10n?.useCurrentLocation ?? 'Use Current Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Popular Cities Quick-Pick Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                      child: Text(
                        l10n?.popularCities ?? 'Popular Cities',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          _buildPopularCityChip('Cairo', 'Egypt', 30.0444, 31.2357),
                          _buildPopularCityChip('Dubai', 'UAE', 25.2048, 55.2708),
                          _buildPopularCityChip('London', 'UK', 51.5074, -0.1278),
                          _buildPopularCityChip('New York', 'USA', 40.7128, -74.0060),
                          _buildPopularCityChip('Paris', 'France', 48.8566, 2.3522),
                          _buildPopularCityChip('Tokyo', 'Japan', 35.6762, 139.6503),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (state.savedLocations.isEmpty)
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              l10n?.noSavedLocations ??
                                  'No saved locations yet. Search and tap bookmark to add one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                          itemCount: state.savedLocations.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final loc = state.savedLocations[index];

                            return Dismissible(
                              key: Key('${loc.cityName}_${loc.countryName}'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                              ),
                              onDismissed: (_) {
                                context.read<LocationBloc>().add(DeleteLocationEvent(loc));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${loc.cityName} removed'),
                                    action: SnackBarAction(
                                      label: 'UNDO',
                                      onPressed: () {
                                        context.read<LocationBloc>().add(ToggleSaveLocationEvent(loc));
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: GlassCard(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                child: InkWell(
                                  onTap: () => _onLocationSelected(loc),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.location_city_rounded,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              loc.cityName,
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              loc.countryName,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right_rounded),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCityChip(String city, String country, double lat, double lon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(city),
        avatar: const Icon(Icons.add_location_alt_outlined, size: 14),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          final loc = LocationEntity(
            cityName: city,
            countryName: country,
            latitude: lat,
            longitude: lon,
          );
          _onLocationSelected(loc);
        },
      ),
    );
  }
}
