import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

import 'edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future _productsFuture;
  Future _obtainProductsFuture() {
    return Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasError)
            return Center(
              child: Text('An error occured while loading products'),
            );
          return Consumer<Products>(
            builder: (context, productsData, child) => RefreshIndicator(
              onRefresh: () => productsData.fetchAndSetProducts(true),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      UserProductItem(
                        id: productsData.items[index].id,
                        imageUrl: productsData.items[index].imageUrl,
                        title: productsData.items[index].title,
                        deleteHandler: () async {
                          try {
                            await productsData
                                .deleteProduct(productsData.items[index].id);
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              'Deleting failed!',
                              textAlign: TextAlign.center,
                            )));
                          }
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
