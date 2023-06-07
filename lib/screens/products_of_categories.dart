import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/products_model.dart';
import '../services/api_handler.dart';
import '../widgets/feeds_widget.dart';

class ProductsOfCategories extends StatefulWidget {
  const ProductsOfCategories({super.key, required this.categoryName});
  final String categoryName;
  @override
  State<ProductsOfCategories> createState() => _ProductsOfCategoriesState();
}

class _ProductsOfCategoriesState extends State<ProductsOfCategories> {
  List<ProductsModel> productsList = [];

  @override
  void didChangeDependencies() {
    getProducts();
    super.didChangeDependencies();
  }

  bool isLoading = false;
  Future<void> getProducts() async {
    isLoading = true;
    productsList = await ApiHandler.getAllProduct();
    productsList = productsList
        .where((element) => element.category!.name == widget.categoryName)
        .toList();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 4,
        title: Text(widget.categoryName),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productsList.isEmpty
              ? const Center(
                  child: Text('No Products'),
                )
              : GridView.builder(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: productsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                      childAspectRatio: 0.7),
                  itemBuilder: (ctx, index) {
                    return ChangeNotifierProvider.value(
                      value: productsList[index],
                      child: const FeedsWidget(
                          // title: productsList[index].title.toString(),
                          // imageUrl: productsList[index].images![0],
                          // price: productsList[index].price!.toDouble(),
                          ),
                    );
                  },
                ),
    );
  }
}
