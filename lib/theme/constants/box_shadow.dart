import 'package:betaversion/theme/extensions/extension.dart';
import 'package:flutter/material.dart';

class AppBoxShadow {
  // Theme-aware shadow getter methods

  // Small shadows - subtle elevation
  static BoxShadow smallSoft(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x40000000) : const Color(0x0A000000),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow small(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x60000000) : const Color(0x1A000000),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }

  // Medium shadows - cards and containers
  static BoxShadow mediumSoft(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x50000000) : const Color(0x0F000000),
      blurRadius: 8,
      offset: const Offset(0, 4),
    );
  }

  static BoxShadow medium(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x60000000) : const Color(0x1A000000),
      blurRadius: 8,
      offset: const Offset(0, 4),
    );
  }

  static BoxShadow mediumSpread(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x60000000) : const Color(0x1A000000),
      blurRadius: 12,
      spreadRadius: 2,
      offset: const Offset(0, 4),
    );
  }

  // Large shadows - modals and floating elements
  static BoxShadow large(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x70000000) : const Color(0x1F000000),
      blurRadius: 16,
      offset: const Offset(0, 8),
    );
  }

  static BoxShadow largeSoft(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x50000000) : const Color(0x14000000),
      blurRadius: 24,
      offset: const Offset(0, 8),
    );
  }

  static BoxShadow largeSpread(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x70000000) : const Color(0x1F000000),
      blurRadius: 24,
      spreadRadius: 4,
      offset: const Offset(0, 12),
    );
  }

  // Extra large shadows - high elevation elements
  static BoxShadow extraLarge(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x80000000) : const Color(0x24000000),
      blurRadius: 32,
      offset: const Offset(0, 16),
    );
  }

  // Inner shadows
  static BoxShadow innerSmall(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x40000000) : const Color(0x0A000000),
      blurRadius: 4,
      offset: const Offset(0, -2),
    );
  }

  static BoxShadow innerMedium(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x50000000) : const Color(0x0F000000),
      blurRadius: 8,
      offset: const Offset(0, -4),
    );
  }

  // Colored shadows - using brand colors
  static BoxShadow brandSoft(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x404466FF) : const Color(0x1A4466FF),
      blurRadius: 12,
      offset: const Offset(0, 4),
    );
  }

  static BoxShadow brand(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x664466FF) : const Color(0x334466FF),
      blurRadius: 16,
      offset: const Offset(0, 8),
    );
  }

  // Button shadows
  static BoxShadow button(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x60000000) : const Color(0x1A000000),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow buttonHover(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x80000000) : const Color(0x24000000),
      blurRadius: 8,
      offset: const Offset(0, 4),
    );
  }

  static BoxShadow buttonPressed(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x30000000) : const Color(0x0A000000),
      blurRadius: 2,
      offset: const Offset(0, 1),
    );
  }

  // Card shadows
  static BoxShadow card(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x50000000) : const Color(0x0F000000),
      blurRadius: 8,
      offset: const Offset(0, 2),
    );
  }

  static BoxShadow cardHover(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x60000000) : const Color(0x1A000000),
      blurRadius: 12,
      offset: const Offset(0, 4),
    );
  }

  // Bottom sheet shadow
  static BoxShadow bottomSheet(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x70000000) : const Color(0x1F000000),
      blurRadius: 24,
      offset: const Offset(0, -4),
    );
  }

  // App bar shadow
  static BoxShadow appBar(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return BoxShadow(
      color: isDark ? const Color(0x40000000) : const Color(0x0A000000),
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
  }

  // Predefined shadow lists for multiple shadows
  static List<BoxShadow> elevation1(BuildContext context) => [
    smallSoft(context),
  ];
  static List<BoxShadow> elevation2(BuildContext context) => [small(context)];
  static List<BoxShadow> elevation3(BuildContext context) => [medium(context)];
  static List<BoxShadow> elevation4(BuildContext context) => [
    mediumSpread(context),
  ];
  static List<BoxShadow> elevation5(BuildContext context) => [large(context)];
  static List<BoxShadow> elevation6(BuildContext context) => [
    largeSoft(context),
  ];
  static List<BoxShadow> elevation8(BuildContext context) => [
    largeSpread(context),
  ];
  static List<BoxShadow> elevation12(BuildContext context) => [
    extraLarge(context),
  ];

  // Layered shadows for more realistic elevation
  static List<BoxShadow> layeredSmall(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return [
      BoxShadow(
        color: isDark ? const Color(0x30000000) : const Color(0x0A000000),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
      BoxShadow(
        color: isDark ? const Color(0x50000000) : const Color(0x0F000000),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> layeredMedium(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return [
      BoxShadow(
        color: isDark ? const Color(0x30000000) : const Color(0x0A000000),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
      BoxShadow(
        color: isDark ? const Color(0x50000000) : const Color(0x14000000),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> layeredLarge(BuildContext context) {
    final isDark = Theme.of(context).isDark;
    return [
      BoxShadow(
        color: isDark ? const Color(0x30000000) : const Color(0x0A000000),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: isDark ? const Color(0x50000000) : const Color(0x14000000),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: isDark ? const Color(0x60000000) : const Color(0x1A000000),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ];
  }
}
