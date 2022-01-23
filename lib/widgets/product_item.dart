// ignore_for_file: use_key_in_widget_constructors, avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import '../screens/product_detail_screen.dart';
import '../providers/Product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    void showSnackBar(String text) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          elevation: 5,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              cart.removeSingleItem(product.id);
            },
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: product,
          );
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavoriteStatus(
                    auth.token,
                    auth.userId,
                  );
                },
                icon: product.isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
              ),
            ),
            trailing: Consumer<Cart>(
              builder: (_, value, __) => IconButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  showSnackBar('Item added to the cart... !');
                  value.addProduct(
                    product.id,
                    product.title,
                    product.price,
                  );
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
