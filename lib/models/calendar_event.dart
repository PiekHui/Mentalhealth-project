import 'dart:convert';

class CalendarEvent {
  final String id;
  final String title;
  final String? notes;
  final DateTime dateTime;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.dateTime,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      id: map['id'] as String,
      title: map['title'] as String,
      notes: map['notes'] as String?,
      dateTime: DateTime.parse(map['dateTime'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory CalendarEvent.fromJson(String source) =>
      CalendarEvent.fromMap(json.decode(source) as Map<String, dynamic>);
}

