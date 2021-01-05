import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: Consumer<Orders>(
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
