import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hi_weather_app/core/constants/api_constants.dart';
import 'package:hi_weather_app/core/utils/unit_converter.dart';
import 'package:hi_weather_app/presentation/features/radar_map/bloc/map_bloc.dart';
import 'package:hi_weather_app/presentation/features/settings/bloc/settings_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';

class MockBox extends Mock implements Box {}

void main() {
  group('SettingsBloc Tests', () {
    late MockBox mockSettingsBox;

    setUp(() {
      mockSettingsBox = MockBox();
      when(() => mockSettingsBox.get(any())).thenReturn(null);
      when(() => mockSettingsBox.put(any(), any())).thenAnswer((_) async {});
    });

    blocTest<SettingsBloc, SettingsState>(
      'emits dark ThemeMode when ChangeThemeModeEvent(ThemeMode.dark) is added',
      build: () => SettingsBloc(settingsBox: mockSettingsBox),
      act: (bloc) => bloc.add(const ChangeThemeModeEvent(ThemeMode.dark)),
      expect: () => [
        isA<SettingsState>().having((s) => s.themeMode, 'themeMode', ThemeMode.dark),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits Arabic locale when ChangeLocaleEvent(Locale("ar")) is added',
      build: () => SettingsBloc(settingsBox: mockSettingsBox),
      act: (bloc) => bloc.add(const ChangeLocaleEvent(Locale('ar'))),
      expect: () => [
        isA<SettingsState>().having((s) => s.locale.languageCode, 'locale', 'ar'),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'emits imperial unit system when ChangeUnitSystemEvent(UnitSystem.imperial) is added',
      build: () => SettingsBloc(settingsBox: mockSettingsBox),
      act: (bloc) => bloc.add(const ChangeUnitSystemEvent(UnitSystem.imperial)),
      expect: () => [
        isA<SettingsState>().having((s) => s.unitSystem, 'unitSystem', UnitSystem.imperial),
      ],
    );
  });

  group('MapBloc Tests', () {
    blocTest<MapBloc, MapState>(
      'emits updated activeLayer when ChangeMapLayerEvent is added',
      build: () => MapBloc(),
      act: (bloc) => bloc.add(const ChangeMapLayerEvent(MapTileLayers.temperature)),
      expect: () => [
        isA<MapState>().having((s) => s.activeLayer, 'activeLayer', MapTileLayers.temperature),
      ],
    );

    blocTest<MapBloc, MapState>(
      'emits updated center when MoveMapCenterEvent is added',
      build: () => MapBloc(),
      act: (bloc) => bloc.add(const MoveMapCenterEvent(LatLng(51.5074, -0.1278))),
      expect: () => [
        isA<MapState>().having((s) => s.center.latitude, 'latitude', 51.5074),
      ],
    );
  });
}
