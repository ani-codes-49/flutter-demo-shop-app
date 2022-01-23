import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart' as oi;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  
  dynamic _future;

  Future _obtainFutures() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _future = _obtainFutures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context); this will cause the code to go into the infinite loop while usingg with the future builder widget

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: FutureBuilder(
          future: _future,
          //Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            switch (dataSnapshot.connectionState) {
              case ConnectionState.active:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return Consumer<Orders>(
                  builder: (_, orderData, child) {
                    return ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, index) => oi.OrderItem(
                        orderData.orders.elementAt(index),
                      ),
                    );
                  },
                );
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
