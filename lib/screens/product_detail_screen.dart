// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/Product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/ProductDetailsScreen';

  @override
  Widget build(BuildContext context) {
    final package = ModalRoute.of(context)!.settings.arguments as Product;

    final data =
        Provider.of<Products>(context, listen: false).findbyId(package.id);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(data.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(data.title),
              background: Hero(
                tag: data.id,
                child: Image.network(
                  data.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(
                height: 10,
              ),
              Text(
                'Price: \u20B9${data.price}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Text(
                  '${data.description}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 800,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
