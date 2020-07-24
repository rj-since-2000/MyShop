import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import '../screens/products_overview_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../screens/appinfo_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            
            Container(
              color: Theme.of(context).primaryColor,
              height: 200,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 32),
                  Container(height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(70),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset('assets/images/user.jpg'),
                    ),
                  ),
                  Container(
                    child:
                        Text(Provider.of<Auth>(context, listen: false).email,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20,color: Colors.white),),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                  )
                ],
              ),
            ),
           // AppBar(
           //   title: Text(Provider.of<Auth>(context, listen: false).email),
           //   automaticallyImplyLeading: false,
           // ),
           Divider(),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Your Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage your Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('App Info'),
              onTap: () {
                Navigator.of(context).pushNamed(AppInfoScreen.routeName);
              },
            ),
            Divider(),
            Spacer(),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                //Navigator.of(context).pop();
                //print('popped');
                Provider.of<Auth>(context, listen: false).logout();
                //print('logout');
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
