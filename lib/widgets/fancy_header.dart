import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Beautiful animated header with no assets, no network.
/// Fully fixed: takes full width & avoids overflow.
class FancyHeader extends StatefulWidget {
  const FancyHeader({
    super.key,
    this.title,
    this.subtitle,
    this.emoji = '🧑‍🍳',
    this.height = 220,
  });

  final String? title;
  final String? subtitle;
  final String emoji;
  final double height;

  @override
  State<FancyHeader> createState() => _FancyHeaderState();
}

class _FancyHeaderState extends State<FancyHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
  AnimationController(vsync: this, duration: const Duration(seconds: 4))
    ..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width; // ✅ full screen width

    return SizedBox(
      width: width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.elliptical(160, 50),
          bottomRight: Radius.elliptical(160, 50),
        ),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final t = _ctrl.value * 2 * math.pi;
            return Container(
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withOpacity(0.12),
                    cs.primary.withOpacity(0.35),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Moving bubbles - positioned properly using width
                  Positioned(
                    top: 30 + 6 * math.sin(t),
                    left: width * 0.25,
                    child: _bubble(cs.primary.withOpacity(0.18), 28),
                  ),
                  Positioned(
                    top: 70 + 10 * math.cos(t),
                    right: width * 0.25,
                    child: _bubble(cs.secondary.withOpacity(0.20), 36),
                  ),

                  // Centered bouncing emoji
                  Transform.translate(
                    offset: Offset(0, -6 * math.sin(t * 1.2)),
                    child: Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),

                  // Title + subtitle always centered
                  Positioned(
                    bottom: 22,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        if (widget.title != null)
                          Text(
                            widget.title!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            widget.subtitle!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: cs.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _bubble(Color c, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: c.withOpacity(0.28),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ],
      ),
    );
  }
}
