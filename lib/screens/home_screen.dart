import 'package:flutter/material.dart';
import 'package:flutter_products/models/models.dart';
import 'package:flutter_products/screens/screens.dart';
import 'package:flutter_products/services/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String route = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    if (productService.isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              productService.selectedProduct =
                  productService.products[index].copy();
              Navigator.pushNamed(context, 'product');
            },
            child: ProductCard(product: productService.products[index])),
        itemCount: productService.products.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productService.selectedProduct =
              Product(available: false, price: 0, name: '');
          Navigator.pushNamed(context, ProductScreen.route);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// TODO: Separar
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBordersDecoration(),
        child: Stack(
          children: [
            _BackgroundImage(
              imageUrl: product.picture,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _ProductDetails(
                product: product,
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: _PriceTag(
                  price: product.price,
                )),
            // TODO: Mostrar de manera condicional
            if (!product.available)
              Positioned(
                  top: 0,
                  left: 0,
                  child: _NotAvailable(
                    isAvailable: product.available,
                  ))
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBordersDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 7), blurRadius: 12)
        ]);
  }
}

class _NotAvailable extends StatelessWidget {
  final bool isAvailable;

  const _NotAvailable({
    Key? key,
    required this.isAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            isAvailable ? 'Disponible' : 'No disponible',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      width: 100,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price;

  const _PriceTag({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$$price',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final String? imageUrl;

  const _BackgroundImage({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.png'),
          image: imageUrl == null
              ? AssetImage('assets/no-image.png') as ImageProvider
              : NetworkImage(imageUrl!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final Product product;

  const _ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.id != null ? product.id.toString() : '-',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}
