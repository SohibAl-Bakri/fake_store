import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../consts/global_colors.dart';
import '../model/categories_model.dart';
import '../model/products_model.dart';
import '../services/api_handler.dart';
import '../widgets/feeds_widget.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  List<ProductsModel> productsList = [];
  List<ProductsModel> filterProductsList = [];
  List<CategoriesModel> categoriesList = [];

  Future<void> getCategories() async {
    categoriesList =
        (await ApiHandler.getAllCategories()).cast<CategoriesModel>();
    categoriesList.insert(
      0,
      CategoriesModel(
        name: 'All',
      ),
    );
    setState(() {});
  }

  // @override
  // void didChangeDependencies() {
  //   getProducts();
  //   getCategories();
  //   super.didChangeDependencies();
  // }

  bool isLoading = false;
  Future<void> getProducts() async {
    isLoading = true;
    productsList = await ApiHandler.getAllProduct();
    filterProductsList = productsList;
    isLoading = false;
    setState(() {});
  }

  late TextEditingController _textEditingController;
  // List<ProductsModel> productsList = [];
  @override
  void initState() {
    _textEditingController = TextEditingController();
    getProducts();
    getCategories();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          // elevation: 4,
          title: const Text('All Products'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _textEditingController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          FocusScope.of(context).autofocus(FocusNode());
                          if (value.isEmpty) {
                            setState(() {
                              filterProductsList = productsList;
                              FocusScope.of(context).unfocus();
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(IconlyLight.search),
                            color: Colors.pinkAccent,
                            onPressed: () {
                              if (_textEditingController.text
                                  .trim()
                                  .isNotEmpty) {
                                setState(
                                  () {
                                    filterProductsList = productsList
                                        .where(
                                          (element) => element.title!
                                              .toLowerCase()
                                              .contains(
                                                _textEditingController.text
                                                    .trim()
                                                    .toLowerCase(),
                                              ),
                                        )
                                        .toList();
                                  },
                                );
                              } else {
                                setState(() {
                                  filterProductsList = productsList;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: GlobalColors.cardColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: const Text('Filter'),
                              //disabledHint: const Text('Filter'),
                              icon: Icon(
                                Icons.filter_alt_outlined,
                                color: GlobalColors.iconsColor,
                              ),
                              items: categoriesList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.name.toString(),
                                      child: Text(e.name.toString()),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  if (value.toString() == 'All') {
                                    setState(() {
                                      filterProductsList = productsList;
                                    });
                                  } else {
                                    setState(() {
                                      filterProductsList = productsList
                                          .where(
                                            (element) =>
                                                element.category!.name!
                                                    .toLowerCase() ==
                                                value.toLowerCase(),
                                          )
                                          .toList();
                                    });
                                  }
                                } else {
                                  setState(() {
                                    filterProductsList = productsList;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filterProductsList.isEmpty
                      ? const Center(
                          child: Text('No Products'),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filterProductsList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0.0,
                                    mainAxisSpacing: 0.0,
                                    childAspectRatio: 0.7),
                            itemBuilder: (ctx, index) {
                              return ChangeNotifierProvider.value(
                                value: filterProductsList[index],
                                child: const FeedsWidget(
                                    // title: productsList[index].title.toString(),
                                    // imageUrl: productsList[index].images![0],
                                    // price: productsList[index].price!.toDouble(),
                                    ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
