import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MotionStudioApp());
}

class MotionStudioApp extends StatelessWidget {
  const MotionStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motion Studio',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070A13),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MotionHomePage(),
    );
  }
}

class MotionHomePage extends StatefulWidget {
  const MotionHomePage({super.key});

  @override
  State<MotionHomePage> createState() => _MotionHomePageState();
}

class _MotionHomePageState extends State<MotionHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;
  late final AnimationController _rotationController;
  late final AnimationController _orbController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  bool _isExpanded = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutCubic,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _pulseController.repeat(reverse: true);
      _rotationController.repeat();
      _orbController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _rotationController.stop();
      _orbController.stop();
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1180),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTopBar(),
                              const SizedBox(height: 42),
                              _buildHero(isWide),
                              const SizedBox(height: 32),
                              _buildAnimationCards(isWide),
                              const SizedBox(height: 32),
                              _buildInteractivePanel(isWide),
                              const SizedBox(height: 32),
                              _buildFooter(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8B5CF6),
                Color(0xFFEC4899),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.35),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 14),
        const Text(
          'MOTION',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
        const Spacer(),
        _GlassButton(
          icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          onTap: _toggleAnimation,
          tooltip: _isPlaying ? 'Pause animations' : 'Play animations',
        ),
      ],
    );
  }

  Widget _buildHero(bool isWide) {
    final content = Column(
      crossAxisAlignment:
          isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withOpacity(0.12),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
            ),
          ),
          child: const Text(
            'FLUTTER ANIMATION FRAMEWORK',
            style: TextStyle(
              color: Color(0xFFC4B5FD),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Bring your UI\n'
          'to life.',
          style: TextStyle(
            fontSize: 58,
            height: 0.98,
            fontWeight: FontWeight.w900,
            letterSpacing: -2.5,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'A visual playground demonstrating smooth, '
          'expressive and interactive Flutter animations.',
          textAlign: isWide ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.62),
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );

    final visual = ScaleTransition(
      scale: _scaleAnimation,
      child: const _HeroOrb(),
    );

    if (isWide) {
      return Row(
        children: [
          Expanded(child: content),
          const SizedBox(width: 40),
          Expanded(child: visual),
        ],
      );
    }

    return Column(
      children: [
        content,
        const SizedBox(height: 42),
        visual,
      ],
    );
  }

  Widget _buildAnimationCards(bool isWide) {
    final cards = [
      _AnimationCardData(
        icon: Icons.motion_photos_on_rounded,
        title: 'Fade',
        subtitle: 'Opacity transitions',
        color: const Color(0xFF38BDF8),
        value: '01',
      ),
      _AnimationCardData(
        icon: Icons.open_in_full_rounded,
        title: 'Scale',
        subtitle: 'Elastic transformation',
        color: const Color(0xFFA78BFA),
        value: '02',
      ),
      _AnimationCardData(
        icon: Icons.rotate_right_rounded,
        title: 'Rotate',
        subtitle: 'Continuous motion',
        color: const Color(0xFFF472B6),
        value: '03',
      ),
      _AnimationCardData(
        icon: Icons.swipe_rounded,
        title: 'Slide',
        subtitle: 'Directional movement',
        color: const Color(0xFF34D399),
        value: '04',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isWide ? 1.25 : 1.05,
      ),
      itemBuilder: (context, index) {
        return _AnimatedInfoCard(
          data: cards[index],
          delay: index * 120,
        );
      },
    );
  }

  Widget _buildInteractivePanel(bool isWide) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.045),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 50,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: isWide
          ? Row(
              children: [
                Expanded(child: _buildInteractiveText()),
                const SizedBox(width: 40),
                _buildInteractiveButton(),
              ],
            )
          : Column(
              children: [
                _buildInteractiveText(),
                const SizedBox(height: 28),
                _buildInteractiveButton(),
              ],
            ),
    );
  }

  Widget _buildInteractiveText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INTERACTIVE COMPONENT',
          style: TextStyle(
            color: Color(0xFFA78BFA),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Tap it. Transform it.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'AnimatedSwitcher, AnimatedContainer and '
          'custom curves working together.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveButton() {
    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutBack,
        width: _isExpanded ? 280 : 220,
        height: _isExpanded ? 180 : 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            _isExpanded ? 32 : 22,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isExpanded
                ? const [
                    Color(0xFFEC4899),
                    Color(0xFF8B5CF6),
                  ]
                : const [
                    Color(0xFF8B5CF6),
                    Color(0xFF6366F1),
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withOpacity(0.3),
              blurRadius: 35,
              spreadRadius: 2,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: _isExpanded
              ? const Column(
                  key: ValueKey('expanded'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 38,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'MAGIC UNLOCKED',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                )
              : const Row(
                  key: ValueKey('collapsed'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TAP TO ANIMATE',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.4,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'CRAFTED WITH FLUTTER • MOTION IS A FEATURE',
        style: TextStyle(
          color: Colors.white.withOpacity(0.28),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0B0D1A),
                Color(0xFF070A13),
                Color(0xFF0D0816),
              ],
            ),
          ),
        ),
        Positioned(
          top: -180,
          right: -100,
          child: _Glow(
            color: const Color(0xFF7C3AED),
            size: 420,
          ),
        ),
        Positioned(
          bottom: -200,
          left: -130,
          child: _Glow(
            color: const Color(0xFF2563EB),
            size: 420,
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;

  const _Glow({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.22),
              color.withOpacity(0.04),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroOrb extends StatefulWidget {
  const _HeroOrb();

  @override
  State<_HeroOrb> createState() => _HeroOrbState();
}

class _HeroOrbState extends State<_HeroOrb> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller,
        _floatController,
      ]),
      builder: (context, child) {
        final angle = _controller.value * math.pi * 2;
        final vertical = math.sin(
              _floatController.value * math.pi,
            ) *
            14;

        return Transform.translate(
          offset: Offset(0, vertical),
          child: Transform.rotate(
            angle: angle * 0.12,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 285,
              height: 285,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              width: 205,
              height: 205,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFC084FC),
                    Color(0xFF7C3AED),
                    Color(0xFF312E81),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.45),
                    blurRadius: 70,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            Container(
              width: 165,
              height: 165,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.4),
                  colors: [
                    Colors.white.withOpacity(0.35),
                    Colors.white.withOpacity(0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.auto_awesome_rounded,
              size: 65,
              color: Colors.white,
            ),
            Positioned(
              top: 30,
              right: 34,
              child: _Dot(
                color: const Color(0xFF38BDF8),
                size: 13,
              ),
            ),
            Positioned(
              bottom: 42,
              left: 28,
              child: _Dot(
                color: const Color(0xFFF472B6),
                size: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;

  const _Dot({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.8),
            blurRadius: 18,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }
}

class _AnimationCardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String value;

  const _AnimationCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.value,
  });
}

class _AnimatedInfoCard extends StatefulWidget {
  final _AnimationCardData data;
  final int delay;

  const _AnimatedInfoCard({
    required this.data,
    required this.delay,
  });

  @override
  State<_AnimatedInfoCard> createState() => _AnimatedInfoCardState();
}

class _AnimatedInfoCardState extends State<_AnimatedInfoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    Future.delayed(
      Duration(milliseconds: widget.delay),
      () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curved = Curves.easeOutBack.transform(
          _controller.value,
        );

        return Opacity(
          opacity: _controller.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              0,
              30 * (1 - curved),
            ),
            child: Transform.scale(
              scale: 0.92 + (0.08 * curved),
              child: child,
            ),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _hovered = true);
        },
        onExit: (_) {
          setState(() => _hovered = false);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(
            0,
            _hovered ? -7 : 0,
            0,
          ),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              _hovered ? 0.075 : 0.045,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.data.color.withOpacity(
                _hovered ? 0.35 : 0.12,
              ),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.data.color.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: widget.data.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      widget.data.icon,
                      color: widget.data.color,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.data.value,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.18),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.data.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.data.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.42),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _GlassButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Ink(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.055),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.09),
              ),
            ),
            child: Icon(
              icon,
              size: 21,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}
