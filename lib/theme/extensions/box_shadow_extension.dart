import 'package:flutter/material.dart';

extension ThemeDataBoxShadowExtension on ThemeData {
  BoxShadowExtension get shadows => extension<BoxShadowExtension>()!;
}

extension BuildContextBoxShadowExtension on BuildContext {
  BoxShadowExtension get shadows => Theme.of(this).shadows;
}

@immutable
class BoxShadowExtension extends ThemeExtension<BoxShadowExtension> {
  final BoxShadow smallSoft;
  final BoxShadow small;
  final BoxShadow mediumSoft;
  final BoxShadow medium;
  final BoxShadow mediumSpread;
  final BoxShadow large;
  final BoxShadow largeSoft;
  final BoxShadow largeSpread;
  final BoxShadow extraLarge;
  final BoxShadow innerSmall;
  final BoxShadow innerMedium;
  final BoxShadow brandSoft;
  final BoxShadow brand;
  final BoxShadow button;
  final BoxShadow buttonHover;
  final BoxShadow buttonPressed;
  final BoxShadow card;
  final BoxShadow cardHover;
  final BoxShadow bottomSheet;
  final BoxShadow appBar;
  final List<BoxShadow> elevation1;
  final List<BoxShadow> elevation2;
  final List<BoxShadow> elevation3;
  final List<BoxShadow> elevation4;
  final List<BoxShadow> elevation5;
  final List<BoxShadow> elevation6;
  final List<BoxShadow> elevation8;
  final List<BoxShadow> elevation12;
  final List<BoxShadow> layeredSmall;
  final List<BoxShadow> layeredMedium;
  final List<BoxShadow> layeredLarge;

  const BoxShadowExtension({
    required this.smallSoft,
    required this.small,
    required this.mediumSoft,
    required this.medium,
    required this.mediumSpread,
    required this.large,
    required this.largeSoft,
    required this.largeSpread,
    required this.extraLarge,
    required this.innerSmall,
    required this.innerMedium,
    required this.brandSoft,
    required this.brand,
    required this.button,
    required this.buttonHover,
    required this.buttonPressed,
    required this.card,
    required this.cardHover,
    required this.bottomSheet,
    required this.appBar,
    required this.elevation1,
    required this.elevation2,
    required this.elevation3,
    required this.elevation4,
    required this.elevation5,
    required this.elevation6,
    required this.elevation8,
    required this.elevation12,
    required this.layeredSmall,
    required this.layeredMedium,
    required this.layeredLarge,
  });

  static BoxShadowExtension of(BuildContext context) {
    return Theme.of(context).extension<BoxShadowExtension>()!;
  }

  @override
  BoxShadowExtension copyWith({
    BoxShadow? smallSoft,
    BoxShadow? small,
    BoxShadow? mediumSoft,
    BoxShadow? medium,
    BoxShadow? mediumSpread,
    BoxShadow? large,
    BoxShadow? largeSoft,
    BoxShadow? largeSpread,
    BoxShadow? extraLarge,
    BoxShadow? innerSmall,
    BoxShadow? innerMedium,
    BoxShadow? brandSoft,
    BoxShadow? brand,
    BoxShadow? button,
    BoxShadow? buttonHover,
    BoxShadow? buttonPressed,
    BoxShadow? card,
    BoxShadow? cardHover,
    BoxShadow? bottomSheet,
    BoxShadow? appBar,
    List<BoxShadow>? elevation1,
    List<BoxShadow>? elevation2,
    List<BoxShadow>? elevation3,
    List<BoxShadow>? elevation4,
    List<BoxShadow>? elevation5,
    List<BoxShadow>? elevation6,
    List<BoxShadow>? elevation8,
    List<BoxShadow>? elevation12,
    List<BoxShadow>? layeredSmall,
    List<BoxShadow>? layeredMedium,
    List<BoxShadow>? layeredLarge,
  }) {
    return BoxShadowExtension(
      smallSoft: smallSoft ?? this.smallSoft,
      small: small ?? this.small,
      mediumSoft: mediumSoft ?? this.mediumSoft,
      medium: medium ?? this.medium,
      mediumSpread: mediumSpread ?? this.mediumSpread,
      large: large ?? this.large,
      largeSoft: largeSoft ?? this.largeSoft,
      largeSpread: largeSpread ?? this.largeSpread,
      extraLarge: extraLarge ?? this.extraLarge,
      innerSmall: innerSmall ?? this.innerSmall,
      innerMedium: innerMedium ?? this.innerMedium,
      brandSoft: brandSoft ?? this.brandSoft,
      brand: brand ?? this.brand,
      button: button ?? this.button,
      buttonHover: buttonHover ?? this.buttonHover,
      buttonPressed: buttonPressed ?? this.buttonPressed,
      card: card ?? this.card,
      cardHover: cardHover ?? this.cardHover,
      bottomSheet: bottomSheet ?? this.bottomSheet,
      appBar: appBar ?? this.appBar,
      elevation1: elevation1 ?? this.elevation1,
      elevation2: elevation2 ?? this.elevation2,
      elevation3: elevation3 ?? this.elevation3,
      elevation4: elevation4 ?? this.elevation4,
      elevation5: elevation5 ?? this.elevation5,
      elevation6: elevation6 ?? this.elevation6,
      elevation8: elevation8 ?? this.elevation8,
      elevation12: elevation12 ?? this.elevation12,
      layeredSmall: layeredSmall ?? this.layeredSmall,
      layeredMedium: layeredMedium ?? this.layeredMedium,
      layeredLarge: layeredLarge ?? this.layeredLarge,
    );
  }

