import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'HiWeather'**
  String get appTitle;

  /// No description provided for @navWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get navWeather;

  /// No description provided for @navRadar.
  ///
  /// In en, this message translates to:
  /// **'Radar'**
  String get navRadar;

  /// No description provided for @navLocations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get navLocations;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @currentWeather.
  ///
  /// In en, this message translates to:
  /// **'Current Weather'**
  String get currentWeather;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like {temp}'**
  String feelsLike(String temp);

  /// No description provided for @highLow.
  ///
  /// In en, this message translates to:
  /// **'H: {high}  L: {low}'**
  String highLow(String high, String low);

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'48-Hour Forecast'**
  String get hourlyForecast;

  /// No description provided for @dailyForecast.
  ///
  /// In en, this message translates to:
  /// **'8-Day Forecast'**
  String get dailyForecast;

  /// No description provided for @weatherAlerts.
  ///
  /// In en, this message translates to:
  /// **'Weather Alerts'**
  String get weatherAlerts;

  /// No description provided for @rainChance.
  ///
  /// In en, this message translates to:
  /// **'Chance of Rain'**
  String get rainChance;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No active weather alerts'**
  String get noAlerts;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV Index'**
  String get uvIndex;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @dewPoint.
  ///
  /// In en, this message translates to:
  /// **'Dew Point'**
  String get dewPoint;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @searchLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Search city or region...'**
  String get searchLocationHint;

  /// No description provided for @savedLocations.
  ///
  /// In en, this message translates to:
  /// **'Saved Locations'**
  String get savedLocations;

  /// No description provided for @noSavedLocations.
  ///
  /// In en, this message translates to:
  /// **'No saved locations yet. Search and tap bookmark to add one.'**
  String get noSavedLocations;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied. Please enable it in Settings.'**
  String get locationPermissionDenied;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled on your device.'**
  String get locationServicesDisabled;

  /// No description provided for @radarLayers.
  ///
  /// In en, this message translates to:
  /// **'Radar Layers'**
  String get radarLayers;

  /// No description provided for @layerPrecipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get layerPrecipitation;

  /// No description provided for @layerTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get layerTemperature;

  /// No description provided for @layerWind.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get layerWind;

  /// No description provided for @layerClouds.
  ///
  /// In en, this message translates to:
  /// **'Clouds'**
  String get layerClouds;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageAr.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageAr;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units of Measurement'**
  String get units;

  /// No description provided for @unitMetric.
  ///
  /// In en, this message translates to:
  /// **'Metric (°C, m/s)'**
  String get unitMetric;

  /// No description provided for @unitImperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial (°F, mph)'**
  String get unitImperial;

  /// No description provided for @offlineNotice.
  ///
  /// In en, this message translates to:
  /// **'Showing cached weather data'**
  String get offlineNotice;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading weather data.'**
  String get errorOccurred;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh'**
  String get pullToRefresh;

  /// No description provided for @airQuality.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQuality;

  /// No description provided for @airQualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get airQualityGood;

  /// No description provided for @airQualityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get airQualityModerate;

  /// No description provided for @airQualityUnhealthySensitive.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy for Sensitive'**
  String get airQualityUnhealthySensitive;

  /// No description provided for @airQualityUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get airQualityUnhealthy;

  /// No description provided for @airQualityVeryUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Very Unhealthy'**
  String get airQualityVeryUnhealthy;

  /// No description provided for @airQualityHazardous.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get airQualityHazardous;

  /// No description provided for @sunAndMoon.
  ///
  /// In en, this message translates to:
  /// **'Sun & Moon'**
  String get sunAndMoon;

  /// No description provided for @daylightRemaining.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m of daylight left'**
  String daylightRemaining(int hours, int minutes);

  /// No description provided for @nightRemaining.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m until sunrise'**
  String nightRemaining(int hours, int minutes);

  /// No description provided for @goldenHour.
  ///
  /// In en, this message translates to:
  /// **'Golden Hour'**
  String get goldenHour;

  /// No description provided for @moonPhase.
  ///
  /// In en, this message translates to:
  /// **'Moon Phase'**
  String get moonPhase;

  /// No description provided for @windCompass.
  ///
  /// In en, this message translates to:
  /// **'Wind & Direction'**
  String get windCompass;

  /// No description provided for @windGust.
  ///
  /// In en, this message translates to:
  /// **'Gusts up to {speed}'**
  String windGust(String speed);

  /// No description provided for @hourlyCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get hourlyCards;

  /// No description provided for @hourlyChart.
  ///
  /// In en, this message translates to:
  /// **'Trend Chart'**
  String get hourlyChart;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewMore;

  /// No description provided for @viewLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get viewLess;

  /// No description provided for @popularCities.
  ///
  /// In en, this message translates to:
  /// **'Popular Cities'**
  String get popularCities;

  /// No description provided for @radarPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get radarPlay;

  /// No description provided for @radarPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get radarPause;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
