import 'package:flutter/material.dart';
import 'package:clock/clock.dart';
import 'package:peanutprogress/data/models/category.dart';
import 'package:peanutprogress/core/utils/enums/progress_status.dart';
import 'package:peanutprogress/core/utils/enums/day_of_week.dart';
import 'package:peanutprogress/data/models/date_only.dart';

/// A class representing a habit.
///
/// The [Habit] class encapsulates properties and methods for managing habits, including title, description, days of the week,
/// time, progress status, and associated category.
///
/// ### Parameters:
/// - [id] is the unique identifier for the habit.
/// - [title] is the title of the habit.
/// - [description] is the description of the habit.
/// - [days] is the list of days when the habit occurs.
/// - [time] is the time of day when the habit should be performed.
/// - [progress] is a map tracking the progress status of the habit on various dates.
/// - [category] is the category associated with the habit.
class Habit {
  int id;
  String title;
  String description;
  List<DayOfWeek> days;
  TimeOfDay time;
  Map<DateTime, ProgressStatus> _progress;
  Category category;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.days,
    required this.time,
    required Map<DateTime, ProgressStatus> progress,
    required this.category,
  }) : _progress = progress;

  Map<DateTime, ProgressStatus> get progress => _progress;

  /// Calculates the current streak of completed habits.
  int get streak {
    int streakCount = 0;
    List<DateTime> sortedDates = _progress.keys.toList()..sort();

    for (var date in sortedDates.reversed) {
      if (_progress[date] == ProgressStatus.notCompleted) {
        date = DateTime(
          date.year,
          date.month,
          date.day + 1,
          time.hour,
          time.minute,
        );
        if (DateTime.now().isAfter(date)) {
          break;
        }
      } else if (_progress[date] == ProgressStatus.completed) {
        streakCount++;
      }
    }
    return streakCount;
  }

  /// Converts the habit object into a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'days': days.map((day) => day.name).toList(),
      'time': '${time.hour}:${time.minute}',
      'progress': _progress
          .map((key, value) => MapEntry(key.toIso8601String(), value.name)),
      'category': category.toMap(),
    };
  }

  /// Creates a habit object from a map.
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      days: (map['days'] as List<dynamic>)
          .map((day) => DayOfWeek.values.firstWhere((e) => e.name == day))
          .toList(),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      progress: (map['progress'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          DateTime.parse(key),
          ProgressStatus.values.firstWhere((e) => e.name == value),
        ),
      ),
      category: Category.fromMap(map['category']),
    );
  }

  /// Returns a copy of the habit object with updated values where provided.
  Habit copyWith({
    int? id,
    String? title,
    String? description,
    List<DayOfWeek>? days,
    TimeOfDay? time,
    Map<DateTime, ProgressStatus>? progress,
    Category? category,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      days: days ?? this.days,
      time: time ?? this.time,
      progress: progress ?? _progress,
      category: category ?? this.category,
    );
  }

  /// Copy constructor to create a new habit object from an existing one.
  factory Habit.from(Habit other) {
    return Habit(
      id: other.id,
      title: other.title,
      description: other.description,
      days: List.from(other.days),
      time: other.time,
      progress: Map.from(other.progress),
      category: other.category,
    );
  }

  /// Returns a default habit object with empty values.
  factory Habit.defaultHabit() {
    return Habit(
      id: 0,
      title: '',
      description: '',
      days: [],
      time: const TimeOfDay(hour: 0, minute: 0),
      progress: {},
      category: Category.defaultCategory(),
    );
  }

  /// Converts the days of the habit to their equivalent weekday values.
  List<int> getDaysAsWeekdays() {
    List<int> weekdays = [];
    for (var day in days) {
      switch (day) {
        case DayOfWeek.monday:
          weekdays.add(1);
          break;
        case DayOfWeek.tuesday:
          weekdays.add(2);
          break;
        case DayOfWeek.wednesday:
          weekdays.add(3);
          break;
        case DayOfWeek.thursday:
          weekdays.add(4);
          break;
        case DayOfWeek.friday:
          weekdays.add(5);
          break;
        case DayOfWeek.saturday:
          weekdays.add(6);
          break;
        case DayOfWeek.sunday:
          weekdays.add(7);
          break;
      }
    }
    return weekdays;
  }

  /// Marks the habit as completed on the specified date.
  void markAsCompleted(DateTime date) {
    final weekdays = getDaysAsWeekdays();
    if (weekdays.contains(date.weekday)) {
      _progress[dateOnly(date)] = ProgressStatus.completed;
    }
  }

  /// Marks the habit as not completed on the specified date.
  void markAsNotCompleted(DateTime date) {
    _progress[dateOnly(date)] = ProgressStatus.notCompleted;
  }

  /// Checks if the habit is completed on the specified date.
  bool isCompletedOnDate(DateTime date) {
    return _progress[dateOnly(date)] == ProgressStatus.completed;
  }

  /// Returns the next due date for the habit based on its schedule.
  DateTime getNextDueDate() {
    // final now = DateTime.now();
    final now = clock.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime? closestDate;

    for (var day in days) {
      var nextDate = _getNextDateForDay(day, today);
      nextDate = DateTime(
          nextDate.year, nextDate.month, nextDate.day, time.hour, time.minute);

      if (nextDate.isAfter(now) &&
          (closestDate == null || nextDate.isBefore(closestDate))) {
        closestDate = nextDate;
      }
    }

    if (closestDate == null) {
      var fallbackDay = days.first;
      closestDate = _getNextDateForDay(fallbackDay, today);
      closestDate = DateTime(closestDate.year, closestDate.month,
          closestDate.day, time.hour, time.minute);
    }

    return closestDate;
  }

  /// Helper method to find the next date for the specified day of the week.
  DateTime _getNextDateForDay(DayOfWeek day, DateTime today) {
    int daysToAdd = (day.index + 1 - today.weekday + 7) % 7;

    if (daysToAdd == 0 &&
        DateTime.now().isAfter(DateTime(
            today.year, today.month, today.day, time.hour, time.minute))) {
      daysToAdd = 7;
    }

    return today.add(Duration(days: daysToAdd));
  }

  /// Toggles the completion status of the habit on the specified date.
  void toggleComplete(DateTime date) {
    date = dateOnly(date);
    if (isCompletedOnDate(date)) {
      markAsNotCompleted(date);
    } else {
      markAsCompleted(date);
    }
  }

  /// Initializes the progress of the habit, filling in missing data up to the current date.
  void initializeProgress() {
    final today = DateTime.now();
    final normalizedToday = dateOnly(today);

    DateTime? lastDate = _progress.keys.isNotEmpty
        ? _progress.keys.reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    DateTime startDate = lastDate != null
        ? dateOnly(lastDate.add(const Duration(days: 1)))
        : dateOnly(getNextDueDate());

    // Generate missing dates up to today
    while (startDate.isBefore(normalizedToday) ||
        startDate.isAtSameMomentAs(normalizedToday)) {
      final currentDay = _getDayOfWeek(startDate);

      if (days.contains(currentDay) && !_progress.containsKey(startDate)) {
        _progress[startDate] = ProgressStatus.notCompleted;
      }

      startDate =
          _getNextDateForDay(_getNextScheduledDay(startDate), startDate);
    }
  }

  /// Helper to find the next scheduled day in the habit's schedule
  DayOfWeek _getNextScheduledDay(DateTime currentDate) {
    final currentDay = _getDayOfWeek(currentDate);
    final nextDayIndex = days.indexWhere((day) => day.index > currentDay.index);
    return nextDayIndex != -1 ? days[nextDayIndex] : days.first;
  }

  /// Helper to convert a DateTime to a DayOfWeek enum
  DayOfWeek _getDayOfWeek(DateTime date) {
    return DayOfWeek.values[(date.weekday - 1) % 7];
  }
}
