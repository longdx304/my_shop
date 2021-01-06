import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TO ADD NEW PRODUCT
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<Products>(
        builder: (context, productsData, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (context, index) => Column(
              children: [
                UserProductItem(
                  imageUrl: productsData.items[index].imageUrl,
                  title: productsData.items[index].title,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}