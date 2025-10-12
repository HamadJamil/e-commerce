// lib/features/profile/profile_screen.dart (Updated Theme Section)
import 'package:e_commerce/core/providers/auth_provider.dart';
import 'package:e_commerce/features/favorites/favorites_screen.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:e_commerce/shared/widgets/theme_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/theme/text_style_helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserInfo(),
            SizedBox(height: 24),
            _buildThemeSection(context),
            SizedBox(height: 16),
            _buildPreferencesSection(context),
            SizedBox(height: 16),
            _buildLegalSection(context),
            SizedBox(height: 16),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.currentUser?.displayName ?? 'Guest',
                        style: TextStyleHelper.titleLarge(
                          context,
                        )?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: authProvider.isEmailVerified
                              ? Colors.green.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          authProvider.isEmailVerified
                              ? 'Verified Account'
                              : 'Email Not Verified',
                          style: TextStyleHelper.bodySmall(context)?.copyWith(
                            color: authProvider.isEmailVerified
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: TextStyleHelper.titleLarge(
                context,
              )?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildThemeSelector(),
            SizedBox(height: 16),
            _buildDarkModeToggle(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: TextStyleHelper.titleMedium(
                context,
              )?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ThemeManager.allThemes.map((theme) {
                  final themeKey = ThemeManager
                      .themeKeys[ThemeManager.allThemes.indexOf(theme)];
                  final isSelected = themeProvider.currentThemeKey == themeKey;

                  return Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: ThemePreviewCard(
                      theme: theme,
                      isSelected: isSelected,
                      onTap: () => themeProvider.setTheme(themeKey),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 8),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                final currentTheme = themeProvider.currentTheme;
                return Text(
                  'Current: ${currentTheme.name} ${currentTheme.emoji}',
                  style: TextStyleHelper.bodyMedium(context)?.copyWith(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : Colors.blueGrey,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDarkModeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Dark Mode', style: TextStyleHelper.bodyLarge(context)),
            subtitle: Text(
              themeProvider.isDarkMode ? 'Enabled' : 'Disabled',
              style: TextStyleHelper.bodySmall(context)?.copyWith(
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.blueGrey,
              ),
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleDarkMode(),
            ),
            onTap: () => themeProvider.toggleDarkMode(),
          ),
        );
      },
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red),
            title: Text('Favorites', style: TextStyleHelper.bodyLarge(context)),
            subtitle: Text(
              'Your saved products',
              style: TextStyleHelper.bodySmall(
                context,
              )?.copyWith(color: Colors.grey),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.orange),
            title: Text(
              'Notifications',
              style: TextStyleHelper.bodyLarge(context),
            ),
            subtitle: Text(
              'Push notifications',
              style: TextStyleHelper.bodySmall(
                context,
              )?.copyWith(color: Colors.grey),
            ),
            trailing: Switch(value: true, onChanged: (value) {}),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.security),
            title: Text(
              'Privacy Policy',
              style: TextStyleHelper.bodyLarge(context),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              SnackbarHelper.info(
                context: context,
                title: 'Privacy Policy',
                message: 'Coming soon',
              );
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.description),
            title: Text(
              'Terms & Conditions',
              style: TextStyleHelper.bodyLarge(context),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              SnackbarHelper.info(
                context: context,
                title: 'Terms & Conditions',
                message: 'Coming soon',
              );
            },
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(
              'Help & Support',
              style: TextStyleHelper.bodyLarge(context),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              SnackbarHelper.info(
                context: context,
                title: 'Help & Support',
                message: 'Coming soon',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.currentUser == null) {
          return SizedBox(); // Don't show logout button if not logged in
        }

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final shouldLogout = await _showLogoutConfirmation(context);
              if (shouldLogout ?? false) {
                await authProvider.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: Text(
              'Log Out',
              style: TextStyleHelper.labelLarge(
                context,
              )?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
