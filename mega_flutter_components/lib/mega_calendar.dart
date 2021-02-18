import 'package:flutter/material.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';
import 'package:table_calendar/table_calendar.dart';

class MegaCalendar extends StatefulWidget {
  final DateTime initialDay;
  final DateTime minDay;
  final DateTime maxDay;
  final HeaderStyle headerStyle;
  final CalendarStyle calendarStyles;
  final DaysOfWeekStyle daysOfWeekStyle;
  final CalendarFormat format;
  final Set<int> daysConfigured;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onMonthChanged;

  const MegaCalendar({
    this.initialDay,
    this.minDay,
    this.maxDay,
    this.headerStyle,
    this.calendarStyles,
    this.daysOfWeekStyle,
    this.format = CalendarFormat.week,
    this.daysConfigured,
    this.onDaySelected,
    this.onMonthChanged,
  });

  @override
  _MegaCalendarState createState() => _MegaCalendarState();
}

class _MegaCalendarState extends State<MegaCalendar> {
  final CalendarController _calendarController = CalendarController();
  int _lastMonth = 0;

  @override
  Widget build(BuildContext context) {
    var daysConfigured = Set<int>();
    if (widget.daysConfigured != null) {
      daysConfigured = widget.daysConfigured;
    }

    final header = widget.headerStyle;
    final calendar = widget.calendarStyles;
    final days = widget.daysOfWeekStyle;

    final events = daysConfigured.toList().asMap().map((key, value) =>
        MapEntry(DateTime.fromMillisecondsSinceEpoch(value * 1000), [value]));

    return TableCalendar(
      initialSelectedDay: widget.initialDay ?? DateTime.now(),
      calendarController: _calendarController,
      startDay: widget.minDay ?? DateTime.now(),
      endDay: widget.maxDay,
      locale: MegaleiosLocalizations.of(context).locale.toLanguageTag(),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      initialCalendarFormat: widget.format,
      headerStyle: header ?? const HeaderStyle(),
      calendarStyle: calendar ?? const CalendarStyle(),
      daysOfWeekStyle: days ?? const DaysOfWeekStyle(),
      rowHeight: 40,
      onVisibleDaysChanged: (_, endTime, __) {
        if (widget.onMonthChanged != null && _lastMonth != endTime.month) {
          if (endTime.month == DateTime.now().month) {
            widget.onMonthChanged(DateTime.now());
          } else {
            final initMonth = DateTime(endTime.year, endTime.month);
            widget.onMonthChanged(initMonth);
          }
        }
        _lastMonth = endTime.month;
      },
      onDaySelected: (date, _, __) {
        if (widget.onDaySelected != null) {
          widget.onDaySelected(date);
        }
      },
      events: events,
      builders: events.isNotEmpty
          ? CalendarBuilders(
              markersBuilder: (_, date, events, holidays) {
                return [
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  )
                ];
              },
            )
          : const CalendarBuilders(),
    );
  }
}
