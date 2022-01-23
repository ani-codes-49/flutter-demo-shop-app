import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure ?'),
            content: const Text('do you want to remove the item from the cart ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('No'),
              ),
            ],
          ),
        );
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeProduct(productId);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text('\u20B9 $price'),
                ),
              ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text('${price.toStringAsFixed(2)}'),
          trailing: Text('x $quantity'),
        ),
      ),
    );
  }
}
