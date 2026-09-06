// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'هاي ويذر';

  @override
  String get navWeather => 'الطقس';

  @override
  String get navRadar => 'الرادار';

  @override
  String get navLocations => 'المواقع';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get currentWeather => 'الطقس الحالي';

  @override
  String feelsLike(String temp) {
    return 'يبدو كأنه $temp';
  }

  @override
  String highLow(String high, String low) {
    return 'ع: $high  د: $low';
  }

  @override
  String get hourlyForecast => 'توقعات 48 ساعة';

  @override
  String get dailyForecast => 'توقعات 8 أيام';

  @override
  String get weatherAlerts => 'تنبيهات الطقس';

  @override
  String get rainChance => 'فرصة هطول الأمطار';

  @override
  String get noAlerts => 'لا توجد تنبيهات جوية نشطة';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get windSpeed => 'سرعة الرياح';

  @override
  String get pressure => 'الضغط الجوي';

  @override
  String get uvIndex => 'مؤشر الأشعة فوق البنفسجية';

  @override
  String get visibility => 'مدى الرؤية';

  @override
  String get dewPoint => 'نقطة الندى';

  @override
  String get sunrise => 'الشروق';

  @override
  String get sunset => 'الغروب';

  @override
  String get searchLocationHint => 'ابحث عن مدينة أو منطقة...';

  @override
  String get savedLocations => 'المواقع المحفوظة';

  @override
  String get noSavedLocations =>
      'لا توجد مواقع محفوظة بعد. ابحث وأضف موقعك المفضل.';

  @override
  String get useCurrentLocation => 'استخدام موقعي الحالي';

  @override
  String get locationPermissionDenied =>
      'تم رفض إذن الوصول للموقع. يرجى تفعيله من الإعدادات.';

  @override
  String get locationServicesDisabled =>
      'خدمات تحديد الموقع غير مفعلة على جهازك.';

  @override
  String get radarLayers => 'طبقات الرادار';

  @override
  String get layerPrecipitation => 'الأمطار';

  @override
  String get layerTemperature => 'درجة الحرارة';

  @override
  String get layerWind => 'سرعة الرياح';

  @override
  String get layerClouds => 'السحب';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'افتراضي النظام';

  @override
  String get themeLight => 'الوضع الفاتح';

  @override
  String get themeDark => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get languageEn => 'English';

  @override
  String get languageAr => 'العربية';

  @override
  String get units => 'وحدات القياس';

  @override
  String get unitMetric => 'متري (°م، م/ث)';

  @override
  String get unitImperial => 'إمبراطوري (°ف، ميل/س)';

  @override
  String get offlineNotice => 'عرض بيانات الطقس المحفوظة مؤقتاً';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorOccurred => 'حدث خطأ أثناء تحميل بيانات الطقس.';

  @override
  String get pullToRefresh => 'اسحب لأسفل للتحديث';

  @override
  String get airQuality => 'جودة الهواء';

  @override
  String get airQualityGood => 'ممتاز';

  @override
  String get airQualityModerate => 'معتدل';

  @override
  String get airQualityUnhealthySensitive => 'غير صحي للحساسين';

  @override
  String get airQualityUnhealthy => 'غير صحي';

  @override
  String get airQualityVeryUnhealthy => 'غير صحي جداً';

  @override
  String get airQualityHazardous => 'خطير';

  @override
  String get sunAndMoon => 'الشمس والقمر';

  @override
  String daylightRemaining(int hours, int minutes) {
    return 'متبقي $hours س و $minutes د من ضوء النهار';
  }

  @override
  String nightRemaining(int hours, int minutes) {
    return 'متبقي $hours س و $minutes د حتى الشروق';
  }

  @override
  String get goldenHour => 'الساعة الذهبية';

  @override
  String get moonPhase => 'طور القمر';

  @override
  String get windCompass => 'الرياح والاتجاه';

  @override
  String windGust(String speed) {
    return 'هبات تصل إلى $speed';
  }

  @override
  String get hourlyCards => 'بطاقات';

  @override
  String get hourlyChart => 'رسم بياني';

  @override
  String get viewMore => 'عرض التفاصيل';

  @override
  String get viewLess => 'إخفاء التفاصيل';

  @override
  String get popularCities => 'مدن شائعة';

  @override
  String get radarPlay => 'تشغيل';

  @override
  String get radarPause => 'إيقاف مؤقت';
}
