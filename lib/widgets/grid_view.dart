// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/Product.dart';
import '../widgets/product_item.dart';

class Gridview extends StatelessWidget {
  final bool isFavoriteSelected;

  const Gridview(this.isFavoriteSelected);

  @override
  Widget build(BuildContext context) {
    final data = !isFavoriteSelected
        ? Provider.of<Products>(context).items
        : Provider.of<Products>(context).favoriteItems;

    return data.isEmpty
        ? const Center(
            child: Text('No items added'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              return ChangeNotifierProvider.value(
                value: data[index],
                child: ProductItem(),
              );
            },
            itemCount: data.length,
          );
  }
}
