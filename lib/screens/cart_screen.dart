import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart' show CartItem;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    Widget label(String label) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          '$label',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final data = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                    label: Text(
                      '\u20B9 ${data.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(data: data),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          data.items.isEmpty
              ? label('Your cart is empty...')
              : label('Your items...'),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.productLength,
              itemBuilder: (ctx, index) => CartItem(
                data.items.values.toList().elementAt(index).id,
                data.items.keys.toList()[index],
                data.items.values.toList().elementAt(index).price,
                data.items.values.toList().elementAt(index).quantity,
                data.items.values.toList().elementAt(index).title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Cart data;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : (_isLoading ||
                widget.data.totalAmount <= 0 ||
                widget.data.items.isEmpty)
            ? const TextButton(
                onPressed: null,
                child: Text(
                  'ORDER NOW',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await Provider.of<Orders>(context, listen: false).addOrders(
                        widget.data.items.values.toList(),
                        widget.data.totalAmount);
                  } catch (error) {
                    print('Error Occured');
                  }
                  setState(() {
                    _isLoading = false;
                  });
                  widget.data.clear();
                },
                child: Text(
                  'ORDER NOW',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
  }
}
