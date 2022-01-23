import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_products.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product.dart';

class UserProducts extends StatelessWidget {
  static const String routeName = '/UserProducts';

  Future _refreshProducts(BuildContext context) async {
    // ignore: await_only_futures
    await Provider.of<Products>(context, listen: false).fetchandSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProducts.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              UserProduct(
                                productData.items.elementAt(index),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