  @override
  BoxShadowExtension lerp(BoxShadowExtension? other, double t) {
    if (other is! BoxShadowExtension) {
      return this;
    }

    return BoxShadowExtension(
      smallSoft: BoxShadow.lerp(smallSoft, other.smallSoft, t)!,
      small: BoxShadow.lerp(small, other.small, t)!,
      mediumSoft: BoxShadow.lerp(mediumSoft, other.mediumSoft, t)!,
      medium: BoxShadow.lerp(medium, other.medium, t)!,
      mediumSpread: BoxShadow.lerp(mediumSpread, other.mediumSpread, t)!,
      large: BoxShadow.lerp(large, other.large, t)!,
      largeSoft: BoxShadow.lerp(largeSoft, other.largeSoft, t)!,
      largeSpread: BoxShadow.lerp(largeSpread, other.largeSpread, t)!,
      extraLarge: BoxShadow.lerp(extraLarge, other.extraLarge, t)!,
      innerSmall: BoxShadow.lerp(innerSmall, other.innerSmall, t)!,
      innerMedium: BoxShadow.lerp(innerMedium, other.innerMedium, t)!,
      brandSoft: BoxShadow.lerp(brandSoft, other.brandSoft, t)!,
      brand: BoxShadow.lerp(brand, other.brand, t)!,
      button: BoxShadow.lerp(button, other.button, t)!,
      buttonHover: BoxShadow.lerp(buttonHover, other.buttonHover, t)!,
      buttonPressed: BoxShadow.lerp(buttonPressed, other.buttonPressed, t)!,
      card: BoxShadow.lerp(card, other.card, t)!,
      cardHover: BoxShadow.lerp(cardHover, other.cardHover, t)!,
      bottomSheet: BoxShadow.lerp(bottomSheet, other.bottomSheet, t)!,
      appBar: BoxShadow.lerp(appBar, other.appBar, t)!,
      elevation1: BoxShadow.lerpList(elevation1, other.elevation1, t)!,
      elevation2: BoxShadow.lerpList(elevation2, other.elevation2, t)!,
      elevation3: BoxShadow.lerpList(elevation3, other.elevation3, t)!,
      elevation4: BoxShadow.lerpList(elevation4, other.elevation4, t)!,
      elevation5: BoxShadow.lerpList(elevation5, other.elevation5, t)!,
      elevation6: BoxShadow.lerpList(elevation6, other.elevation6, t)!,
      elevation8: BoxShadow.lerpList(elevation8, other.elevation8, t)!,
      elevation12: BoxShadow.lerpList(elevation12, other.elevation12, t)!,
      layeredSmall: BoxShadow.lerpList(layeredSmall, other.layeredSmall, t)!,
      layeredMedium: BoxShadow.lerpList(layeredMedium, other.layeredMedium, t)!,
      layeredLarge: BoxShadow.lerpList(layeredLarge, other.layeredLarge, t)!,
    );
  }
}

BoxShadowExtension lightBoxShadows = BoxShadowExtension(
  smallSoft: const BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  small: const BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  mediumSoft: const BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
  medium: const BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
  mediumSpread: const BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    spreadRadius: 2,
    offset: Offset(0, 4),
  ),
  large: const BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  ),
  largeSoft: const BoxShadow(
    color: Color(0x14000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  ),
  largeSpread: const BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 24,
    spreadRadius: 4,
    offset: Offset(0, 12),
  ),
  extraLarge: const BoxShadow(
    color: Color(0x24000000),
    blurRadius: 32,
    offset: Offset(0, 16),
  ),
  innerSmall: const BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 4,
    offset: Offset(0, -2),
  ),
  innerMedium: const BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 8,
    offset: Offset(0, -4),
  ),
  brandSoft: const BoxShadow(
    color: Color(0x1A4466FF),
    blurRadius: 12,
    offset: Offset(0, 4),
  ),
  brand: const BoxShadow(
    color: Color(0x334466FF),
    blurRadius: 16,
    offset: Offset(0, 8),
  ),
  button: const BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  buttonHover: const BoxShadow(
    color: Color(0x24000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
  buttonPressed: const BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  ),
  card: const BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
  cardHover: const BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  ),
  bottomSheet: const BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 24,
    offset: Offset(0, -4),
  ),
  appBar: const BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  elevation1: const [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
  ],
  elevation2: const [
    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2)),
  ],
  elevation3: const [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4)),
  ],
  elevation4: const [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 12,
      spreadRadius: 2,
      offset: Offset(0, 4),
    ),
  ],
  elevation5: const [
    BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, 8)),
  ],
  elevation6: const [
    BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 8)),
  ],
  elevation8: const [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 24,
      spreadRadius: 4,
      offset: Offset(0, 12),
    ),
  ],
  elevation12: const [
    BoxShadow(color: Color(0x24000000), blurRadius: 32, offset: Offset(0, 16)),
  ],
  layeredSmall: const [
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 2)),
  ],
  layeredMedium: const [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
  ],
  layeredLarge: const [
    BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x1A000000), blurRadius: 24, offset: Offset(0, 12)),
  ],
);

