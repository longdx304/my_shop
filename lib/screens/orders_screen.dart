import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() => _isLoading = true);
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((_) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Orders>(
              builder: (context, ordersData, child) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (context, index) => OrderItem(
                  ordersData.orders[index],
                ),
              ),
            ),
    );
  }
}
