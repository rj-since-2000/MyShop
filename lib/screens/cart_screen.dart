import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
import '../screens/orders_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _phoneNoFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var isLoading = false;
  String deliveryAdd = '';
  String phoneNo = '';
  var dAdd;
  var phNo;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     _refreshProducts(context);
  //   });
  //   super.initState();
  // }

  @override
  void dispose() {
    _phoneNoFocusNode.dispose();
    super.dispose();
  }

  //Future<void> _refreshProducts(BuildContext context) async {
  //  setState(() {
  //    isLoading = true;
  //  });
  //  await Provider.of<Cart>(context, listen: false).fetchAndSetCart();
  //  setState(() {
  //    isLoading = false;
  //  });
  //}

  void _saveDeliveryDetails(BuildContext context) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    deliveryAdd = dAdd;
    phoneNo = phNo;
    Navigator.of(context).pop();
    setState(() {});
  }

  void _editDeliveryDetails(BuildContext context, int n) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: 500,
            padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 15), //MediaQuery.of(context).viewInsets.bottom + 10),
            child: Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    autofocus: n == 0 ? true : false,
                    initialValue: deliveryAdd,
                    decoration: InputDecoration(labelText: 'Address'),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_phoneNoFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please add an address to deliver.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      dAdd = value;
                    },
                  ),
                  TextFormField(
                    autofocus: n == 1 ? true : false,
                    initialValue: phoneNo,
                    decoration: InputDecoration(labelText: 'Phone no.'),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) {
                      _saveDeliveryDetails(context);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please add a contact.';
                      }
                      if (value.length != 10) {
                        return 'Please enter a valid contact!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phNo = value;
                    },
                  ),
                  FlatButton(
                      splashColor: Theme.of(context).primaryColor,
                      onPressed: () => _saveDeliveryDetails(context),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);
    // cart.fetchAndSetCart();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: FutureBuilder(
          future: Provider.of<Cart>(context, listen: false).fetchAndSetCart(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Center(
                child: Text('AN ERROR OCCURED !'),
              );
            } else
              return Consumer<Cart>(
                builder: (ctx, cart, _) => Container(
                  color: Colors.red[50],
                  child: Column(
                    children: <Widget>[
                      Card(
                        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total',
                                style: TextStyle(fontSize: 20),
                              ),
                              Spacer(),
                              Chip(
                                label: Text(
                                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .title
                                        .color,
                                  ),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              isLoading
                                  ? FlatButton(
                                      onPressed: null,
                                      child: Text('ORDER NOW'),
                                    )
                                  : OrderButton(
                                      cart: cart,
                                      address: deliveryAdd,
                                      number: phoneNo)
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.all(15),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Delivery Address:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(width: 2),
                                  IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () =>
                                          _editDeliveryDetails(context, 0))
                                ],
                              ),
                              Text(
                                deliveryAdd,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Phone Number:    ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(width: 2),
                                  IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onPressed: () =>
                                          _editDeliveryDetails(context, 1)),
                                  SizedBox(width: 2),
                                  Text(
                                    phoneNo,
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (cart.items.length > 0)
                        Container(
                          child: Center(
                            child: Text(
                              'Swipe left an item to dismiss!',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          //padding: EdgeInsets.all(2),
                        ),
                      cart.items.length > 0
                          ? SizedBox(height: 10)
                          : SizedBox(height: 200),
                      cart.items.length > 0
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: cart.items.length,
                                itemBuilder: (ctx, i) => CartItem(
                                  cart.items.values.toList()[i].id,
                                  cart.items.keys.toList()[i],
                                  cart.items.values.toList()[i].price,
                                  cart.items.values.toList()[i].quantity,
                                  cart.items.values.toList()[i].title,
                                ),
                              ),
                            )
                          : Center(
                              child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.shopping_cart,
                                  size: 100,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Your Cart is empty!',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
              );
          }),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton(
      {Key key,
      @required this.cart,
      @required this.address,
      @required this.number})
      : super(key: key);

  final Cart cart;
  final address;
  final number;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : (widget.address == '' || widget.number == '')
              ? () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Can\'t place Order!'),
                      content: Text(
                        'Please enter your delivery details.',
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  )
              : () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalAmount,
                    widget.address,
                    widget.number,
                  );
                  await widget.cart.clear();
                  setState(() {
                    _isLoading = false;
                  });
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Order Placed Successfully!',
                      ),
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                        label: 'Go to Orders',
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(OrdersScreen.routeName);
                        },
                      ),
                    ),
                  );
                },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
