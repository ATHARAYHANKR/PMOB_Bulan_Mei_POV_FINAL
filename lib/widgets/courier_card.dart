import 'package:flutter/material.dart';

class CourierCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;
  final int badge;
  final bool isSelected;

  const CourierCard({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
    this.badge = 0,
    this.isSelected = false,
  });

  @override
  State<CourierCard> createState() => _CourierCardState();
}

class _CourierCardState extends State<CourierCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _tapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected;

    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: widget.onTap,
          onTapDown: _tapDown,
          onTapUp: _tapUp,
          onTapCancel: _tapCancel,
          splashColor: const Color(0xFF5C3317).withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6D8),
              borderRadius: BorderRadius.circular(18),
              border: active
                  ? Border.all(
                      color: const Color(0xFF5C3317),
                      width: 2,
                    )
                  : null,
              boxShadow: [
                // Glow / shadow utama
                BoxShadow(
                  color: active
                      ? const Color(0xFF5C3317).withOpacity(0.25)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: active ? 18 : 10,
                  offset: const Offset(0, 5),
                ),

                // Light neumorphism
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // CONTENT
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ICON
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D5C4),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        size: 28,
                        color: const Color(0xFF5C3317),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // TEXT
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? const Color(0xFF5C3317)
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                // BADGE
                if (widget.badge > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE74C3C),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE74C3C).withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.badge > 99 ? '99+' : '${widget.badge}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                // CHECK ICON
                if (active)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5C3317),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}