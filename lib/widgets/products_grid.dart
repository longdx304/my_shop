import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import 'product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  Future _productsFuture;
  Future _obtainProductsFuture() {
    return Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        widget.showFavs ? productsData.favoriteItems : productsData.items;

    return FutureBuilder(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('An error occured when loading products!'),
          );
        } else {
          return GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ),
          );
        }
      },
    );
  }
}
