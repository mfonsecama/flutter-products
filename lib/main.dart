import 'package:flutter/material.dart';
import 'package:flutter_products/screens/screens.dart';

void main() => runApp(const ProductsApp());

class ProductsApp extends StatelessWidget {
  const ProductsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Products App',
      initialRoute: HomeScreen.route,
      routes: {
        LoginScreen.route: (_) => LoginScreen(),
        HomeScreen.route: (_) => const HomeScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(elevation: 0, color: Colors.deepPurple),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0, backgroundColor: Colors.deepPurple)),
    );
  }
}
