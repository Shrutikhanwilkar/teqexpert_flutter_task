import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teqexpert_flutter_task/features/products/repositories/product_repository.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/no_data_view.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductRepository controller = ProductRepository();

  @override
  void initState() {
    super.initState();

    controller.checkInternetConnectivity();
  }

  @override
  void dispose() {
    controller.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Obx(() {
        return controller.isConnectedToInternet.value
            ? FutureBuilder<List<dynamic>>(
                future: controller.fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Loading state
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Error state
                    return ErrorView(
                      errorMessage: snapshot.error.toString(),
                      onRetry: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductListScreen()),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // No data found state
                    return const NoDataView();
                  } else {
                    // Success state
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: Image.network(
                              product['thumbnail'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                            title: Text(product['title']),
                            subtitle: Text('\$${product['price']}'),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    const Text(
                      'No Internet Connection',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
