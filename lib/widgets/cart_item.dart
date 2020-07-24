import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var _isLoading = false;
  var _isChanging = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Dismissible(
            key: ValueKey(widget.id),
            background: Container(
              color: Theme.of(context).errorColor,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 40,
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text(
                    'Do you want to remove the item from the cart?',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Cart>(context, listen: false)
                  .removeItem(widget.productId);
              setState(() {
                _isLoading = false;
              });
            },
            child: Card(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: widget.productId,
                  ),
                  child: ListTile(
                      leading: CircleAvatar(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text('\$${widget.price}'),
                          ),
                        ),
                      ),
                      title: Text(widget.title),
                      subtitle:
                          Text('Total: \$${(widget.price * widget.quantity)}'),
                      trailing: Container(
                        //width: 100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  elevation: 5,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: _isChanging
                                          ? Colors.blueGrey
                                          : Theme.of(context).accentColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '-',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: _isChanging
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isChanging = true;
                                        });
                                        await Provider.of<Cart>(context)
                                            .removeSingleItem(widget.productId);
                                        setState(() {
                                          _isChanging = false;
                                        });
                                      }),
                            Consumer<Cart>(
                              builder: (BuildContext context, Cart value,
                                      Widget child) =>
                                  Container(
                                width: 40,
                                height: 40,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                ),
                                child: Center(
                                  child: _isChanging
                                      ? CircularProgressIndicator()
                                      : Text(
                                          '${value.items[widget.productId].quantity} x'),
                                ),
                              ),
                            ),
                            InkWell(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  elevation: 5,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: _isChanging
                                          ? Colors.blueGrey
                                          : Theme.of(context).accentColor,
                                      //border: Border.all(width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: _isChanging
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isChanging = true;
                                        });
                                        await Provider.of<Cart>(context)
                                            .addItem(widget.productId,
                                                widget.price, widget.title);
                                        setState(() {
                                          _isChanging = false;
                                        });
                                      }),
                          ],
                        ),
                      )
                      //Text('${widget.quantity} x'),
                      ),
                ),
              ),
            ),
          );
  }
}
