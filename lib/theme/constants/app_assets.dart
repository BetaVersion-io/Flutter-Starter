/// Comprehensive asset constants class for the betaversion app
/// This class centralizes all asset paths to make them easily manageable
class AppAssets {
  // Private constructor to prevent instantiation
  AppAssets._();

  // =============================================================================
  // LOGOS AND BRANDING
  // =============================================================================

  /// App logos in different formats and themes
  static const String darkLogo = "assets/logos/dark_logo.svg";
  static const String lightLogo = "assets/logos/light_logo.svg";
  static const String darkLogoPng = "assets/logos/dark_logo.png";
  static const String lightLogoPng = "assets/logos/light_logo.png";
  static const String darkSplash = "assets/logos/dark_splash.png";
  static const String lightSplash = "assets/logos/light_splash.png";
  static const String betaversionLogo = "assets/logos/betaversion.jpg";
  static const String crossesLogo = "assets/logos/crosses.png";
  static const String genericLogoImage = "assets/logos/image.png";

  // =============================================================================
  // ICONS
  // =============================================================================

  /// Icon assets in various formats
  // PNG Icons
  static const String learningAppIcon = "assets/icons/learning_app.png";
  static const String studentIcon = "assets/icons/student.png";

  // SVG Icons
  static const String learningAppIconSvg = "assets/icons/learning_app.svg";
  static const String studentIconSvg = "assets/icons/student.svg";
  static const String crossesIcon = "assets/icons/crosses.svg";
  static const String highScoreIcon = "assets/icons/high_score.svg";
  static const String minimizeIcon = "assets/icons/minimize.svg";
  static const String calendarIcon = "assets/icons/calendar.svg";
  static const String maleGenderIcon = "assets/icons/male_gender.svg";
  static const String femaleGenderIcon = "assets/icons/female_gender.svg";
  static const String crownIcon = "assets/icons/crown.svg";

  // =============================================================================
  // ONBOARDING IMAGES
  // =============================================================================

  /// Images used in register_onboarding screens
  static const String onboardingCrosses =
      "assets/images/onboarding/crosses.png";
  static const String onboardingBg =
      "assets/images/onboarding/onboarding_bg.png";
  static const String onboardingHandGesture =
      "assets/images/onboarding/hand_gesture.png";
  static const String onboardingGenericImage =
      "assets/images/onboarding/image.png";
  static const String onboardingPattern =
      "assets/images/onboarding/pattern.png";

  // Referenced but may not exist
  static const String onboardingNorcetPrep = "assets/images/norcet_prep.png";

  // =============================================================================
  // HOME SECTION IMAGES
  // =============================================================================

  /// Images used in home screens and sections
  // PNG Images
  static const String homeNewBadge = "assets/images/home/new.png";

  // SVG Images
  static const String homeFire = "assets/images/home/fire.svg";
  static const String homeMedal = "assets/images/home/medal.svg";
  static const String homeIntersect = "assets/images/home/Intersect.svg";
  static const String homeIllustration = "assets/images/home/illustration.svg";
  static const String homeCriteria = "assets/images/home/criteria.svg";
  static const String homeNestedSunCircles =
      "assets/images/home/nested_sun_circles.svg";
  static const String rankImage = "assets/images/onboarding/rank.png";
  static const String leaderBoardImage = "assets/images/onboarding/ranks.png";

  // =============================================================================
  // GENDER ICONS
  // =============================================================================

  /// Gender-specific icon assets
  static const String genderMale = "assets/images/gender/male_gender.svg";
  static const String genderFemale = "assets/images/gender/female_gender.svg";

  // =============================================================================
  // UTILITY IMAGES
  // =============================================================================

  /// Utility and miscellaneous images
  static const String utilityFlag = "assets/images/flag.svg";
  static const String utilityRibbon = "assets/images/home/ribbon.svg";

  // =============================================================================
  // ACHIEVEMENT ASSETS
  // =============================================================================

  /// Achievement and trophy related images
  static const String achievementTrophy = "assets/images/trophy.png";
  static const String achievementCommunity = "assets/images/community.png";

