import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_products/providers/product_form_provider.dart';
import 'package:flutter_products/services/services.dart';
import 'package:flutter_products/themes/theme.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  static String route = 'product';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productsService.selectedProduct!),
      child: _ProductScreenBody(productsService: productsService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productsService,
  }) : super(key: key);

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                _ProductImage(
                  imageUrl: productsService.selectedProduct!.picture,
                ),
                Positioned(
                    top: 60,
                    left: 30,
                    child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30,
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 60,
                    right: 30,
                    child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Colors.white,
                        ))),
              ],
            ),
            _ProductForm(),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!productFormProvider.isValidForm()) {
            return;
          }
          await productsService
              .saveOrCreateProduct(productFormProvider.product);
        },
        child: Icon(Icons.save_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            child: FadeInImage(
              image: imageUrl == null
                  ? AssetImage('assets/no-image.png') as ImageProvider
                  : NetworkImage(imageUrl!),
              placeholder: AssetImage('assets/jar-loading.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5))
            ]),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 5))
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: productForm.formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: product.name,
                  onChanged: (value) => product.name = value,
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return 'El nombre es obligatorio';
                    }
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del Producto',
                    labelText: 'Nombre: ',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  initialValue: '${product.price}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      product.price = 0;
                    } else {
                      product.price = double.parse(value);
                    }
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintText: '\$150', labelText: 'Precio: '),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 30,
                ),
                SwitchListTile.adaptive(
                    value: product.available,
                    title: Text('Disponible'),
                    activeColor: Colors.deepPurple,
                    onChanged: productForm.updateAvailability),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
