import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/calendar_event.dart';

class CalendarService {
  static const String _prefsKey = 'calendar_events';

  Future<List<CalendarEvent>> loadAllEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_prefsKey) ?? [];
    final events = jsonList.map((e) => CalendarEvent.fromJson(e)).toList();
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return events;
  }

  Future<CalendarEvent?> getNextUpcomingEvent({DateTime? from}) async {
    final now = from ?? DateTime.now();
    final events = await loadAllEvents();
    for (final e in events) {
      if (e.dateTime.isAfter(now)) {
        return e;
      }
    }
    return null;
  }

  String formatEvent(CalendarEvent e) {
    final dateStr = DateFormat('yMMMd').format(e.dateTime);
    final timeStr = DateFormat('jm').format(e.dateTime);
    if (e.notes != null && e.notes!.trim().isNotEmpty) {
      return '${e.title} on $dateStr at $timeStr — ${e.notes}';
    }
    return '${e.title} on $dateStr at $timeStr';
  }

  Future<List<DateTime>> findUpcomingFreeDays({
    int daysToScan = 14,
    int maxSuggestions = 3,
    DateTime? from,
  }) async {
    final now = from ?? DateTime.now();
    final events = await loadAllEvents();
    final Set<String> busyDayKeys =
        events.map((e) => DateFormat('yyyy-MM-dd').format(e.dateTime)).toSet();

    final List<DateTime> suggestions = [];
    for (
      int i = 0;
      i < daysToScan && suggestions.length < maxSuggestions;
      i++
    ) {
      final d = now.add(Duration(days: i));
      final day = DateTime(d.year, d.month, d.day);
      final key = DateFormat('yyyy-MM-dd').format(day);
      if (!busyDayKeys.contains(key)) {
        suggestions.add(day);
      }
    }
    return suggestions;
  }

  Future<List<DateTime>> suggestMeetingSlots({
    int daysToScan = 14,
    int maxSuggestions = 3,
    List<int> preferredHours = const [10, 14, 16],
    DateTime? from,
  }) async {
    final freeDays = await findUpcomingFreeDays(
      daysToScan: daysToScan,
      maxSuggestions: maxSuggestions,
      from: from,
    );
    final List<DateTime> slots = [];
    for (final day in freeDays) {
      // Pick first preferred hour that is still in the future if today
      DateTime? slot;
      for (final h in preferredHours) {
        final candidate = DateTime(day.year, day.month, day.day, h, 0);
        if (candidate.isAfter(from ?? DateTime.now())) {
          slot = candidate;
          break;
        }
      }
      slot ??= DateTime(day.year, day.month, day.day, preferredHours.first, 0);
      slots.add(slot);
    }
    return slots;
  }

  String formatSlot(DateTime dt) {
    return '${DateFormat('EEEE, yMMMd').format(dt)} at ${DateFormat('jm').format(dt)}';
  }

  Future<void> saveEvent({
    required String id,
    required String title,
    String? notes,
    required DateTime dateTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];
    final events = list.map((e) => CalendarEvent.fromJson(e)).toList();
    events.add(
      CalendarEvent(id: id, title: title, dateTime: dateTime, notes: notes),
    );
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    final updated = events.map((e) => e.toJson()).toList();
    await prefs.setStringList(_prefsKey, updated);
  }
}
