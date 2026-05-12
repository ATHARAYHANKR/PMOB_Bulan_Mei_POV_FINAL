import 'package:flutter/material.dart';

/// Custom Trackly Logo Widget
/// Digunakan untuk branding aplikasi Trackly
class TracklyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? primaryColor;
  final Color? secondaryColor;

  const TracklyLogo({
    super.key,
    this.size = 120,
    this.showText = false,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = primaryColor ?? const Color(0xFF5C3317);
    final secondary = secondaryColor ?? const Color(0xFFA0673A);

    if (showText) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoIcon(size: size, primary: primary, secondary: secondary),
          const SizedBox(height: 12),
          Text(
            'TRACKLY',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.w900,
              color: primary,
              letterSpacing: 3,
            ),
          ),
        ],
      );
    }

    return _LogoIcon(size: size, primary: primary, secondary: secondary);
  }
}

/// Internal Logo Icon Widget
class _LogoIcon extends StatelessWidget {
  final double size;
  final Color primary;
  final Color secondary;

  const _LogoIcon({
    required this.size,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.local_shipping_rounded,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Alternative Logo dengan Custom Painter (Premium style)
class TracklyLogoPremium extends StatelessWidget {
  final double size;
  final Color primaryColor;

  const TracklyLogoPremium({
    super.key,
    this.size = 120,
    this.primaryColor = const Color(0xFF5C3317),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _TracklyLogoPainter(primaryColor: primaryColor),
        size: Size(size, size),
      ),
    );
  }
}

/// Custom Painter untuk logo Trackly
class _TracklyLogoPainter extends CustomPainter {
  final Color primaryColor;

  _TracklyLogoPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw package/box shape
    final boxPath = Path()
      ..moveTo(center.dx - radius, center.dy - radius * 0.5)
      ..lineTo(center.dx + radius, center.dy - radius * 0.5)
      ..lineTo(center.dx + radius * 0.7, center.dy + radius * 0.7)
      ..lineTo(center.dx - radius * 0.7, center.dy + radius * 0.7)
      ..close();

    canvas.drawPath(boxPath, paint);

    // Draw arrow/tracking line
    final arrowPath = Path()
      ..moveTo(center.dx - radius * 0.5, center.dy - radius * 0.2)
      ..quadraticBezierTo(center.dx, center.dy - radius * 0.5,
          center.dx + radius * 0.5, center.dy);

    canvas.drawPath(arrowPath, strokePaint);
  }

  @override
  bool shouldRepaint(_TracklyLogoPainter oldDelegate) => false;
}

/// Trackly Logo untuk App Bar
class TracklyAppBarLogo extends StatelessWidget {
  final double size;

  const TracklyAppBarLogo({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF5C3317), Color(0xFFA0673A)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_shipping_rounded,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
