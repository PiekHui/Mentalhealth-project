import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/calendar_event.dart';
import '../widgets/attendance_calendar.dart';
import '../services/notification_service.dart';

class CalendarPlannerScreen extends StatefulWidget {
  const CalendarPlannerScreen({super.key});

  @override
  State<CalendarPlannerScreen> createState() => _CalendarPlannerScreenState();
}

class _CalendarPlannerScreenState extends State<CalendarPlannerScreen> {
  static const String _prefsKey = 'calendar_events';
  DateTime? _selectedDate;
  final List<CalendarEvent> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_prefsKey) ?? [];
    setState(() {
      _events
        ..clear()
        ..addAll(jsonList.map((e) => CalendarEvent.fromJson(e)));
    });
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _events.map((e) => e.toJson()).toList();
    await prefs.setStringList(_prefsKey, jsonList);
  }

  List<CalendarEvent> _eventsOnDate(DateTime date) {
    return _events.where((e) => _isSameDay(e.dateTime, date)).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _showAddEditDialog({
    CalendarEvent? existing,
    DateTime? forDate,
  }) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final notesController = TextEditingController(text: existing?.notes ?? '');
    DateTime date = existing?.dateTime ?? forDate ?? DateTime.now();
    TimeOfDay time = TimeOfDay.fromDateTime(
      existing?.dateTime ?? DateTime.now(),
    );

    bool scheduleReminder = true;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Add Event' : 'Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: scheduleReminder,
                  title: const Text('Remind me at this time'),
                  onChanged: (v) => setState(() => scheduleReminder = v),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 3650),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3650),
                            ),
                          );
                          if (picked != null) {
                            setState(() {
                              date = DateTime(
                                picked.year,
                                picked.month,
                                picked.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        child: Text(DateFormat('yMMMd').format(date)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: time,
                          );
                          if (picked != null) {
                            setState(() {
                              time = picked;
                              date = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        child: Text(time.format(context)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                if (existing == null) {
                  _events.add(
                    CalendarEvent(
                      id: const Uuid().v4(),
                      title: titleController.text.trim(),
                      notes:
                          notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                      dateTime: date,
                    ),
                  );
                } else {
                  final idx = _events.indexWhere((e) => e.id == existing.id);
                  if (idx != -1) {
                    _events[idx] = CalendarEvent(
                      id: existing.id,
                      title: titleController.text.trim(),
                      notes:
                          notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                      dateTime: date,
                    );
                  }
                }
                _saveEvents();
                if (scheduleReminder) {
                  NotificationService.instance.scheduleNotification(
                    id: date.millisecondsSinceEpoch.remainder(1000000000),
                    title: 'Upcoming: ${titleController.text.trim()}',
                    body: DateFormat('yMMMd jm').format(date),
                    scheduledDateTime: date,
                  );
                }
                setState(() {});
                Navigator.of(context).pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      setState(() {});
    }
  }

  void _deleteEvent(CalendarEvent event) async {
    _events.removeWhere((e) => e.id == event.id);
    await _saveEvents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final marked =
        _events
            .map(
              (e) => {
                'date': DateTime(
                  e.dateTime.year,
                  e.dateTime.month,
                  e.dateTime.day,
                ),
                'moodEmoji': '•',
              },
            )
            .toList();

    final dayEvents =
        _selectedDate == null
            ? <CalendarEvent>[]
            : _eventsOnDate(_selectedDate!);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Planner')),
      floatingActionButton:
          _selectedDate == null
              ? null
              : FloatingActionButton.extended(
                onPressed: () => _showAddEditDialog(forDate: _selectedDate),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AttendanceCalendar(
              markedDatesWithMoods: marked,
              selectedDate: _selectedDate,
              onDaySelected: (d) => setState(() => _selectedDate = d),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Select a date'
                      : 'Events on ${DateFormat('yMMMd').format(_selectedDate!)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_selectedDate != null)
                  TextButton.icon(
                    onPressed: () => _showAddEditDialog(forDate: _selectedDate),
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  dayEvents.isEmpty
                      ? const Center(child: Text('No events'))
                      : ListView.separated(
                        itemCount: dayEvents.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final e = dayEvents[index];
                          return ListTile(
                            leading: const Icon(Icons.event_note),
                            title: Text(e.title),
                            subtitle: Text(
                              [
                                DateFormat('jm').format(e.dateTime),
                                if (e.notes != null) e.notes!,
                              ].join(' • '),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed:
                                      () => _showAddEditDialog(existing: e),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _deleteEvent(e),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
