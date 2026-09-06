import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/weather_mapper.dart';
import '../../../common_widgets/error_view.dart';
import '../../../common_widgets/offline_badge.dart';
import '../../../common_widgets/shimmer_loader.dart';
import '../../settings/bloc/settings_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/dynamic_weather_background.dart';
import '../widgets/hourly_forecast_strip.dart';
import '../widgets/minutely_rain_chart.dart';
import '../widgets/weather_alert_banner.dart';
import '../widgets/weather_metrics_grid.dart';

class WeatherHomePage extends StatelessWidget {
  const WeatherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, weatherState) {
            if (weatherState is WeatherInitial || weatherState is WeatherLoading) {
              return const Scaffold(
                body: SafeArea(child: ShimmerLoader()),
              );
            }

            if (weatherState is WeatherError) {
              return Scaffold(
                body: SafeArea(
                  child: ErrorView(
                    message: weatherState.message,
                    onRetry: () {
                      context.read<WeatherBloc>().add(FetchCurrentDeviceWeatherEvent());
                    },
                  ),
                ),
              );
            }

            if (weatherState is WeatherLoaded) {
              final weather = weatherState.fullWeather.current;
              final weatherType = WeatherMapper.getWeatherType(
                weather.iconCode,
                weather.weatherId,
              );

              return Scaffold(
                body: DynamicWeatherBackground(
                  weatherType: weatherType,
                  child: SafeArea(
                    child: RefreshIndicator(
                      color: Theme.of(context).colorScheme.primary,
                      onRefresh: () async {
                        context.read<WeatherBloc>().add(RefreshCurrentWeatherEvent());
                        await Future.delayed(const Duration(milliseconds: 600));
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        children: [
                          // Offline Cached Indicator (if applicable)
                          if (weatherState.isOffline) ...[
                            Center(child: OfflineBadge(cachedAt: weather.cachedAt)),
                            const SizedBox(height: 8),
                          ],

                          // Current Weather Hero
                          CurrentWeatherCard(
                            weather: weather,
                            unitSystem: settingsState.unitSystem,
                          ),

                          const SizedBox(height: 20),

                          // Active Severe Weather Alerts
                          if (weatherState.fullWeather.alerts.isNotEmpty) ...[
                            WeatherAlertBanner(alerts: weatherState.fullWeather.alerts),
                            const SizedBox(height: 16),
                          ],

                          // Next-hour Precipitation Rate
                          if (weatherState.fullWeather.minutely.isNotEmpty) ...[
                            MinutelyRainChart(minutelyList: weatherState.fullWeather.minutely),
                            const SizedBox(height: 16),
                          ],

                          // 48-Hour Hourly Forecast
                          if (weatherState.fullWeather.hourly.isNotEmpty) ...[
                            HourlyForecastStrip(
                              hourlyForecasts: weatherState.fullWeather.hourly,
                              unitSystem: settingsState.unitSystem,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // 8-Day Daily Forecast
                          if (weatherState.fullWeather.daily.isNotEmpty) ...[
                            DailyForecastList(
                              dailyForecasts: weatherState.fullWeather.daily,
                              unitSystem: settingsState.unitSystem,
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Detailed Weather Metrics
                          WeatherMetricsGrid(
                            weather: weather,
                            unitSystem: settingsState.unitSystem,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
