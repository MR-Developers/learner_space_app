import 'package:flutter/material.dart';
import 'package:learner_space_app/Screens/User/UserAIChat.dart';
import 'package:learner_space_app/Screens/User/UserHome.dart';
import 'package:learner_space_app/Screens/User/UserProfile.dart';

class UserSkeleton extends StatefulWidget {
  final int initialIndex;
  const UserSkeleton({super.key, this.initialIndex = 0});

  @override
  State<UserSkeleton> createState() => _UserSkeletonState();
}

class _UserSkeletonState extends State<UserSkeleton>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _animationController;

  final List<Widget> _screens = const [
    UserHome(),
    Center(child: Text("Courses Page")),
    UserAiChat(),
    UserProfile(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _animationController.reset();
        _currentIndex = index;
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                child: child,
              ),
            );
          },
          child: Container(
            key: ValueKey<int>(_currentIndex),
            child: _screens[_currentIndex],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isKeyboardOpen ? 0 : null,
        child: isKeyboardOpen
            ? const SizedBox.shrink()
            : SafeArea(bottom: true, child: _buildBottomNavBar()),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.home_rounded,
            label: "Home",
            active: _currentIndex == 0,
            onTap: () => _onNavItemTapped(0),
          ),
          _BottomNavItem(
            icon: Icons.play_circle_outline,
            label: "Courses",
            active: _currentIndex == 1,
            onTap: () => _onNavItemTapped(1),
          ),
          _BottomNavItem(
            icon: Icons.chat_bubble_outline,
            label: "AI",
            active: _currentIndex == 2,
            onTap: () => _onNavItemTapped(2),
          ),
          _BottomNavItem(
            icon: Icons.person_outline,
            label: "Profile",
            active: _currentIndex == 3,
            onTap: () => _onNavItemTapped(3),
          ),
        ],
      ),
    );
  }
}

// -------------------- Bottom Nav Item --------------------
class _BottomNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.active
                      ? const Color(0xFFFF6B35)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.active ? Colors.white : Colors.grey.shade500,
                  size: 26,
                ),
              ),
              if (widget.label.isNotEmpty)
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: widget.active
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: widget.active
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey.shade500,
                    letterSpacing: 0.2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(widget.label),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
