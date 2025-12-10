import 'package:flutter/material.dart';
import 'product.dart';
import 'crud/search.dart';
import 'crud/add.dart';
import 'crud/delete.dart';
import 'crud/edit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false; // used to show products list or progress bar

  void update(bool success) {
    setState(() {
      _load = true; // show product list
      if (!success) {
        // API request failed
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('failed to load data')));
      }
    });
  }

  @override
  void initState() {
    // update data when the widget is added to the tree the first tome.
    updateProducts(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  AddProduct.showAddProductDialog(context, () {
                    setState(() {
                      _load = false; // show progress bar
                      updateProducts(update); // refresh product list
                    });
                  });
                },
                icon: const Icon(Icons.add, color: Colors.green)),
            IconButton(
                onPressed: () {
                  DeleteProduct.showDeleteByPidDialog(context, () {
                    setState(() {
                      _load = false; // show progress bar
                      updateProducts(update); // refresh product list
                    });
                  });
                },
                icon: const Icon(Icons.remove, color: Colors.red)),
            IconButton(
                onPressed: () {
                  EditProduct.showEditProductDialog(context, () {
                    setState(() {
                      _load = false; // show progress bar
                      updateProducts(update); // refresh product list
                    });
                  });
                },
                icon: const Icon(Icons.edit, color: Colors.blue)),
            IconButton(
                onPressed: !_load
                    ? null
                    : () {
                        setState(() {
                          _load = false; // show progress bar
                          updateProducts(update); // update data asynchronously
                        });
                      },
                icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  setState(() {
                    // open the search product page
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Search()));
                  });
                },
                icon: const Icon(Icons.search))
          ],
          title: const Text('Available Products'),
          centerTitle: true,
        ),
        // load products or progress bar
        body: _load
            ? const ShowProducts()
            : const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator())));
  }
}
