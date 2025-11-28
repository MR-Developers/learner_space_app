import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProfessionalCourseLoader extends StatefulWidget {
  const ProfessionalCourseLoader({super.key});

  @override
  State<ProfessionalCourseLoader> createState() =>
      _ProfessionalCourseLoaderState();
}

class _ProfessionalCourseLoaderState extends State<ProfessionalCourseLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Loader
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * math.pi,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEF7C08).withOpacity(0.2),
                            width: 3,
                          ),
                        ),
                        child: CustomPaint(
                          painter: ArcPainter(
                            color: const Color(0xFFEF7C08),
                            progress: _rotationController.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Middle pulsing circle
                AnimatedBuilder(
                  animation: _scaleController,
                  builder: (context, child) {
                    final scale = 0.6 + (_scaleController.value * 0.2);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFEF7C08).withOpacity(0.3),
                              const Color(0xFFEF7C08).withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Center icon
                AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.6 + (_fadeController.value * 0.4),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF7C08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    );
                  },
                ),

                // Animated dots around
                ...List.generate(8, (index) {
                  return AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      final angle =
                          (index * math.pi / 4) +
                          (_rotationController.value * 2 * math.pi);
                      final x = 55 * math.cos(angle);
                      final y = 55 * math.sin(angle);

                      final opacity =
                          (math.sin(
                                _rotationController.value * 2 * math.pi +
                                    (index * math.pi / 4),
                              ) +
                              1) /
                          2;

                      return Transform.translate(
                        offset: Offset(x, y),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFEF7C08,
                            ).withOpacity(opacity * 0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Animated text
          AnimatedBuilder(
            animation: _fadeController,
            builder: (context, child) {
              return Opacity(
                opacity: 0.7 + (_fadeController.value * 0.3),
                child: Column(
                  children: [
                    const Text(
                      "Loading Courses",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Please wait",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _buildDots(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return SizedBox(
      width: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              final delay = index * 0.15;
              final value = (_rotationController.value + delay) % 1.0;
              final opacity = (math.sin(value * 2 * math.pi) + 1) / 2;

              return Opacity(
                opacity: opacity,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final Color color;
  final double progress;

  ArcPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * 0.75;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) => true;
}

// Alternative: Simpler but elegant version
class SimpleElegantLoader extends StatefulWidget {
  const SimpleElegantLoader({super.key});

  @override
  State<SimpleElegantLoader> createState() => _SimpleElegantLoaderState();
}

class _SimpleElegantLoaderState extends State<SimpleElegantLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            width: 200,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final delay = index * 0.2;
                    final value = (_controller.value - delay).clamp(0.0, 1.0);
                    final height = 20 + (math.sin(value * math.pi) * 30);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 12,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFEF7C08),
                            const Color(0xFFFF9933),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF7C08).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Fetching courses...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Book-themed loader
class BookThemeLoader extends StatefulWidget {
  const BookThemeLoader({super.key});

  @override
  State<BookThemeLoader> createState() => _BookThemeLoaderState();
}

class _BookThemeLoaderState extends State<BookThemeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final delay = index * 0.15;
                    final value = (_controller.value + delay) % 1.0;
                    final angle = value * math.pi;

                    return Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: Container(
                        width: 60,
                        height: 80,
                        margin: EdgeInsets.only(left: index * 15.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.lerp(
                                const Color(0xFFEF7C08),
                                const Color(0xFFFF9933),
                                index / 3,
                              )!,
                              Color.lerp(
                                const Color(0xFFFF9933),
                                const Color(0xFFEF7C08),
                                index / 3,
                              )!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.book,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Loading Your Courses",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Preparing amazing content for you",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
