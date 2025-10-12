import 'package:e_commerce/core/providers/theme_provider.dart';
import 'package:e_commerce/core/services/api_service.dart';
import 'package:e_commerce/shared/widgets/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySection extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategorySection({super.key, required this.onCategorySelected});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await context.read<ApiService>().getCategories();
      setState(() {
        _categories.addAll(
          categories.map((category) => category.name).toList(),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 12 : 4,
              right: index == _categories.length - 1 ? 16 : 4,
              top: 8,
              bottom: 8,
            ),
            child: ShimmerEffect(
              width: 80,
              height: 36,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 16 : 4,
              right: index == _categories.length - 1 ? 16 : 4,
              top: 8,
              bottom: 8,
            ),
            child: FilterChip(
              label: Text(
                category.replaceAll('-', ' ').toTitleCase(),
                style: TextStyle(color: isSelected ? Colors.white : null),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
                widget.onCategorySelected(category);
              },
              backgroundColor: context.read<ThemeProvider>().isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade200,
              selectedColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}

extension StringExtension on String {
  String toTitleCase() {
    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
}
