import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../network/dio_client.dart';
import '../services/location_service.dart';
import '../../data/datasources/location_data_source.dart';
import '../../data/datasources/weather_local_data_source.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/i_location_repository.dart';
import '../../domain/repositories/i_weather_repository.dart';
import '../../domain/usecases/location_usecases.dart';
import '../../domain/usecases/weather_usecases.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Hive Boxes
  final weatherBox = await Hive.openBox(AppConstants.weatherBoxName);
  final locationsBox = await Hive.openBox(AppConstants.locationsBoxName);
  final settingsBox = await Hive.openBox(AppConstants.settingsBoxName);

  getIt.registerLazySingleton<Box>(() => weatherBox, instanceName: AppConstants.weatherBoxName);
  getIt.registerLazySingleton<Box>(() => locationsBox, instanceName: AppConstants.locationsBoxName);
  getIt.registerLazySingleton<Box>(() => settingsBox, instanceName: AppConstants.settingsBoxName);

  // Core & Network Services
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<LocationService>(() => LocationService());

  // Data Sources
  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
  );
  getIt.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(
      weatherBox: getIt<Box>(instanceName: AppConstants.weatherBoxName),
    ),
  );
  getIt.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(
      locationService: getIt<LocationService>(),
      dioClient: getIt<DioClient>(),
      locationsBox: getIt<Box>(instanceName: AppConstants.locationsBoxName),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<IWeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt<WeatherRemoteDataSource>(),
      localDataSource: getIt<WeatherLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<ILocationRepository>(
    () => LocationRepositoryImpl(
      dataSource: getIt<LocationDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<GetFullWeatherUseCase>(
    () => GetFullWeatherUseCase(getIt<IWeatherRepository>()),
  );
  getIt.registerLazySingleton<GetCachedWeatherUseCase>(
    () => GetCachedWeatherUseCase(getIt<IWeatherRepository>()),
  );
  getIt.registerLazySingleton<GetCurrentLocationUseCase>(
    () => GetCurrentLocationUseCase(getIt<ILocationRepository>()),
  );
  getIt.registerLazySingleton<SearchLocationsUseCase>(
    () => SearchLocationsUseCase(getIt<ILocationRepository>()),
  );
  getIt.registerLazySingleton<GetSavedLocationsUseCase>(
    () => GetSavedLocationsUseCase(getIt<ILocationRepository>()),
  );
  getIt.registerLazySingleton<SaveLocationUseCase>(
    () => SaveLocationUseCase(getIt<ILocationRepository>()),
  );
  getIt.registerLazySingleton<RemoveLocationUseCase>(
    () => RemoveLocationUseCase(getIt<ILocationRepository>()),
  );
}
