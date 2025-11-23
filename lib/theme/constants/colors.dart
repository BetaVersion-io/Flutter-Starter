import 'package:flutter/material.dart';

/// Color constants for the betaversion application.
///
/// This class contains all the color definitions used throughout the app,
/// organized by color groups (grey, brand, error, warning, success) and
/// secondary color palettes (Clear Sky Blue, Midnight Blue).
class AppColors {
  // Grey Shades
  static const Color grey50 = Color(0xfff6f6f6);
  static const Color grey100 = Color(0xffe7e7e7);
  static const Color grey200 = Color(0xffd1d1d1);
  static const Color grey300 = Color(0xffb0b0b0);
  static const Color grey400 = Color(0xff888888);
  static const Color grey500 = Color(0xff6d6d6d);
  static const Color grey600 = Color(0xff5d5d5d);
  static const Color grey700 = Color(0xff4f4f4f);
  static const Color grey800 = Color(0xff454545);
  static const Color grey900 = Color(0xff3d3d3d);
  static const Color grey950 = Color(0xff000000);

  static const Color greySubtitle = Color(0xff646464);

  // Brand Colors
  static const Color brand50 = Color(0xfff6f6f6);
  static const Color brand100 = Color(0xffe7e7e7);
  static const Color brand200 = Color(0xffd1d1d1);
  static const Color brand300 = Color(0xffb0b0b0);
  static const Color brand400 = Color(0xff888888);
  static const Color brand500 = Color(0xff6d6d6d);
  static const Color brand600 = Color(0xff5d5d5d);
  static const Color brand700 = Color(0xff4f4f4f);
  static const Color brand800 = Color(0xff454545);
  static const Color brand900 = Color(0xff3d3d3d);
  static const Color brand950 = Color(0xff000000);

  // Error Colors
  static const Color error50 = Color(0xfffef4f2);
  static const Color error100 = Color(0xfffee6e2);
  static const Color error200 = Color(0xffffd0c9);
  static const Color error300 = Color(0xfffdb0a4);
  static const Color error400 = Color(0xfffa826f);
  static const Color error500 = Color(0xfff25941);
  static const Color error600 = Color(0xffdf3c23);
  static const Color error700 = Color(0xffbc2f19);
  static const Color error800 = Color(0xff9b2b19);
  static const Color error900 = Color(0xff7a271a);
  static const Color error950 = Color(0xff461109);

  // Warning Colors
  static const Color warning50 = Color(0xfffff8ec);
  static const Color warning100 = Color(0xffffefd4);
  static const Color warning200 = Color(0xffffdba7);
  static const Color warning300 = Color(0xffffc070);
  static const Color warning400 = Color(0xffff9936);
  static const Color warning500 = Color(0xffff7c0f);
  static const Color warning600 = Color(0xfff16005);
  static const Color warning700 = Color(0xffc84706);
  static const Color warning800 = Color(0xff9e380e);
  static const Color warning900 = Color(0xff7a2e0e);
  static const Color warning950 = Color(0xff451605);

  // Success Colors
  static const Color success50 = Color(0xffedfff7);
  static const Color success100 = Color(0xffd5ffed);
  static const Color success200 = Color(0xffaeffe6);
  static const Color success300 = Color(0xff6fffc2);
  static const Color success400 = Color(0xff29ffa1);
  static const Color success500 = Color(0xff00e983);
  static const Color success600 = Color(0xff00c268);
  static const Color success700 = Color(0xff009855);
  static const Color success800 = Color(0xff057646);
  static const Color success900 = Color(0xff054f31);
  static const Color success950 = Color(0xff00371f);

  // Secondary - Clear Sky Blue
  static const Color clearSkyBlue50 = Color(0xffecfeff);
  static const Color clearSkyBlue100 = Color(0xffd0f9fd);
  static const Color clearSkyBlue200 = Color(0xffa6f1fb);
  static const Color clearSkyBlue300 = Color(0xff69e5f7);
  static const Color clearSkyBlue400 = Color(0xff15cae8);
  static const Color clearSkyBlue500 = Color(0xff09b2d1);
  static const Color clearSkyBlue600 = Color(0xff0a8eb0);
  static const Color clearSkyBlue700 = Color(0xff10729e);
  static const Color clearSkyBlue800 = Color(0xff185c74);
  static const Color clearSkyBlue900 = Color(0xff174d62);
  static const Color clearSkyBlue950 = Color(0xff093243);

