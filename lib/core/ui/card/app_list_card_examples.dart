import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:betaversion/core/ui/card/app_list_card.dart';

/// This file contains usage examples for AppListCard and its variants.
/// These examples demonstrate the various configuration options available.
///
/// DO NOT import this file in production code - it's for reference only.

class AppListCardExamples extends StatelessWidget {
  const AppListCardExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppListCard Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Example 1: Basic card with title only
          const Text(
            '1. Basic Card - Title Only',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(title: 'Simple Title'),
          const SizedBox(height: 24),

          // Example 2: Card with title and subtitle
          const Text(
            '2. Card with Subtitle',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(
            title: 'Main Title',
            subtitle: 'This is a subtitle with additional information',
          ),
          const SizedBox(height: 24),

          // Example 3: Card with icon
          const Text(
            '3. Card with Icon',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(
            title: 'Settings',
            subtitle: 'Configure your preferences',
            leadingIcon: Iconsax.setting_2,
          ),
          const SizedBox(height: 24),

          // Example 4: Card with icon and trailing widget
          const Text(
            '4. Card with Icon and Trailing',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(
            title: 'Notifications',
            subtitle: 'Manage notification settings',
            leadingIcon: Iconsax.notification,
            trailing: Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 24),

          // Example 5: Card with icon container
          const Text(
            '5. Card with Icon Container',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListCard(
            title: 'Profile',
            subtitle: 'View and edit profile',
            leadingIcon: Iconsax.user,
            showIconContainer: true,
            iconColor: Colors.blue,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 6: Card with custom colors
          const Text(
            '6. Card with Custom Colors',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListCard(
            title: 'Downloads',
            subtitle: 'View your downloads',
            leadingIcon: Iconsax.document_download,
            showIconContainer: true,
            iconColor: Colors.green,
            iconContainerColor: Colors.green.withAlpha(26),
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 7: Card without elevation
          const Text(
            '7. Card without Elevation (Flat)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(
            title: 'Flat Card',
            subtitle: 'No shadow elevation',
            leadingIcon: Iconsax.layer,
            elevation: 0,
          ),
          const SizedBox(height: 24),

          // Example 8: Card with border
          const Text(
            '8. Card with Border',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListCard(
            title: 'Bordered Card',
            subtitle: 'Card with border instead of shadow',
            leadingIcon: Iconsax.frame,
            elevation: 0,
            borderColor: Colors.blue.withAlpha(77),
            borderWidth: 1.5,
          ),
          const SizedBox(height: 24),

          // Example 9: Card with custom padding
          const Text(
            '9. Card with Custom Padding',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(
            title: 'Large Padding',
            subtitle: 'More spacious card',
            leadingIcon: Iconsax.maximize_4,
            padding: EdgeInsets.all(20),
          ),
          const SizedBox(height: 24),

          // Example 10: Card with custom background
          const Text(
            '10. Card with Custom Background',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListCard(
            title: 'Colored Background',
            subtitle: 'Card with custom color',
            leadingIcon: Iconsax.colorfilter,
            backgroundColor: Colors.blue.withAlpha(13),
            showIconContainer: true,
            iconColor: Colors.blue,
          ),
          const SizedBox(height: 24),

          // Example 11: AppSettingCard variant
          const Text(
            '11. AppSettingCard Variant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppSettingCard(
            title: 'Account Settings',
            subtitle: 'Manage your account',
            icon: Iconsax.user_octagon,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 12: AppSettingCard without chevron
          const Text(
            '12. AppSettingCard without Chevron',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppSettingCard(
            title: 'Privacy',
            subtitle: 'Privacy settings',
            icon: Iconsax.shield_tick,
            showChevron: false,
            trailing: Switch(value: true, onChanged: (v) {}),
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 13: AppListItem variant (for bottom sheets)
          const Text(
            '13. AppListItem Variant (No Elevation)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListItem(
            title: 'Share',
            subtitle: 'Share with friends',
            icon: Iconsax.share,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 14: AppActionCard variant
          const Text(
            '14. AppActionCard Variant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppActionCard(
            title: 'Quick Access',
            subtitle: 'Frequently used feature',
            icon: Iconsax.flash_1,
            accentColor: Colors.orange,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 15: AppBorderedCard variant
          const Text(
            '15. AppBorderedCard Variant',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppBorderedCard(
            title: 'Option A',
            subtitle: 'Select this option',
            icon: Iconsax.tick_circle,
            onTap: () {},
          ),
          const SizedBox(height: 12),

          // Example 16: AppBorderedCard selected state
          const Text(
            '16. AppBorderedCard (Selected)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppBorderedCard(
            title: 'Option B',
            subtitle: 'Currently selected',
            icon: Iconsax.tick_circle,
            isSelected: true,
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 17: Card with custom leading widget
          const Text(
            '17. Card with Custom Leading Widget',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListCard(
            title: 'Custom Leading',
            subtitle: 'With a custom widget',
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.star, color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 24),

          // Example 18: Card with custom trailing widget
          const Text(
            '18. Card with Badge Trailing',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListCard(
            title: 'Messages',
            subtitle: 'Unread messages',
            leadingIcon: Iconsax.message,
            showIconContainer: true,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '5',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Example 19: Card with different border radius
          const Text(
            '19. Card with Custom Border Radius',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(
            title: 'Rounded Card',
            subtitle: 'Extra rounded corners',
            leadingIcon: Iconsax.record_circle,
            borderRadius: 20,
          ),
          const SizedBox(height: 24),

          // Example 20: Minimal card (no icon, no trailing)
          const Text(
            '20. Minimal Card',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          AppListCard(
            title: 'Simple Item',
            subtitle: 'Minimal design',
            onTap: () {},
          ),
          const SizedBox(height: 24),

          // Example 21: Card with top alignment
          const Text(
            '21. Card with Top Alignment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppListCard(
            title: 'Top Aligned',
            subtitle:
                'This is a longer subtitle that wraps to multiple lines to demonstrate the top alignment of the icon',
            leadingIcon: Iconsax.align_vertically,
            showIconContainer: true,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          const SizedBox(height: 24),

          // Example 22: Compact list items for bottom sheets
          const Text(
            '22. Compact List Items (Bottom Sheet Style)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                AppListItem(title: 'Copy', icon: Iconsax.copy, onTap: () {}),
                AppListItem(title: 'Share', icon: Iconsax.share, onTap: () {}),
                AppListItem(title: 'Delete', icon: Iconsax.trash, onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
