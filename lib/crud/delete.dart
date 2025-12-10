import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// main URL for REST pages (same as product.dart)
const String _baseURL = 'medbuddypill.atwebpages.com';

class DeleteProduct {
  // Function to delete a product by pid
  static Future<bool> deleteProduct(int pid) async {
    try {
      final url = Uri.https(_baseURL, 'Delete.php', {'pid': '$pid'});

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Widget to show delete confirmation dialog
  static Future<bool?> showDeleteDialog(
      BuildContext context, String productName) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete "$productName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Delete button widget (X button)
  static Widget deleteButton({
    required BuildContext context,
    required int productId,
    required String productName,
    required VoidCallback onDeleted,
  }) {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.red),
      onPressed: () async {
        // Show confirmation dialog
        final confirmed = await showDeleteDialog(context, productName);

        if (confirmed == true) {
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

          // Delete the product
          final success = await deleteProduct(productId);

          // Close loading dialog
          Navigator.of(context).pop();

          if (success) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Call the callback to refresh the list
            onDeleted();
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to delete product'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }

  // Show dialog to enter PID and delete
  static void showDeleteByPidDialog(
    BuildContext context,
    VoidCallback onDeleted,
  ) {
    final pidController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: TextField(
            controller: pidController,
            decoration: const InputDecoration(
              labelText: 'Enter Product ID (PID)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Validate input
                if (pidController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a Product ID'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                final pid = int.tryParse(pidController.text);
                if (pid == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
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

                // Delete the product
                final success = await deleteProduct(pid);

                // Close loading dialog
                Navigator.of(context).pop();

                if (success) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Call the callback to refresh the list
                  onDeleted();
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete product'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
