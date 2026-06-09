import 'package:exam/Reposistory/ProductDAO.dart';
import 'package:flutter/material.dart';
import 'package:exam/Entity/Product.dart';

class ProductListWidget extends StatelessWidget {
  ProductListWidget({super.key});
  var products = Product.products;
  @override
  Widget build(BuildContext context) {
    return ReponsiveProudct(products: products);
  }
}

class ReponsiveProudct extends StatelessWidget {
  List<Product> products;
  ReponsiveProudct({super.key, required this.products});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width < 450 ? 1 : 2,
      //children: [for (int i=0;i<products.length;i++)
      //  ProductWidget(product: products[i])],
      children: products
          .map((product) => ProductWidget(product: product))
          .toList(),
    );
  }
}

class OneColumnProduct extends StatelessWidget {
  List<Product> products;
  OneColumnProduct({super.key, required this.products});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i < 5; i++) ProductWidget(product: products[i]),
      ],
    );
  }
}

class ProductWidget extends StatefulWidget {
  Product product;
  ProductWidget({super.key, required this.product});

  @override
  State<ProductWidget> createState() => _ProductWidgetState(product: product);
}

class _ProductWidgetState extends State<ProductWidget> {
  Product product;
  _ProductWidgetState({required this.product});
  //int _count = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ProductContainer(product: product),
    );
  }
}

class ProductContainer extends StatefulWidget {
  Product product;
  ProductContainer({super.key, required this.product});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  int _selectSort = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth <= 450
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 2,
        height: 500,

        child: Column(
          children: [
            //
            DropdownButton<int>(
              value: _selectSort,
              items: [
                DropdownMenuItem(child: Text("A-Z"), value: 0),
                DropdownMenuItem(child: Text("Z-A"), value: 1),
                DropdownMenuItem(child: Text("Low to High"), value: 2),
                DropdownMenuItem(child: Text("High to Low"), value: 3),
              ],
              onChanged: (value) => setState(() {
                _selectSort = value!;
              }),
            ),
            //
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              children: [
                for (int i = 0; i < 10; i++)
                  ElevatedButton(child: Text("button 1"), onPressed: () {}),
              ],
            ),

            //Product Image
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                height: 300,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300,
                      child: Image.asset(
                        widget.product.image!,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: FloatingActionButton.extended(
                          onPressed: () {},
                          label: Text("Add to cart"),
                          icon: Icon(Icons.shopping_cart),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Product name, price, like
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Product Name: ${widget.product.name}"),
                        Text("Price: ${widget.product.price}\$"),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.plus_one,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(flex: 1, child: Text("456")),
                ],
              ),
            ),

            //List Icons
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 5; i++)
                  Icon(Icons.star, color: Colors.yellow),
              ],
            ),
            //Product Description
            Expanded(
              flex: 3,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Theo ghi nhận của phóng viên Dân trí, dự án được xây dựng trên một khu đất với nhiều hộ dân sinh sống bên trong, ở giữa khu đất là một khu nghĩa trang với hàng trăm ngôi mộ. Phần lớn diện tích khu vực này hiện vẫn còn bị bao phủ bởi đầm lầy, cỏ cây, bụi rậm, khá hoang sơ. Theo ghi nhận của phóng viên Dân trí, dự án được xây dựng trên một khu đất với nhiều hộ dân sinh sống bên trong, ở giữa khu đất là một khu nghĩa trang với hàng trăm ngôi mộ. Phần lớn diện tích khu vực này hiện vẫn còn bị bao phủ bởi đầm lầy, cỏ cây, bụi rậm, khá hoang sơ. Theo ghi nhận của phóng viên Dân trí, dự án được xây dựng trên một khu đất với nhiều hộ dân sinh sống bên trong, ở giữa khu đất là một khu nghĩa trang với hàng trăm ngôi mộ. Phần lớn diện tích khu vực này hiện vẫn còn bị bao phủ bởi đầm lầy, cỏ cây, bụi rậm, khá hoang sơ.Theo ghi nhận của phóng viên Dân trí, dự án được xây dựng trên một khu đất với nhiều hộ dân sinh sống bên trong, ở giữa khu đất là một khu nghĩa trang với hàng trăm ngôi mộ. Phần lớn diện tích khu vực này hiện vẫn còn bị bao phủ bởi đầm lầy, cỏ cây, bụi rậm, khá hoang sơ.",
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
