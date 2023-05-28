import 'package:e_commerce/models/app_state.dart';
import 'package:e_commerce/pages/products_page.dart';
import 'package:e_commerce/redux/actions.dart';
import 'package:e_commerce/redux/reducers.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/pages/login_page.dart';
import 'package:e_commerce/pages/register_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Flutter E-Commerce',
        routes: {
          '/': (BuildContext context) => ProductsPage(onInit: () {
                StoreProvider.of<AppState>(context).dispatch(getUserAction);
                StoreProvider.of<AppState>(context).dispatch(getProductsAction);
              }),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage()
        },
        theme: ThemeData(
            // brightness: Brightness.dark,
            primaryColor: Colors.cyan[400],
            textTheme: TextTheme(
                // ignore: deprecated_member_use
                headline1:
                    TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                // ignore: deprecated_member_use
                subtitle1:
                    TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                // ignore: deprecated_member_use
                bodyText1: TextStyle(fontSize: 18.0)),
            colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
                .copyWith(secondary: Colors.deepOrange[200])),
      ),
    );
  }
}