  // =============================================================================
  // PLACEHOLDER ASSETS
  // =============================================================================

  /// Placeholder and default assets (may need verification if they exist)
  static const String placeholderAvatar = "assets/avatar.jpg";
  static const String placeholderLogo = "assets/logo.png";
  static const String placeholderVideoThumb1 = "assets/video_thumb_1.jpg";
  static const String placeholderVideoThumb2 = "assets/video_thumb_2.jpg";
  static const String placeholderVideoThumb3 = "assets/video_thumb_3.jpg";
  static const String placeholderHimmatSingh = "assets/himmat_singh.jpg";

  // =============================================================================
  // FONTS
  // =============================================================================

  /// Font asset paths
  static const String fontPoppinsBold = "assets/fonts/Poppins-Bold.ttf";
  static const String fontPoppinsSemiBold = "assets/fonts/Poppins-SemiBold.ttf";
  static const String fontPoppinsMedium = "assets/fonts/Poppins-Medium.ttf";
  static const String fontPoppinsRegular = "assets/fonts/Poppins-Regular.ttf";

  // =============================================================================
  // BACKWARD COMPATIBILITY
  // =============================================================================

  /// Backward compatibility with existing AppImages class
  /// @deprecated Use AppAssets.darkLogo instead
  @Deprecated('Use AppAssets.darkLogo instead')
  static const String darkAppLogo = darkLogo;

  /// @deprecated Use AppAssets.lightLogo instead
  @Deprecated('Use AppAssets.lightLogo instead')
  static const String lightAppLogo = lightLogo;

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Get all logo paths
  static List<String> getAllLogos() {
    return [
      darkLogo,
      lightLogo,
      darkLogoPng,
      lightLogoPng,
      darkSplash,
      lightSplash,
      betaversionLogo,
      crossesLogo,
      genericLogoImage,
    ];
  }

  /// Get all icon paths
  static List<String> getAllIcons() {
    return [
      learningAppIcon,
      studentIcon,
      learningAppIconSvg,
      studentIconSvg,
      crossesIcon,
      highScoreIcon,
      minimizeIcon,
      calendarIcon,
      maleGenderIcon,
      femaleGenderIcon,
    ];
  }

  /// Get all register_onboarding image paths
  static List<String> getAllOnboardingImages() {
    return [
      onboardingCrosses,
      onboardingHandGesture,
      onboardingGenericImage,
      onboardingPattern,
      onboardingNorcetPrep,
    ];
  }

  /// Get all home section image paths
  static List<String> getAllHomeImages() {
    return [
      homeNewBadge,
      homeFire,
      homeMedal,
      homeIntersect,
      homeIllustration,
      homeCriteria,
      homeNestedSunCircles,
    ];
  }

  /// Get all font paths
  static List<String> getAllFonts() {
    return [
      fontPoppinsBold,
      fontPoppinsSemiBold,
      fontPoppinsMedium,
      fontPoppinsRegular,
    ];
  }

  /// Get all asset paths
  static List<String> getAllAssets() {
    return [
      ...getAllLogos(),
      ...getAllIcons(),
      ...getAllOnboardingImages(),
      ...getAllHomeImages(),
      genderMale,
      genderFemale,
      utilityFlag,
      utilityRibbon,
      achievementTrophy,
      achievementCommunity,
      placeholderAvatar,
      placeholderLogo,
      placeholderVideoThumb1,
      placeholderVideoThumb2,
      placeholderVideoThumb3,
      placeholderHimmatSingh,
      ...getAllFonts(),
    ];
  }

  /// Validate if an asset path exists in the defined constants
  static bool isValidAssetPath(String path) {
    return getAllAssets().contains(path);
  }

  /// Get asset path by name (useful for dynamic asset loading)
  static String? getAssetByName(String name) {
    final allAssets = getAllAssets();
    return allAssets
            .firstWhere((asset) => asset.contains(name), orElse: () => '')
            .isEmpty
        ? null
        : allAssets.firstWhere((asset) => asset.contains(name));
  }
}
