// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_list_viewmodel.dart';
import '../views/product_detail_screen.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

/// View: Màn hình danh sách sản phẩm với giao diện xanh dương.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _selectedIndex = 1; // Product List tab mặc định

  static const Color _primaryBlue = Color(0xFF1A73E8);
  static const Color _lightBlue = Color(0xFF4A90E2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryBlue, _lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          _SearchBar(),
          // Danh sách sản phẩm
          const Expanded(child: _ProductList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: _primaryBlue,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Product Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget con: Thanh tìm kiếm
// ---------------------------------------------------------------------------
class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProductListViewModel>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: TextField(
        controller: _controller,
        onChanged: (query) {
          vm.searchProducts(query);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400], size: 18),
                  onPressed: () {
                    _controller.clear();
                    vm.clearSearch();
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF2F5FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget con: Danh sách sản phẩm (responsive grid/list)
// ---------------------------------------------------------------------------
class _ProductList extends StatelessWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1A73E8)),
          );
        }

        if (vm.isEmpty) {
          return _buildEmptyState();
        }

        // Dùng OrientationBuilder + LayoutBuilder để tính số cột
        return OrientationBuilder(
          builder: (context, orientation) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final bool isLandscape =
                    orientation == Orientation.landscape;

                // Xác định số cột và kiểu layout
                // width <= 500 + dọc  → 1 cột ngang (horizontal list)
                // width <= 500 + ngang → 2 cột dọc (grid)
                // width >= 500 + dọc  → 2 cột dọc (grid)
                // width >= 500 + ngang → 3 cột dọc (grid)
                final bool isSmall = width <= 500;
                final bool useHorizontalList = isSmall && !isLandscape;

                int crossAxisCount;
                if (useHorizontalList) {
                  crossAxisCount = 1; // sẽ dùng ListView ngang
                } else if (isSmall && isLandscape) {
                  crossAxisCount = 2;
                } else if (!isSmall && !isLandscape) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 3;
                }

                if (useHorizontalList) {
                  // 1 cột – horizontal card list
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    itemCount: vm.displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = vm.displayProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: 110,
                          child: ProductCard(
                            product: product,
                            isHorizontal: true,
                            onTap: () => _navigateToDetail(context, product),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Grid layout: 2 hoặc 3 cột dọc
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: vm.displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = vm.displayProducts[index];
                      return ProductCard(
                        product: product,
                        isHorizontal: false,
                        onTap: () => _navigateToDetail(context, product),
                      );
                    },
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 12),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
