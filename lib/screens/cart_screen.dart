import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cartItem, child) => Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '\$${cartItem.totalAmount}',
                        style: Theme.of(context).primaryTextTheme.headline6,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'ORDER NOW',
                      ),
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItem.items.length,
                itemBuilder: (context, index) => CartItem(
                  id: cartItem.items.values.toList()[index].id,
                  quantity: cartItem.items.values.toList()[index].quantity,
                  price: cartItem.items.values.toList()[index].price,
                  title: cartItem.items.values.toList()[index].title,
                  productId: cartItem.items.keys.toList()[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
