import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const AdaptiveNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return _buildCupertinoTabBar(context);
    } else {
      return _buildMaterialNavBar(context);
    }
  }

  Widget _buildMaterialNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        showUnselectedLabels: true,
        elevation: 8,
      ),
    );
  }

  Widget _buildCupertinoTabBar(BuildContext context) {
    return CupertinoTabBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items.map((item) {
        return BottomNavigationBarItem(icon: item.icon, label: item.label);
      }).toList(),
      backgroundColor: CupertinoColors.systemBackground,
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.systemGrey,
      border: Border(
        top: BorderSide(
          color: CupertinoColors.systemGrey4,
          width: 0.0, // 0.0 means one physical pixel
        ),
      ),
    );
  }
}
