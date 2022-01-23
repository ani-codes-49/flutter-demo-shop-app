import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final icon = _isExpanded ? Icons.expand_less : Icons.expand_more;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 1),
      height: _isExpanded ? widget.orderItem.products.length * 20.0 + 115 : 95,
      curve: Curves.bounceIn,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(
                    '\u20B9 ${widget.orderItem.amount.toStringAsFixed(3)}'),
                subtitle: Text(DateFormat('dd/MM/YYYY hh:mm')
                    .format(widget.orderItem.dateTime)),
                trailing: IconButton(
                  icon: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInCirc,
                      child: Icon(icon)),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                height: _isExpanded
                    ? min(widget.orderItem.products.length * 20.0 + 30, 100)
                    : 0,
                child: ListView(
                  children: widget.orderItem.products
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'x${prod.quantity} \u20B9${prod.price}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
