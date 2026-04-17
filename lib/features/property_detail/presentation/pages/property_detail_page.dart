import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../explore/domain/entities/property.dart';
import '../../../explore/domain/repositories/property_repository.dart';
import '../cubit/property_detail_cubit.dart';

class PropertyDetailPage extends StatelessWidget {
  const PropertyDetailPage({super.key, required this.propertyId});
  final String propertyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PropertyDetailCubit(sl<PropertyRepository>())..load(propertyId),
      child: const _PropertyDetailView(),
    );
  }
}

class _PropertyDetailView extends StatelessWidget {
  const _PropertyDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyDetailCubit, PropertyDetailState>(
      builder: (context, state) {
        if (state is PropertyDetailLoading) {
          return const _LoadingSkeleton();
        }
        if (state is PropertyDetailError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is PropertyDetailLoaded) {
          return _DetailContent(property: state.property);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _DetailContent extends StatefulWidget {
  const _DetailContent({required this.property});
  final Property property;

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent> {
  late final PageController _carousel;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _carousel = PageController();
  }

  @override
  void dispose() {
    _carousel.dispose();
    super.dispose();
  }

  static const _amenityIcons = {
    'wifi': Icons.wifi,
    'fitness_center': Icons.fitness_center,
    'pool': Icons.pool,
    'local_parking': Icons.local_parking,
    'ac_unit': Icons.ac_unit,
    'elevator': Icons.elevator,
  };

  static const _amenityLabels = {
    'wifi': 'WiFi',
    'fitness_center': 'Gym',
    'pool': 'Pool',
    'local_parking': 'Parking',
    'ac_unit': 'AC',
    'elevator': 'Elevator',
  };

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // Hero image carousel
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 380,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _carousel,
                        itemCount: p.images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImage = i),
                        itemBuilder: (_, i) => CachedNetworkImage(
                          imageUrl: p.images[i],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: AppColors.surfaceContainerHigh,
                            highlightColor: AppColors.surfaceContainerLow,
                            child: Container(color: Colors.white),
                          ),
                        ),
                      ),

                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.surface,
                                AppColors.surface.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Save button
                      Positioned(
                        top: 20 +
                            MediaQuery.of(context).padding.top,
                        right: 16,
                        child: BlocBuilder<PropertyDetailCubit,
                            PropertyDetailState>(
                          builder: (context, state) {
                            final isSaved = state is PropertyDetailLoaded
                                ? state.property.isSaved
                                : false;
                            return GestureDetector(
                              onTap: () => context
                                  .read<PropertyDetailCubit>()
                                  .toggleSave(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 12, sigmaY: 12),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: Icon(
                                        isSaved
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        key: ValueKey(isSaved),
                                        color: isSaved
                                            ? AppColors.tertiary
                                            : AppColors.tertiary,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Carousel dots
                      Positioned(
                        bottom: 70,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: List.generate(
                                  p.images.length,
                                  (i) => AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 250),
                                    width: i == _currentImage ? 16 : 6,
                                    height: 6,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: i == _currentImage
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.5),
                                      borderRadius:
                                          BorderRadius.circular(999),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Property info card
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tag + price
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.tag.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.tertiary,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.title,
                                    style: GoogleFonts.manrope(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSurface,
                                      letterSpacing: -0.3,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    p.isRental
                                        ? '₹${(p.monthlyRent ?? 0).toStringAsFixed(0)}'
                                        : p.priceLabel,
                                    style: GoogleFonts.manrope(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (p.isRental)
                                    Text('/mo',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppColors.onSurfaceVariant,
                                        )),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Location
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  p.address,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Specs grid
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  _SpecItem(
                                      value: '${p.beds}',
                                      label: 'BHK'),
                                  const VerticalDivider(
                                      color: AppColors.outlineVariant,
                                      width: 1,
                                      thickness: 1),
                                  _SpecItem(
                                      value: p.sqft.toStringAsFixed(0),
                                      label: 'SQFT'),
                                  const VerticalDivider(
                                      color: AppColors.outlineVariant,
                                      width: 1,
                                      thickness: 1),
                                  _SpecItem(
                                      value: p.facing, label: 'FACING'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Agent card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(AppStrings.managedBy),
                      const SizedBox(height: 12),
                      _AgentCard(property: p),
                    ],
                  ),
                ),
              ),

              // Amenities
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SectionLabel(AppStrings.amenities),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              AppStrings.viewAll,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 88,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: p.amenities.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) {
                            final key = p.amenities[i];
                            return _AmenityChip(
                              icon: _amenityIcons[key] ?? Icons.check,
                              label: _amenityLabels[key] ?? key,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Description
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(AppStrings.theExperience),
                      const SizedBox(height: 12),
                      Text(
                        p.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          AppStrings.readFullEditorial,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Neighborhood mini map
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(AppStrings.theNeighborhood),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              FlutterMap(
                                options: MapOptions(
                                  initialCenter:
                                      LatLng(p.lat, p.lng),
                                  initialZoom: 15,
                                  interactionOptions:
                                      const InteractionOptions(
                                    flags: InteractiveFlag.none,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.editorialestate.app',
                                    tileProvider:
                                        NetworkTileProvider(),
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(p.lat, p.lng),
                                        width: 40,
                                        height: 40,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 16,
                                              height: 16,
                                              decoration:
                                                  BoxDecoration(
                                                color:
                                                    AppColors.primary,
                                                shape:
                                                    BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Connectivity score overlay
                              Positioned(
                                bottom: 12,
                                left: 12,
                                right: 12,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 12, sigmaY: 12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      color: Colors.white.withValues(alpha: 0.9),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Excellent Connectivity Score',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.onSurface,
                                            ),
                                          ),
                                          Text(
                                            '${p.connectivityScore}/10',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Top Nav overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: MediaQuery.of(context).padding.top + 60,
                  color: AppColors.surface.withValues(alpha: 0.8),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 8,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.primary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.appName,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.tune, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sticky bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    MediaQuery.of(context).padding.bottom + 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
                    border: const Border(
                      top: BorderSide(
                          color: AppColors.surfaceContainerHigh, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      _IconCTA(
                          icon: Icons.phone_outlined,
                          onTap: () => launchUrl(Uri.parse('tel:+911234567890'))),
                      const SizedBox(width: 12),
                      _IconCTA(
                          icon: Icons.chat_bubble_outline,
                          onTap: () {}),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: AppColors.editorialGradient,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                AppStrings.scheduleViewing,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _SpecItem extends StatelessWidget {
  const _SpecItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.8)),
        ],
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({required this.property});
  final Property property;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.04),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: property.agentImageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  color: AppColors.surfaceContainerHigh),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property.agentName,
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        fontSize: 14)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 3),
                    Text(
                      '${property.agentRating} (${property.agentReviews} reviews)',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  const _AmenityChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _IconCTA extends StatelessWidget {
  const _IconCTA({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer.fromColors(
        baseColor: AppColors.surfaceContainerHigh,
        highlightColor: AppColors.surfaceContainerLow,
        child: Column(
          children: [
            Container(height: 380, color: Colors.white),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 20, width: 120, color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 8)),
                  Container(height: 28, color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12)),
                  Container(height: 80, decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
