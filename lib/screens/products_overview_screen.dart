import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../providers/products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  //static const routeName = '/products-overview-screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // WON'T WORK!
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        Provider.of<Cart>(context).fetchAndSetCart();
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // Future<void> _refreshProducts(BuildContext context) async {
  //   await Provider.of<Products>(context).fetchAndSetProducts();
  //   await Provider.of<Cart>(context).fetchAndSetCart();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: _isLoading
          ? SplashScreen()
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text('MyShop'),
                  actions: <Widget>[
                    PopupMenuButton(
                      onSelected: (FilterOptions selectedValue) {
                        setState(() {
                          if (selectedValue == FilterOptions.Favorites) {
                            _showOnlyFavorites = true;
                          } else {
                            _showOnlyFavorites = false;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.more_vert,
                      ),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('Only Favorites'),
                          value: FilterOptions.Favorites,
                        ),
                        PopupMenuItem(
                          child: Text('Show All'),
                          value: FilterOptions.All,
                        ),
                      ],
                    ),
                    Consumer<Cart>(
                      builder: (_, cart, ch) => Badge(
                        child: ch,
                        value: cart.itemCount.toString(),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                      ),
                    ),
                  ],
                  floating: true,
                  //flexibleSpace: Placeholder(),
                  //expandedHeight: 60,
                ),
                ProductsGrid(_showOnlyFavorites),
              ],
            ),
    );
  }
}
