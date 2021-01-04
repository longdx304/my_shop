import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Card(
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
              Consumer<Cart>(
                builder: (context, cartItem, child) => Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(
                    '\$${cartItem.totalAmount}',
                    style: Theme.of(context).primaryTextTheme.headline6,
                  ),
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
    );
  }
}
