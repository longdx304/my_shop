import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

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
        builder: (context, cartData, child) => Column(
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
                        '\$${cartData.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).primaryTextTheme.headline6,
                      ),
                    ),
                    OrderButton(
                      cartData: cartData,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartData.items.length,
                itemBuilder: (context, index) => CartItem(
                  id: cartData.items.values.toList()[index].id,
                  quantity: cartData.items.values.toList()[index].quantity,
                  price: cartData.items.values.toList()[index].price,
                  title: cartData.items.values.toList()[index].title,
                  productId: cartData.items.keys.toList()[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cartData;
  const OrderButton({Key key, this.cartData}) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cartData.items.length > 0 || _isLoading == true
          ? () async {
              setState(() => _isLoading = true);
              await Provider.of<Orders>(context, listen: false).addOrder(
                cartProducts: widget.cartData.items.values.toList(),
                total: widget.cartData.totalAmount,
              );
              setState(() => _isLoading = false);
              widget.cartData.clear();
            }
          : null,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
            ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
