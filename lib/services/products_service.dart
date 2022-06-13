import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_products/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-multiple-2be25-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = true;
  Product? selectedProduct;

  ProductsService() {
    loadProducts();
  }

  loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
    return products;
  }

  saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }
    isSaving = false;
    notifyListeners();
  }

  createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id!}.json');
    final resp = await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    // TODO: Actualizar lista de productos
    return product.id!;
  }
}
