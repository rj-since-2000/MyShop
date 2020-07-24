//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? widget.order.products.length * 26.0 + 195 : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: _expanded ? widget.order.products.length * 26.0 + 100 : 0,
              child: SingleChildScrollView(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Order Details',
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      height: widget.order.products.length * 26.0,
                      child: ListView(
                        children: widget.order.products
                            .map(
                              (prod) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      prod.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${prod.quantity}x \$${prod.price}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Center(child: SizedBox(height: 10)),
                    Text(
                      'Order will be delivered to - ${widget.order.number}',
                      textAlign: TextAlign.start,
                    ),
                    Text('Delivery address - ${widget.order.address}'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
