// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/grid_view.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/products_provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/ProductsOverviewScreen';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var isFavoriteSelected = false;
  var _initState = true;
  var _isLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero)
    //     .then((value) => Provider.of<Products>(context).getProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchandSetProducts(false).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _initState = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (val) {
              setState(() {
                if (val == FilterOptions.Favorites) {
                  isFavoriteSelected = true;
                } else {
                  isFavoriteSelected = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              const PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, value, __) => Badge(
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                },
              ),
              value: value.productLength.toString(),
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Gridview(isFavoriteSelected),
      drawer: AppDrawer(),
    );
  }
}
