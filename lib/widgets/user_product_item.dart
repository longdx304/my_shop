import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  const UserProductItem({this.imageUrl, this.title});

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
              onPressed: () {
                // TO IMPLEMENT EDIT PRODUCT
              },
            ),
            IconButton(
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
              onPressed: () {
                // TO IMPLEMENT EDIT PRODUCT
              },
            ),
          ],
        ),
      ),
    );
  }
}
