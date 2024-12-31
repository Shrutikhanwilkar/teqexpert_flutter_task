import 'package:flutter/material.dart';
import 'package:teqexpert_flutter_task/features/products/repositories/product_repository.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/no_data_view.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({super.key});

  final ProductRepository controller = ProductRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: FutureBuilder<List<dynamic>>(
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
                MaterialPageRoute(builder: (context) => ProductListScreen()),
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
      ),
    );
  }
}
