import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_products.dart';
import '../providers/Product.dart';
import '../providers/products_provider.dart';

class UserProduct extends StatelessWidget {
  final Product product;

  const UserProduct(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddProducts.routeName,
                  arguments: product,
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(product.id);
                      scaffold.showSnackBar(const SnackBar(
                    content: Text(
                      'Item deleted successfully !',
                      textAlign: TextAlign.center,
                    ),
                  ));
                } catch (error) {
                  scaffold.showSnackBar(const SnackBar(
                    content: Text(
                      'Can\'t delete an item',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