BoxShadowExtension darkBoxShadows = BoxShadowExtension(
  smallSoft: const BoxShadow(
    color: Color(0x40000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  small: const BoxShadow(
    color: Color(0x60000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  mediumSoft: const BoxShadow(
    color: Color(0x50000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
  medium: const BoxShadow(
    color: Color(0x60000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
  mediumSpread: const BoxShadow(
    color: Color(0x60000000),
    blurRadius: 12,
    spreadRadius: 2,
    offset: Offset(0, 4),
  ),
  large: const BoxShadow(
    color: Color(0x70000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  ),
  largeSoft: const BoxShadow(
    color: Color(0x50000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  ),
  largeSpread: const BoxShadow(
    color: Color(0x70000000),
    blurRadius: 24,
    spreadRadius: 4,
    offset: Offset(0, 12),
  ),
  extraLarge: const BoxShadow(
    color: Color(0x80000000),
    blurRadius: 32,
    offset: Offset(0, 16),
  ),
  innerSmall: const BoxShadow(
    color: Color(0x40000000),
    blurRadius: 4,
    offset: Offset(0, -2),
  ),
  innerMedium: const BoxShadow(
    color: Color(0x50000000),
    blurRadius: 8,
    offset: Offset(0, -4),
  ),
  brandSoft: const BoxShadow(
    color: Color(0x404466FF),
    blurRadius: 12,
    offset: Offset(0, 4),
  ),
  brand: const BoxShadow(
    color: Color(0x664466FF),
    blurRadius: 16,
    offset: Offset(0, 8),
  ),
  button: const BoxShadow(
    color: Color(0x60000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  buttonHover: const BoxShadow(
    color: Color(0x80000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
  buttonPressed: const BoxShadow(
    color: Color(0x30000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  ),
  card: const BoxShadow(
    color: Color(0x50000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  ),
  cardHover: const BoxShadow(
    color: Color(0x60000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  ),
  bottomSheet: const BoxShadow(
    color: Color(0x70000000),
    blurRadius: 24,
    offset: Offset(0, -4),
  ),
  appBar: const BoxShadow(
    color: Color(0x40000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
  elevation1: const [
    BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2)),
  ],
  elevation2: const [
    BoxShadow(color: Color(0x60000000), blurRadius: 4, offset: Offset(0, 2)),
  ],
  elevation3: const [
    BoxShadow(color: Color(0x60000000), blurRadius: 8, offset: Offset(0, 4)),
  ],
  elevation4: const [
    BoxShadow(
      color: Color(0x60000000),
      blurRadius: 12,
      spreadRadius: 2,
      offset: Offset(0, 4),
    ),
  ],
  elevation5: const [
    BoxShadow(color: Color(0x70000000), blurRadius: 16, offset: Offset(0, 8)),
  ],
  elevation6: const [
    BoxShadow(color: Color(0x50000000), blurRadius: 24, offset: Offset(0, 8)),
  ],
  elevation8: const [
    BoxShadow(
      color: Color(0x70000000),
      blurRadius: 24,
      spreadRadius: 4,
      offset: Offset(0, 12),
    ),
  ],
  elevation12: const [
    BoxShadow(color: Color(0x80000000), blurRadius: 32, offset: Offset(0, 16)),
  ],
  layeredSmall: const [
    BoxShadow(color: Color(0x30000000), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x50000000), blurRadius: 4, offset: Offset(0, 2)),
  ],
  layeredMedium: const [
    BoxShadow(color: Color(0x30000000), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x50000000), blurRadius: 8, offset: Offset(0, 4)),
  ],
  layeredLarge: const [
    BoxShadow(color: Color(0x30000000), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x50000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x60000000), blurRadius: 24, offset: Offset(0, 12)),
  ],
);
