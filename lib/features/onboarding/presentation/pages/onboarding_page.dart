import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToApp(BuildContext context) {
    context.go('/explore');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (prev, curr) => prev.isCompleted != curr.isCompleted,
      listener: (context, state) {
        if (state.isCompleted) _navigateToApp(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Stack(
          children: [
            // Background gradient blob
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  gradient: AppColors.editorialGradient,
                  shape: BoxShape.circle,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Header
                  _Header(
                    onSkip: () =>
                        context.read<OnboardingCubit>().skipOnboarding(),
                  ),

                  // Slides
                  Expanded(
                    child: BlocBuilder<OnboardingCubit, OnboardingState>(
                      builder: (context, state) {
                        return PageView(
                          controller: _pageController,
                          onPageChanged: (i) =>
                              context.read<OnboardingCubit>().goToPage(i),
                          children: const [
                            _SlideMapDiscovery(),
                            _SlideLivePrecision(),
                            _SlideDirectDialogue(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Footer pinned at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _Footer(
                pageController: _pageController,
                onContinue: () =>
                    context.read<OnboardingCubit>().completeOnboarding(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onSkip});
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.appName,
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.primary,
            ),
          ),
          TextButton(
            onPressed: onSkip,
            child: Text(
              AppStrings.skip.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide 1: Map Discovery ─────────────────────────────────────────────────

class _SlideMapDiscovery extends StatelessWidget {
  const _SlideMapDiscovery();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image card
          RepaintBoundary(
            child: Container(
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=700&q=80',
                      fit: BoxFit.cover,
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                    // Glass card
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: _GlassCard(
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.map_outlined,
                                  color: AppColors.primary),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Curated Mapping',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: AppColors.onSurface)),
                                Text('Discover beyond boundaries.',
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          RichText(
            text: TextSpan(
              style: GoogleFonts.manrope(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
                height: 1.15,
              ),
              children: const [
                TextSpan(text: 'Explore with\n'),
                TextSpan(
                    text: 'Intent.',
                    style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Experience property discovery through an editorial lens. Our spatial interface transforms listings into journeys.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Slide 2: Live Precision ────────────────────────────────────────────────

class _SlideLivePrecision extends StatefulWidget {
  const _SlideLivePrecision();

  @override
  State<_SlideLivePrecision> createState() => _SlideLivePrecisionState();
}

class _SlideLivePrecisionState extends State<_SlideLivePrecision>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: AppColors.surfaceContainerLow,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Map background
                Positioned.fill(
                  child: Image.network(
                    'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=700&q=80',
                    fit: BoxFit.cover,
                    color: AppColors.primary.withValues(alpha: 0.2),
                    colorBlendMode: BlendMode.overlay,
                  ),
                ),
                // Price pins
                _buildPin(top: 80, left: 60, label: '\$1.2M',
                    isPulse: true, isDark: true),
                _buildPin(top: 180, right: 60, label: '\$850K',
                    isPulse: false, isDark: false),
                _buildPin(top: 140, right: 120, label: '\$2.4M',
                    isPulse: false, isGradient: true),
              ],
            ),
          ),
          const SizedBox(height: 32),
          RichText(
            text: TextSpan(
              style: GoogleFonts.manrope(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
                height: 1.15,
              ),
              children: const [
                TextSpan(text: 'Live\n'),
                TextSpan(
                    text: 'Precision.',
                    style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Real-time valuation pins provide instant clarity. Transparent pricing, presented with absolute elegance.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPin({
    double? top,
    double? left,
    double? right,
    required String label,
    required bool isPulse,
    bool isDark = false,
    bool isGradient = false,
  }) {
    Widget pin = AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isGradient ? AppColors.editorialGradient : null,
          color: isGradient
              ? null
              : isDark
                  ? AppColors.primary
                  : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isPulse ? _pulse.value * 0.4 : 0.2),
              blurRadius: 16,
              spreadRadius: isPulse ? _pulse.value * 4 : 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: isDark || isGradient ? Colors.white : AppColors.onSurface,
          ),
        ),
      ),
    );

    return Positioned(
      top: top,
      left: left,
      right: right,
      child: pin,
    );
  }
}

// ── Slide 3: Direct Dialogue ───────────────────────────────────────────────

class _SlideDirectDialogue extends StatelessWidget {
  const _SlideDirectDialogue();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1497366216548-37526070297c?w=700&q=80',
                  fit: BoxFit.cover,
                ),
                Container(color: AppColors.primary.withValues(alpha: 0.2)),
                Center(
                  child: _GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&q=80',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Julian Vance',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onSurface,
                                        fontSize: 13)),
                                Text('Verified Owner',
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: 160,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          RichText(
            text: TextSpan(
              style: GoogleFonts.manrope(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
                letterSpacing: -0.5,
                height: 1.15,
              ),
              children: const [
                TextSpan(text: 'Direct\n'),
                TextSpan(
                    text: 'Dialogue.',
                    style: TextStyle(color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No middlemen. Connect directly with owners through our verified concierge service.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer ─────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({
    required this.pageController,
    required this.onContinue,
  });

  final PageController pageController;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 40,
                offset: const Offset(0, -12),
              ),
            ],
          ),
          padding:
              const EdgeInsets.fromLTRB(28, 20, 28, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Page indicator
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  return SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotColor: AppColors.surfaceContainerHighest,
                      activeDotColor: AppColors.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3.5,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Continue with Phone
              _GradientButton(
                label: AppStrings.continueWithPhone,
                icon: Icons.phone_outlined,
                onTap: onContinue,
              ),
              const SizedBox(height: 16),

              // Social buttons
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      label: AppStrings.continueWithGoogle,
                      icon: Icons.g_mobiledata_rounded,
                      onTap: onContinue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SocialButton(
                      label: AppStrings.continueWithApple,
                      icon: Icons.apple,
                      onTap: onContinue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Terms
              Text(
                AppStrings.termsText,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared Widgets ─────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.padding});
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.glassSurface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: AppColors.editorialGradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onSurface, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
