import 'package:exam/Entity/Product.dart';
import 'package:exam/Reposistory/ProductRepository.dart';

/// Presenter / ViewModel — kết nối Repository với UI.
class ProductListPresenter {
  final ProductRepository _repository;

  ProductListPresenter({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  List<Product> loadProducts() {
    return _repository.getAllProducts();
  }

  Product? getProductById(String id) {
    return _repository.getProductById(id);
  }
}
