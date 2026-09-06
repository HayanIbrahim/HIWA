import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../common_widgets/glass_card.dart';
import '../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.settings ?? 'Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              // Theme Section
              _buildSectionTitle(context, l10n?.appearance ?? 'Appearance'),
              const SizedBox(height: 8),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildRadioTile<ThemeMode>(
                      title: l10n?.themeSystem ?? 'System Default',
                      value: ThemeMode.system,
                      groupValue: state.themeMode,
                      icon: Icons.brightness_auto_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsBloc>().add(ChangeThemeModeEvent(val));
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildRadioTile<ThemeMode>(
                      title: l10n?.themeLight ?? 'Light Mode',
                      value: ThemeMode.light,
                      groupValue: state.themeMode,
                      icon: Icons.light_mode_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsBloc>().add(ChangeThemeModeEvent(val));
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildRadioTile<ThemeMode>(
                      title: l10n?.themeDark ?? 'Dark Mode',
                      value: ThemeMode.dark,
                      groupValue: state.themeMode,
                      icon: Icons.dark_mode_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsBloc>().add(ChangeThemeModeEvent(val));
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Language Section
              _buildSectionTitle(context, l10n?.language ?? 'Language'),
              const SizedBox(height: 8),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildRadioTile<String>(
                      title: l10n?.languageEn ?? 'English',
                      value: 'en',
                      groupValue: state.locale.languageCode,
                      icon: Icons.language_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsBloc>().add(ChangeLocaleEvent(Locale(val)));
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildRadioTile<String>(
                      title: l10n?.languageAr ?? 'العربية',
                      value: 'ar',
                      groupValue: state.locale.languageCode,
                      icon: Icons.translate_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsBloc>().add(ChangeLocaleEvent(Locale(val)));
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Units Section
              _buildSectionTitle(context, l10n?.units ?? 'Units of Measurement'),
              const SizedBox(height: 8),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildRadioTile<UnitSystem>(
                      title: l10n?.unitMetric ?? 'Metric (°C, m/s)',
                      value: UnitSystem.metric,
                      groupValue: state.unitSystem,
                      icon: Icons.thermostat_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsBloc>().add(ChangeUnitSystemEvent(val));
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildRadioTile<UnitSystem>(
                      title: l10n?.unitImperial ?? 'Imperial (°F, mph)',
                      value: UnitSystem.imperial,
                      groupValue: state.unitSystem,
                      icon: Icons.speed_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          context.read<SettingsBloc>().add(ChangeUnitSystemEvent(val));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildRadioTile<T>({
    required String title,
    required T value,
    required T groupValue,
    required IconData icon,
    required ValueChanged<T?> onChanged,
  }) {
    return RadioListTile<T>(
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 14),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
