import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      body: Container(
        //color: Colors.lightBlue[50],
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black54,
              actions: <Widget>[
                FavoriteButton(loadedProduct),
              ],
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Container(
                    width: 250,
                    height: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Center(
                            child: Text(
                          loadedProduct.title,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    )),
                centerTitle: true,
                background: Hero(
                  tag: productId,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      '\$${loadedProduct.price}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(child: Container(child: BuyButton(loadedProduct))),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedProduct.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final Product loadedProduct;
  FavoriteButton(this.loadedProduct);
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    return IconButton(
        tooltip: 'mark as favorite',
        padding: EdgeInsets.only(right: 10),
        enableFeedback: true,
        icon: Icon(
          widget.loadedProduct.isFavorite
              ? Icons.favorite
              : Icons.favorite_border,
          color: widget.loadedProduct.isFavorite ? Colors.red : Colors.red,
          semanticLabel: 'favorite',
          size: _isLoading ? 40 : 30,
        ),
        onPressed: _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: widget.loadedProduct.isFavorite
                        ? Text('Removed from favorites!')
                        : Text(' Marked as favorite!'),
                  ),
                );
                await widget.loadedProduct.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
                Scaffold.of(context).hideCurrentSnackBar();
                setState(() {
                  _isLoading = false;
                });
              });
  }
}

class BuyButton extends StatefulWidget {
  final Product loadedProduct;
  BuyButton(this.loadedProduct);

  @override
  _BuyButtonState createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  var _addingItem = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return RaisedButton(
      child: _addingItem
          ? Container(
              height: 25,
              width: 25,
              child: Center(
                child: CircularProgressIndicator(),
                //widthFactor: 2,
              ),
            )
          : Text(
              'BUY NOW',
              style: TextStyle(color: Colors.white),
            ),
      color: Theme.of(context).primaryColor,
      disabledColor: Colors.grey,
      onPressed: _addingItem
          ? null
          : () async {
              setState(() {
                _addingItem = true;
              });
              await cart.addItem(widget.loadedProduct.id,
                  widget.loadedProduct.price, widget.loadedProduct.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Item added to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'GO TO CART',
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
              );
              setState(() {
                _addingItem = false;
              });
            },
    );
  }
}
