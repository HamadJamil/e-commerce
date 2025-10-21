import 'package:e_commerce/core/providers/product_provider.dart';
import 'package:e_commerce/core/providers/theme_provider.dart';
import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:e_commerce/shared/widgets/shimmer_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../shared/widgets/product_card.dart';
import 'category_section.dart';
import '../search/product_search_delegate.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late ScrollController _scrollController;
  String _selectedCategory = 'All';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts(refresh: true);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    if (!context.read<ProductProvider>().isLoading &&
        context.read<ProductProvider>().hasMore) {
      context.read<ProductProvider>().loadProducts();
    }
  }

  Future<void> _refreshData() async {
    await context.read<ProductProvider>().loadProducts(
      refresh: true,
      category: _selectedCategory,
    );
  }

  void _onCategorySelected(String category) {
    final qCategory = category.split(' ').join('-');
    setState(() => _selectedCategory = qCategory);
    if (category == 'All') {
      context.read<ProductProvider>().loadProducts(refresh: true);
    } else {
      context.read<ProductProvider>().loadProducts(
        refresh: true,
        category: qCategory,
      );
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<ProductProvider>().loadProducts(
        refresh: true,
        category: _selectedCategory,
      );
    } else {
      context.read<ProductProvider>().searchProducts(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: LottieBuilder.asset(
                        'assets/logo.json',
                        repeat: false,
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Opal Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
                floating: true,
                snap: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: ProductSearchDelegate(),
                      );
                    },
                  ),

                  
                  IconButton(
                    icon: Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),

              
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    placeholder: 'Search products...',
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),

              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text(
                    'Categories',
                    style: TextStyleHelper.titleLarge(
                      context,
                    )?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: CategorySection(onCategorySelected: _onCategorySelected),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'Products',
                    style: TextStyleHelper.titleLarge(
                      context,
                    )?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              _buildProductsGrid(),

              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (!productProvider.hasMore) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'No more products',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
          Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.isLoading &&
                  productProvider.products.isNotEmpty) {
                return Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: LoadingAnimationWidget.beat(
                      color: context.read<ThemeProvider>().isDarkMode
                          ? Colors.white
                          : Colors.black,
                      size: 32,
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading && productProvider.products.isEmpty) {
          return SliverPadding(
            padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
            sliver: SliverToBoxAdapter(child: ProductShimmerGrid(itemCount: 4)),
          );
        }

        if (productProvider.error.isNotEmpty &&
            productProvider.products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 8),
                    Text(
                      productProvider.error,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          productProvider.loadProducts(refresh: true),
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (productProvider.products.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    "assets/logo.json",
                    repeat: false,
                    height: 132,
                    width: 132,
                  ),
                  Text(
                    'No products found',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try searching for something else',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.61,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index < productProvider.products.length) {
                final product = productProvider.products[index];
                return ProductCard(product: product);
              }
              return SizedBox.shrink();
            }, childCount: productProvider.products.length),
          ),
        );
      },
    );
  }
}
