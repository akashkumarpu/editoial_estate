import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/property.dart';
import '../bloc/explore_bloc.dart';
import '../widgets/property_pin_widget.dart';
import '../widgets/property_preview_card.dart';

class ExploreMapPage extends StatelessWidget {
  const ExploreMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExploreBloc>()..add(const ExploreLoadProperties()),
      child: const _ExploreMapView(),
    );
  }
}

class _ExploreMapView extends StatefulWidget {
  const _ExploreMapView();

  @override
  State<_ExploreMapView> createState() => _ExploreMapViewState();
}

class _ExploreMapViewState extends State<_ExploreMapView>
    with AutomaticKeepAliveClientMixin {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  final _sheetController = DraggableScrollableController();
  bool _isSheetExpanded = false;

  static const _bangaloreCenter = LatLng(12.9716, 77.5946);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state is ExploreLoading || state is ExploreInitial) {
          return const _LoadingView();
        }
        if (state is ExploreError) {
          return _ErrorView(message: state.message);
        }

        final loaded = state as ExploreLoaded;

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Stack(
            children: [
              // ── Full screen map ─────────────────────────────────
              RepaintBoundary(
                child: _MapView(
                  properties: loaded.filteredProperties,
                  selectedProperty: loaded.selectedProperty,
                  mapController: _mapController,
                  onPinTapped: (property) {
                    context
                        .read<ExploreBloc>()
                        .add(ExplorePropertyTapped(property));
                    _mapController.move(
                      LatLng(property.lat, property.lng),
                      14.0,
                    );
                  },
                ),
              ),

              // ── Floating top bar ────────────────────────────────
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(searchController: _searchController),
                  ],
                ),
              ),

              // ── FAB ─────────────────────────────────────────────
              Positioned(
                right: 20,
                bottom: _isSheetExpanded ? 480 : 280,
                child: RepaintBoundary(
                  child: _FloatingAddButton(),
                ),
              ),

              // ── View toggle ─────────────────────────────────────
              Positioned(
                bottom: _isSheetExpanded ? 430 : 230,
                left: 0,
                right: 0,
                child: Center(
                  child: _ViewToggle(
                    isMap: loaded.isMapView,
                    onToggle: () =>
                        context.read<ExploreBloc>().add(const ExploreViewToggled()),
                  ),
                ),
              ),

              // ── Bottom sheet ─────────────────────────────────────
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: 0.22,
                minChildSize: 0.14,
                maxChildSize: 0.7,
                builder: (context, scrollController) {
                  return NotificationListener<DraggableScrollableNotification>(
                    onNotification: (n) {
                      setState(() => _isSheetExpanded = n.extent > 0.35);
                      return false;
                    },
                    child: _BottomSheet(
                      scrollController: scrollController,
                      properties: loaded.filteredProperties,
                      selectedProperty: loaded.selectedProperty,
                      onPropertyTap: (p) {
                        context.go('/explore/property/${p.id}');
                      },
                      onSaveTap: (p) {
                        context
                            .read<ExploreBloc>()
                            .add(ExploreSaveToggled(p.id));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Map View ───────────────────────────────────────────────────────────────

class _MapView extends StatelessWidget {
  const _MapView({
    required this.properties,
    required this.selectedProperty,
    required this.mapController,
    required this.onPinTapped,
  });

  final List<Property> properties;
  final Property? selectedProperty;
  final MapController mapController;
  final void Function(Property) onPinTapped;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: _ExploreMapViewState._bangaloreCenter,
        initialZoom: 12.5,
        minZoom: 10,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.editorialestate.app',
          retinaMode: RetinaMode.isHighDensity(context),
          tileProvider: NetworkTileProvider(),
        ),
        MarkerLayer(
          markers: properties.map((property) {
            final isSelected = selectedProperty?.id == property.id;
            return Marker(
              point: LatLng(property.lat, property.lng),
              width: 100,
              height: 48,
              child: RepaintBoundary(
                child: PropertyPinWidget(
                  property: property,
                  isSelected: isSelected,
                  onTap: () => onPinTapped(property),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Top Bar ────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.searchController});
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          // App header
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primary),
                    const SizedBox(width: 10),
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
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: AppColors.primary, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Search bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withValues(alpha: 0.06),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.explore, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BlocBuilder<ExploreBloc, ExploreState>(
                        builder: (context, state) => TextField(
                          controller: searchController,
                          onChanged: (q) => context
                              .read<ExploreBloc>()
                              .add(ExploreSearchChanged(q)),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: AppStrings.searchPlaceholder,
                            hintStyle: GoogleFonts.inter(
                              color: AppColors.outline,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    const Icon(Icons.filter_list, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Sheet ───────────────────────────────────────────────────────────

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    required this.scrollController,
    required this.properties,
    required this.selectedProperty,
    required this.onPropertyTap,
    required this.onSaveTap,
  });

  final ScrollController scrollController;
  final List<Property> properties;
  final Property? selectedProperty;
  final void Function(Property) onPropertyTap;
  final void Function(Property) onSaveTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.zero,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Selected property card
          if (selectedProperty != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: PropertyPreviewCard(
                property: selectedProperty!,
                onTap: () => onPropertyTap(selectedProperty!),
                onSaveTap: () => onSaveTap(selectedProperty!),
              ),
            ),

          // All properties header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              '${properties.length} Properties Found',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Property list
          ...properties.map(
            (p) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: PropertyPreviewCard(
                property: p,
                onTap: () => onPropertyTap(p),
                onSaveTap: () => onSaveTap(p),
              ),
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

// ── View Toggle ────────────────────────────────────────────────────────────

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.isMap, required this.onToggle});
  final bool isMap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inverseSurface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleChip(
            icon: Icons.map_outlined,
            label: AppStrings.mapView,
            isActive: isMap,
            onTap: !isMap ? onToggle : null,
          ),
          _ToggleChip(
            icon: Icons.format_list_bulleted,
            label: AppStrings.listView,
            isActive: !isMap,
            onTap: isMap ? onToggle : null,
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.surfaceContainerLowest.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: isActive
                    ? AppColors.inverseOnSurface
                    : AppColors.inverseOnSurface.withValues(alpha: 0.5)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isActive
                    ? AppColors.inverseOnSurface
                    : AppColors.inverseOnSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── FAB ────────────────────────────────────────────────────────────────────

class _FloatingAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.editorialGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.add_location_alt, color: Colors.white, size: 26),
      ),
    );
  }
}

// ── Loading / Error states ─────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text('Loading the estate...',
                style: GoogleFonts.inter(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(message)),
    );
  }
}
