import 'package:flutter/material.dart';
import 'package:flutter_products/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();

  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    this.product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(product.toJson());
    return formKey.currentState?.validate() ?? false;
  }
}
