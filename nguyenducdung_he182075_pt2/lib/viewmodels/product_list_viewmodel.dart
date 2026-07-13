import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

/// ViewModel cho màn hình danh sách sản phẩm.
/// 
/// Chịu trách nhiệm:
/// - Load danh sách sản phẩm từ Repository
/// - Xử lý logic tìm kiếm / lọc
/// - Thông báo cho View khi dữ liệu thay đổi (notifyListeners)
class ProductListViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  List<Product> _allProducts = [];
  List<Product> _displayProducts = [];
  String _searchQuery = '';
  bool _isLoading = false;

  ProductListViewModel({ProductRepository? repository})
      : _repository = repository ?? ProductRepository() {
    loadProducts();
  }

  // --- Getters (View chỉ đọc, không sửa trực tiếp) ---
  List<Product> get displayProducts => _displayProducts;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isEmpty => _displayProducts.isEmpty;

  /// Load toàn bộ sản phẩm từ repository.
  void loadProducts() {
    _isLoading = true;
    notifyListeners();

    _allProducts = _repository.getAllProducts();
    _displayProducts = List.from(_allProducts);

    _isLoading = false;
    notifyListeners();
  }

  /// Lọc sản phẩm theo tên dựa trên [query].
  void searchProducts(String query) {
    _searchQuery = query;
    _displayProducts = _repository.findProductsByName(query);
    notifyListeners();
  }

  /// Xoá bộ lọc tìm kiếm, hiển thị lại toàn bộ sản phẩm.
  void clearSearch() {
    _searchQuery = '';
    _displayProducts = List.from(_allProducts);
    notifyListeners();
  }
}
