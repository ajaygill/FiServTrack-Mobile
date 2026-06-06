import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'max_amount_formatter.dart';

class AmountHero extends StatefulWidget {
  final String amount;
  final List<Color> gradColors;
  final IconData badgeIcon;
  final String badgeText;
  final Color badgeColor, badgeBg, badgeBorder;
  final ValueChanged<String> onChanged;

  const AmountHero({
    Key? key,
    required this.amount,
    required this.gradColors,
    required this.badgeIcon,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeBg,
    required this.badgeBorder,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<AmountHero> createState() => _AmountHeroState();
}

class _AmountHeroState extends State<AmountHero> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.amount);
    _focus = FocusNode()..addListener(() {
      if (_focus.hasFocus) {
        _ctrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _ctrl.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(AmountHero old) {
    super.didUpdateWidget(old);
    if (old.amount != widget.amount && !_focus.hasFocus) {
      _ctrl.text = widget.amount;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.gradColors.last.withOpacity(0.38),
            blurRadius: 28,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'AMOUNT',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹ ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IntrinsicWidth(
                        child: TextField(
                          controller: _ctrl,
                          focusNode: _focus,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -3.0,
                            height: 1.0,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            fillColor: Colors.transparent,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                            MaxAmountFormatter(1000000),
                          ],
                          onChanged: widget.onChanged,
                        ),
                      ),
                      _BlinkingCursor(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.badgeBg,
                      border: Border.all(color: widget.badgeBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.badgeIcon, color: widget.badgeColor, size: 11),
                        const SizedBox(width: 5),
                        Text(
                          widget.badgeText,
                          style: TextStyle(
                            color: widget.badgeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _ctrl,
    child: Container(
      margin: const EdgeInsets.only(left: 3),
      width: 2.5,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(1.5),
      ),
    ),
  );
}
