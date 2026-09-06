import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/usecases/location_usecases.dart';
import 'domain/usecases/weather_usecases.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/features/locations/bloc/location_bloc.dart';
import 'presentation/features/radar_map/bloc/map_bloc.dart';
import 'presentation/features/settings/bloc/settings_bloc.dart';
import 'presentation/features/weather/bloc/weather_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // If .env is missing, fallback to defaults
  }

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Dependency Injection
  await configureDependencies();

  runApp(const HiWeatherApp());
}

class HiWeatherApp extends StatelessWidget {
  const HiWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc(
            settingsBox: getIt(instanceName: AppConstants.settingsBoxName),
          ),
        ),
        BlocProvider<WeatherBloc>(
          create: (_) => WeatherBloc(
            getFullWeatherUseCase: getIt<GetFullWeatherUseCase>(),
            getCurrentLocationUseCase: getIt<GetCurrentLocationUseCase>(),
          )..add(FetchCurrentDeviceWeatherEvent()),
        ),
        BlocProvider<LocationBloc>(
          create: (_) => LocationBloc(
            getSavedLocationsUseCase: getIt<GetSavedLocationsUseCase>(),
            searchLocationsUseCase: getIt<SearchLocationsUseCase>(),
            saveLocationUseCase: getIt<SaveLocationUseCase>(),
            removeLocationUseCase: getIt<RemoveLocationUseCase>(),
            getCurrentLocationUseCase: getIt<GetCurrentLocationUseCase>(),
          )..add(LoadSavedLocationsEvent()),
        ),
        BlocProvider<MapBloc>(
          create: (_) => MapBloc(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          final localeCode = settingsState.locale.languageCode;

          return MaterialApp.router(
            title: 'HiWeather',
            debugShowCheckedModeBanner: false,
            locale: settingsState.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            themeMode: settingsState.themeMode,
            theme: AppTheme.lightTheme(locale: localeCode),
            darkTheme: AppTheme.darkTheme(locale: localeCode),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
