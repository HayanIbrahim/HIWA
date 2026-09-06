import 'package:flutter/material.dart';
import '../../core/utils/date_formatter.dart';
import '../../l10n/generated/app_localizations.dart';

class OfflineBadge extends StatelessWidget {
  final DateTime? cachedAt;

  const OfflineBadge({super.key, this.cachedAt});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    String subtitle = '';
    if (cachedAt != null) {
      subtitle = ' (${AppDateFormatter.formatRelativeTime(cachedAt!, locale: locale)})';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Text(
            '${l10n?.offlineNotice ?? "Showing cached data"}$subtitle',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
