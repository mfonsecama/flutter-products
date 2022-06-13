import 'package:flutter/material.dart';
import 'package:flutter_products/screens/screens.dart';
import 'package:flutter_products/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProductsService())],
      child: const ProductsApp(),
    );
  }
}

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
        ProductScreen.route: (_) => const ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(elevation: 0, color: Colors.deepPurple),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0, backgroundColor: Colors.deepPurple)),
    );
  }
}
