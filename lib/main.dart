import 'package:flutter/material.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'providers/products.dart';
import 'providers/orders.dart';
import 'providers/auth.dart';

import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update: (context, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders.orders,
          ),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) {
          ifAuth(targetScreen) => auth.isAuth
              ? targetScreen
              : FutureBuilder(
                  future: auth.tryLogIn(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: SplashScreen(),
                            )
                          : AuthScreen(),
                );

          return MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: ifAuth(ProductsOverviewScreen()),
            routes: {
              EditProductScreen.routeName: (_) => ifAuth(EditProductScreen()),
              UserProductsScreen.routeName: (_) => ifAuth(UserProductsScreen()),
              OrderScreen.routeName: (_) => ifAuth(OrderScreen()),
              CartScreen.routeName: (_) => ifAuth(CartScreen()),
              ProductDetailScreen.routeName: (_) =>
                  ifAuth(ProductDetailScreen()),
            },
          );
        },
      ),
    );
  }
}
