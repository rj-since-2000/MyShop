import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
                fit: BoxFit.cover,
                placeholder:
                    AssetImage('assets/images/product-placeholder.jpg'),
                image: NetworkImage(product.imageUrl)),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: _isLoading ? 35 : 25,
              ),
              color: Theme.of(context).accentColor,
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await product.toggleFavoriteStatus(
                        authData.token,
                        authData.userId,
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: AddToCartButton(product),
        ),
      ),
    );
  }
}

class AddToCartButton extends StatefulWidget {
  final Product product;
  AddToCartButton(this.product);
  @override
  _AddToCartButtonState createState() => _AddToCartButtonState(product);
}

class _AddToCartButtonState extends State<AddToCartButton> {
  final Product product;
  _AddToCartButtonState(this.product);
  var _isAdding = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    if (cart.items.length == 0) Scaffold.of(context).hideCurrentSnackBar();
    return _isAdding
        ? CircularProgressIndicator()
        : IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () async {
              setState(() {
                _isAdding = true;
              });
              await cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              setState(() {
                _isAdding = false;
              });
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
            },
            color: Theme.of(context).accentColor,
          );
  }
}
