import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  final bool isRangeMode;
  final DateTime? selectedDate; // used when isRangeMode = false
  final DateTime? rangeStart;   // used when isRangeMode = true
  final DateTime? rangeEnd;     // used when isRangeMode = true
  final ValueChanged<DateTime> onDateSelected;

  static const _weekDays  = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  static const _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  const CustomCalendar({
    Key? key,
    this.isRangeMode = true,
    this.selectedDate,
    this.rangeStart,
    this.rangeEnd,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();

  static String _monthShort(int m) =>
      ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _calMonth;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.isRangeMode
        ? (widget.rangeStart ?? DateTime.now())
        : (widget.selectedDate ?? DateTime.now());
    _calMonth = DateTime(initialDate.year, initialDate.month);
  }

  void _prevMonth() => setState(() =>
  _calMonth = DateTime(
    _calMonth.month == 1 ? _calMonth.year - 1 : _calMonth.year,
    _calMonth.month == 1 ? 12 : _calMonth.month - 1,
  ));

  void _nextMonth() => setState(() =>
  _calMonth = DateTime(
    _calMonth.month == 12 ? _calMonth.year + 1 : _calMonth.year,
    _calMonth.month == 12 ? 1 : _calMonth.month + 1,
  ));

  bool _isStart(DateTime d) =>
      widget.isRangeMode
          ? (widget.rangeStart != null && _sameDay(d, widget.rangeStart!))
          : (widget.selectedDate != null && _sameDay(d, widget.selectedDate!));

  bool _isEnd(DateTime d) =>
      widget.isRangeMode && widget.rangeEnd != null && _sameDay(d, widget.rangeEnd!);

  bool _isInRange(DateTime d) =>
      widget.isRangeMode &&
      widget.rangeStart != null &&
      widget.rangeEnd != null &&
      d.isAfter(widget.rangeStart!) &&
      d.isBefore(widget.rangeEnd!);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final firstDay    = DateTime(_calMonth.year, _calMonth.month, 1);
    final daysInMonth = DateTime(_calMonth.year, _calMonth.month + 1, 0).day;
    final startOffset = firstDay.weekday % 7; // Sunday = 0
    final today       = DateTime.now();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.brand.withOpacity(0.25), width: 1.5),
      ),
      child: Column(children: [

        // Month navigation header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _prevMonth,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: const Icon(Icons.chevron_left_rounded,
                    size: 18, color: AppColors.inkMid),
              ),
            ),
            Text(
              '${CustomCalendar._monthNames[_calMonth.month - 1]} ${_calMonth.year}',
              style: const TextStyle(
                  color: AppColors.ink, fontSize: 14,
                  fontWeight: FontWeight.w800, letterSpacing: -0.3),
            ),
            GestureDetector(
              onTap: _nextMonth,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.inkMid),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Weekday labels
        Row(
          children: CustomCalendar._weekDays.map((d) => Expanded(
            child: Center(
              child: Text(d, style: const TextStyle(
                  color: AppColors.inkMuted, fontSize: 10,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            ),
          )).toList(),
        ),

        const SizedBox(height: 8),

        // Day grid — always 6 rows x 7 cols so height is identical every month
        LayoutBuilder(builder: (_, constraints) {
          const totalRows = 6;
          final cellW = constraints.maxWidth / 7;
          const cellH = 38.0; // fixed cell height -> grid is always 6 x 38 = 228px

          final List<Widget> cells = List.generate(42, (index) {
            final dayNum = index - startOffset + 1;
            if (dayNum < 1 || dayNum > daysInMonth) {
              return SizedBox(width: cellW, height: cellH);
            }
            final date     = DateTime(_calMonth.year, _calMonth.month, dayNum);
            final isS      = _isStart(date);
            final isE      = _isEnd(date);
            final inRange  = _isInRange(date);
            final isToday  = _sameDay(date, today);
            final isFuture = date.isAfter(today);

            return _DayCell(
              day: dayNum,
              cellW: cellW,
              cellH: cellH,
              isStart: isS,
              isEnd: isE,
              inRange: inRange,
              isToday: isToday,
              isFuture: isFuture,
              isFirstInRow: index % 7 == 0,
              isLastInRow:  index % 7 == 6,
              onTap: isFuture ? null : () => widget.onDateSelected(date),
            );
          });

          return Column(
            children: List.generate(totalRows, (row) => Row(
              children: cells.sublist(row * 7, row * 7 + 7),
            )),
          );
        }),

        // Legend
        if (widget.isRangeMode && (widget.rangeStart != null || widget.rangeEnd != null)) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _LegendDot(color: AppColors.brand),
                const SizedBox(width: 5),
                Text(
                  widget.rangeStart != null
                      ? '${widget.rangeStart!.day} ${CustomCalendar._monthShort(widget.rangeStart!.month)}'
                      : '—',
                  style: const TextStyle(color: AppColors.ink,
                      fontSize: 12, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.rangeEnd != null ? '→' : '· tap to pick end',
                    style: TextStyle(
                        color: widget.rangeEnd != null ? AppColors.inkMid : AppColors.inkMuted,
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                if (widget.rangeEnd != null) ...[
                  const _LegendDot(color: AppColors.brand),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.rangeEnd!.day} ${CustomCalendar._monthShort(widget.rangeEnd!.month)}',
                    style: const TextStyle(color: AppColors.ink,
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ],
            ),
          ),
        ],
      ]),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) =>
      Container(width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

// ── Single day cell ───────────────────────────────────────────────────────────
class _DayCell extends StatelessWidget {
  final int day;
  final double cellW, cellH;
  final bool isStart, isEnd, inRange, isToday, isFuture;
  final bool isFirstInRow, isLastInRow;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.cellW, required this.cellH,
    required this.isStart, required this.isEnd,
    required this.inRange, required this.isToday,
    required this.isFuture, required this.isFirstInRow,
    required this.isLastInRow, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool highlighted = isStart || isEnd;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: cellW, height: cellH,
        child: Stack(alignment: Alignment.center, children: [

          // Range background strip (between start and end)
          if (inRange || (isStart && !isEnd) || (isEnd && !isStart))
            Positioned.fill(
              child: Row(children: [
                // Left half
                Expanded(
                  child: Container(
                    color: (inRange || isEnd) && !isFirstInRow
                        ? AppColors.brand.withOpacity(0.10) : Colors.transparent,
                  ),
                ),
                // Right half
                Expanded(
                  child: Container(
                    color: (inRange || isStart) && !isLastInRow
                        ? AppColors.brand.withOpacity(0.10) : Colors.transparent,
                  ),
                ),
              ]),
            ),

          // Circle for selected days
          if (highlighted)
            Container(
              width: cellW * 0.78,
              height: cellH * 0.78,
              decoration: const BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
              ),
            )
          else if (inRange)
            Container(
              width: cellW * 0.72,
              height: cellH * 0.72,
              decoration: BoxDecoration(
                color: AppColors.brand.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            )
          else if (isToday)
            Container(
              width: cellW * 0.72,
              height: cellH * 0.72,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brand, width: 1.5),
                shape: BoxShape.circle,
              ),
            ),

          // Day number
          Text(
            '$day',
            style: TextStyle(
              color: highlighted
                  ? Colors.white
                  : isFuture
                  ? AppColors.inkMuted.withOpacity(0.4)
                  : inRange
                  ? AppColors.brand
                  : isToday
                  ? AppColors.brand
                  : AppColors.ink,
              fontSize: 12,
              fontWeight: highlighted || isToday
                  ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ]),
      ),
    );
  }
}
