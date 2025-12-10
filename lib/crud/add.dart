import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// main URL for REST pages (same as product.dart)
const String _baseURL = 'medbuddypill.atwebpages.com';

class AddProduct {
  // Function to add a new product
  static Future<bool> addProduct({
    required String name,
    required int quantity,
    required double price,
    required int categoryId,
  }) async {
    try {
      final url = Uri.http(_baseURL, 'add.php', {
        'name': name,
        'quantity': '$quantity',
        'price': '$price',
        'cid': '$categoryId',
      });

      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error adding product: $e');
      return false;
    }
  }

  // Show dialog to add a new product
  static void showAddProductDialog(
    BuildContext context,
    VoidCallback onAdded,
  ) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category ID',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Validate inputs
                if (nameController.text.isEmpty ||
                    quantityController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    categoryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                // Close the dialog
                Navigator.of(context).pop();

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                // Add the product
                final success = await addProduct(
                  name: nameController.text,
                  quantity: int.parse(quantityController.text),
                  price: double.parse(priceController.text),
                  categoryId: int.parse(categoryController.text),
                );

                // Close loading dialog
                Navigator.of(context).pop();

                if (success) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product added successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Call the callback to refresh the list
                  onAdded();
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to add product'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Add button widget (+ icon)
  static Widget addButton({
    required BuildContext context,
    required VoidCallback onAdded,
  }) {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.green),
      onPressed: () {
        showAddProductDialog(context, onAdded);
      },
    );
  }
}
