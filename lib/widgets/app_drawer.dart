import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/orders_screen.dart';

import '../screens/user_products.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello User... !'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.payment,
            ),
            title: const Text('Your Orders'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                CustomRoute(
                  builder: (ctx) => OrdersScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            title: const Text('Shop Items'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProducts.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
              scaffold.showSnackBar(const SnackBar(
                content: Text(
                  'Logged out successfully !',
                  textAlign: TextAlign.center,
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}
