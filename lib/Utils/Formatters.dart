import 'package:intl/intl.dart';

String formatPrice(dynamic p) {
  try {
    if (p == null) return '-';
    final num numVal = p is num ? p : num.parse(p.toString());
    return '₹' + NumberFormat.decimalPattern('en_IN').format(numVal);
  } catch (_) {
    return p.toString();
  }
}

String durationToString(dynamic duration) {
  if (duration == null) return '-';
  Map? d;
  if (duration is Map)
    d = duration;
  else if (duration is List && duration.isNotEmpty && duration.first is Map)
    d = duration.first;
  else
    return duration.toString();

  final val = d?['value'] ?? d?['val'] ?? d?['duration'] ?? null;
  final unit = d?['unit'];

  const unitMap = {1: 'weeks', 2: 'months', 3: 'days', 0: 'hours'};

  final unitStr = unitMap[unit] ?? (unit is String ? unit : 'units');
  return val != null ? '$val $unitStr' : '-';
}
