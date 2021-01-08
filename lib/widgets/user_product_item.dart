import 'package:flutter/material.dart';

import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;
  final Function deleteHandler;

  const UserProductItem(
      {this.deleteHandler, this.imageUrl, this.title, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: id,
              ),
            ),
            IconButton(
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
              onPressed: deleteHandler,
            ),
          ],
        ),
      ),
    );
  }
}
