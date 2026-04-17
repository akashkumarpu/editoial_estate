import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/property.dart';

/// Animated price callout pin for the map.
class PropertyPinWidget extends StatefulWidget {
  const PropertyPinWidget({
    super.key,
    required this.property,
    required this.isSelected,
    required this.onTap,
  });

  final Property property;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<PropertyPinWidget> createState() => _PropertyPinWidgetState();
}

class _PropertyPinWidgetState extends State<PropertyPinWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    if (widget.isSelected) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(PropertyPinWidget old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isSelected && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.reset();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Color get _bgColor {
    if (widget.isSelected) return AppColors.tertiary;
    if (widget.property.isRental) return AppColors.surfaceContainerLowest;
    return AppColors.primary;
  }

  Color get _textColor {
    if (widget.property.isRental && !widget.isSelected) {
      return AppColors.onSurface;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, child) {
              return Container(
                decoration: widget.isSelected
                    ? BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tertiary
                                .withValues(alpha: 0.3 + _pulse.value * 0.2),
                            blurRadius: 16 + _pulse.value * 10,
                            spreadRadius: _pulse.value * 4,
                          ),
                        ],
                      )
                    : null,
                child: child,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(999),
                border: widget.isSelected
                    ? Border.all(
                        color: Colors.white.withValues(alpha: 0.4), width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: widget.isSelected ? 0.2 : 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.property.priceLabel,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),
            ),
          ),
          // Pin arrow
          CustomPaint(
            painter: _PinArrowPainter(color: _bgColor),
            size: const Size(10, 6),
          ),
        ],
      ),
    );
  }
}

class _PinArrowPainter extends CustomPainter {
  _PinArrowPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinArrowPainter old) => old.color != color;
}
