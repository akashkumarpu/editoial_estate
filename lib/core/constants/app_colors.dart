import 'package:flutter/material.dart';

/// Design tokens from The Editorial Estate design system.
/// Based on Material 3 color roles with a teal primary palette.
class AppColors {
  AppColors._();

  // ── Primary (Teal) ──────────────────────────────────────────────
  static const Color primary = Color(0xFF006068);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF007B85);
  static const Color onPrimaryContainer = Color(0xFFD5FAFF);
  static const Color primaryFixed = Color(0xFF96F1FC);
  static const Color primaryFixedDim = Color(0xFF7AD4DF);
  static const Color onPrimaryFixed = Color(0xFF001F23);
  static const Color onPrimaryFixedVariant = Color(0xFF004F56);
  static const Color inversePrimary = Color(0xFF7AD4DF);

  // ── Secondary ────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF5E5E62);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE3E2E6);
  static const Color onSecondaryContainer = Color(0xFF646468);
  static const Color secondaryFixed = Color(0xFFE3E2E6);
  static const Color secondaryFixedDim = Color(0xFFC7C6CA);
  static const Color onSecondaryFixed = Color(0xFF1A1B1E);
  static const Color onSecondaryFixedVariant = Color(0xFF46474A);

  // ── Tertiary (Accent / Orange-Brown) ─────────────────────────────
  static const Color tertiary = Color(0xFF844718);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFA15F2E);
  static const Color onTertiaryContainer = Color(0xFFFFF1EA);
  static const Color tertiaryFixed = Color(0xFFFFDCC6);
  static const Color tertiaryFixedDim = Color(0xFFFFB786);
  static const Color onTertiaryFixed = Color(0xFF311300);
  static const Color onTertiaryFixedVariant = Color(0xFF703808);

  // ── Error ────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Surface (Light Mode) ──────────────────────────────────────────
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceBright = Color(0xFFF8F9FA);
  static const Color surfaceDim = Color(0xFFD9DADB);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);
  static const Color surfaceVariant = Color(0xFFE1E3E4);
  static const Color onSurface = Color(0xFF191C1D);
  static const Color onSurfaceVariant = Color(0xFF3E494A);
  static const Color inverseSurface = Color(0xFF2E3132);
  static const Color inverseOnSurface = Color(0xFFF0F1F2);

  // ── Outline ───────────────────────────────────────────────────────
  static const Color outline = Color(0xFF6E797A);
  static const Color outlineVariant = Color(0xFFBDC9CA);

  // ── Background ────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FA);
  static const Color onBackground = Color(0xFF191C1D);

  // ── Misc ──────────────────────────────────────────────────────────
  static const Color surfaceTint = Color(0xFF006971);

  // ── Semantic / Gradient helpers ───────────────────────────────────
  /// Signature editorial gradient: primary → primaryContainer
  static const LinearGradient editorialGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  /// Glass surface: surface at 80% opacity
  static Color glassSurface = surface.withValues(alpha: 0.80);
  static Color glassSurfaceLight = surface.withValues(alpha: 0.50);
}
