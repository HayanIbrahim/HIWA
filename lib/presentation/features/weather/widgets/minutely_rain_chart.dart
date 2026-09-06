import 'package:flutter/material.dart';
import '../../../../domain/entities/minutely_precipitation_entity.dart';
import '../../../common_widgets/glass_card.dart';

class MinutelyRainChart extends StatelessWidget {
  final List<MinutelyPrecipitationEntity> minutelyList;

  const MinutelyRainChart({super.key, required this.minutelyList});

  @override
  Widget build(BuildContext context) {
    if (minutelyList.isEmpty) return const SizedBox.shrink();

    final hasRain = minutelyList.any((m) => m.precipitation > 0.0);
    if (!hasRain) return const SizedBox.shrink();

    double maxRain = 0.0;
    for (var m in minutelyList) {
      if (m.precipitation > maxRain) maxRain = m.precipitation;
    }
    if (maxRain <= 0.0) maxRain = 1.0;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.umbrella_rounded, size: 18, color: Color(0xFF38BDF8)),
              const SizedBox(width: 8),
              const Text(
                'NEXT-HOUR PRECIPITATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Custom Mini Precipitation Bar Chart
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                minutelyList.length.clamp(0, 60),
                (index) {
                  final item = minutelyList[index];
                  final fraction = (item.precipitation / maxRain).clamp(0.05, 1.0);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.5),
                      child: Container(
                        height: item.precipitation > 0 ? (48 * fraction) : 2,
                        decoration: BoxDecoration(
                          color: item.precipitation > 0
                              ? const Color(0xFF38BDF8).withOpacity(0.85)
                              : Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Now',
                style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6)),
              ),
              Text(
                '30 min',
                style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6)),
              ),
              Text(
                '60 min',
                style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
