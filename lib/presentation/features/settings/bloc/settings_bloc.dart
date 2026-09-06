import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/unit_converter.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class ChangeThemeModeEvent extends SettingsEvent {
  final ThemeMode themeMode;
  const ChangeThemeModeEvent(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class ChangeLocaleEvent extends SettingsEvent {
  final Locale locale;
  const ChangeLocaleEvent(this.locale);
  @override
  List<Object?> get props => [locale];
}

class ChangeUnitSystemEvent extends SettingsEvent {
  final UnitSystem unitSystem;
  const ChangeUnitSystemEvent(this.unitSystem);
  @override
  List<Object?> get props => [unitSystem];
}

// State
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final UnitSystem unitSystem;

  const SettingsState({
    required this.themeMode,
    required this.locale,
    required this.unitSystem,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    UnitSystem? unitSystem,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      unitSystem: unitSystem ?? this.unitSystem,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, unitSystem];
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Box settingsBox;

  SettingsBloc({required this.settingsBox})
      : super(SettingsState(
          themeMode: _loadInitialTheme(settingsBox),
          locale: _loadInitialLocale(settingsBox),
          unitSystem: _loadInitialUnits(settingsBox),
        )) {
    on<ChangeThemeModeEvent>((event, emit) {
      settingsBox.put(AppConstants.keyThemeMode, event.themeMode.name);
      emit(state.copyWith(themeMode: event.themeMode));
    });

    on<ChangeLocaleEvent>((event, emit) {
      settingsBox.put(AppConstants.keyLocale, event.locale.languageCode);
      emit(state.copyWith(locale: event.locale));
    });

    on<ChangeUnitSystemEvent>((event, emit) {
      settingsBox.put(AppConstants.keyUnits, event.unitSystem.name);
      emit(state.copyWith(unitSystem: event.unitSystem));
    });
  }

  static ThemeMode _loadInitialTheme(Box box) {
    final str = box.get(AppConstants.keyThemeMode) as String?;
    if (str == ThemeMode.light.name) return ThemeMode.light;
    if (str == ThemeMode.dark.name) return ThemeMode.dark;
    return ThemeMode.system;
  }

  static Locale _loadInitialLocale(Box box) {
    final str = box.get(AppConstants.keyLocale) as String?;
    if (str == 'ar') return const Locale('ar');
    return const Locale('en');
  }

  static UnitSystem _loadInitialUnits(Box box) {
    final str = box.get(AppConstants.keyUnits) as String?;
    if (str == UnitSystem.imperial.name) return UnitSystem.imperial;
    return UnitSystem.metric;
  }
}