  // Secondary - MidNight Blue
  static const Color midNightBlue50 = Color(0xffeef7ff);
  static const Color midNightBlue100 = Color(0xffdceeff);
  static const Color midNightBlue200 = Color(0xffb2dfff);
  static const Color midNightBlue300 = Color(0xff6dc6ff);
  static const Color midNightBlue400 = Color(0xff20a8ff);
  static const Color midNightBlue500 = Color(0xff008dff);
  static const Color midNightBlue600 = Color(0xff006edf);
  static const Color midNightBlue700 = Color(0xff0057b4);
  static const Color midNightBlue800 = Color(0xff004194);
  static const Color midNightBlue900 = Color(0xff003060);
  static const Color midNightBlue950 = Color(0xff002651);

  // Gold
  static const Color gold50 = Color(0xffFFFFE7);
  static const Color gold100 = Color(0xffFEFFC1);
  static const Color gold200 = Color(0xffFFFD86);
  static const Color gold300 = Color(0xffFFF441);
  static const Color gold400 = Color(0xffFFE60D);
  static const Color gold500 = Color(0xffFFD700);
  static const Color gold600 = Color(0xffD19E00);
  static const Color gold700 = Color(0xffA67102);
  static const Color gold800 = Color(0xff89580A);
  static const Color gold900 = Color(0xff74480F);
  static const Color gold950 = Color(0xff442604);
  static const Color gold960 = Color(0xFFFFC200);

  static const Color videoTitleColor = Color(0xff424242);
  static const Color videoSubtitleColor = Color(0xff646464);
  static const Color onboardingCongratsColour = Color(0xff806700);

  // static const Color neutralColor800 = Color(0xff454545);
  //Dark Theme Colors
  static const Color darkThemePrimaryColor = Color(0xFF1E1E2C);

  //!Dark Grey Shades
  static const Color darkGrey50 = Color(
    0xFF2C2C2C,
  ); // Light dark background (similar to light grey50)
  static const Color darkGrey100 = Color(0xFF323232); // Slightly darker
  static const Color darkGrey200 = Color(0xFF3B3B3B);
  static const Color darkGrey300 = Color(0xFF4A4A4A);
  static const Color darkGrey400 = Color(0xFF5A5A5A);
  static const Color darkGrey500 = Color(0xFF6C6C6C);
  static const Color darkGrey600 = Color(0xFF7E7E7E);
  static const Color darkGrey700 = Color(0xFF8F8F8F);
  static const Color darkGrey800 = Color(0xFFA0A0A0);
  static const Color darkGrey900 = Color(0xFFB0B0B0);
  static const Color darkGrey950 = Color(
    0xFFFAFAFA,
  ); // Very light color for highlight text or thin borders

  static const Color darkGreySubtitle = Color(
    0xFF9E9E9E,
  ); // Good for subtitles/text in dark mode

  static const Color greenCalendaerDate = Color(0xff93E296);
  static const Color redCalendarDate = Color(0xffFEB3B3);
  static const Color yellowCalendarDate = Color(0xffFAEC81);

  static const Color darkGreenCalendarDate = Color(
    0xFF4CAF50,
  ); // Deeper green for good contrast in dark mode
  static const Color darkRedCalendarDate = Color(
    0xFFEF5350,
  ); // Rich red, still visible in dark mode
  static const Color darkYellowCalendarDate = Color(
    0xFFFFEB3B,
  ); // Bright yellow for visibility, not too harsh

  // Light Theme Colors
  static const Color lightGreen = Color(0xffE8FFE9);
  static const Color white = Color(0xffFFFFFF);

  /// Get the subtitle color based on the current theme.
  ///
  /// Returns the onTertiary color from the current theme's color scheme.
  static Color subtitleColor(BuildContext context) {
    return Theme.of(context).colorScheme.onTertiary;
  }
}
