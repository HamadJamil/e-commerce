import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ThemePreviewCard extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemePreviewCard({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.light.primary, width: 3)
              : Border.all(color: Colors.grey.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Light theme preview
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.light.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    // App bar simulation
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: theme.light.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ),
                    // Content simulation
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: theme.light.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 24,
                            height: 4,
                            color: theme.light.primary.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Dark theme preview
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.dark.background,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    // App bar simulation
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: theme.dark.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                    // Content simulation
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: theme.dark.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 24,
                            height: 4,
                            color: theme.dark.primary.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Theme name and emoji
            Container(
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? theme.light.primary : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(theme.emoji, style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
