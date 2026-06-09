import 'package:exam/Entity/Product.dart';
import 'package:exam/Reposistory/ProductDAO.dart';

class Productservice {
  List<Product>? products;
  Productservice() {
    ProductDAO productDAO = ProductDAO();
    products = productDAO!.getAllProduct();
  }
  List<Product> getAllProduct() {
    return products!;
  }
}
