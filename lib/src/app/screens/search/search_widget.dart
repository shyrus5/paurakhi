import 'package:flutter/material.dart';
import 'package:paurakhi/src/app/screens/home/presentation/tabbars/productmodel.dart';
import 'package:paurakhi/src/app/screens/search/search_dialog.dart';
import 'package:paurakhi/src/core/API/Search/search_api.dart';
import 'package:paurakhi/src/core/themes/appstyles.dart';
import 'package:paurakhi/src/core/utils/evey_product_widget.dart';
import 'package:paurakhi/src/core/utils/loading_indicator.dart';

import 'domain/filter_saver.dart';
import 'domain/search_value.dart';

class SearchWidget extends StatefulWidget {
  final String name;

  const SearchWidget({Key? key, required this.name}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String type = "";
  var category = Filter.filter.join(',');
  List<ProductModel> productList = [];

  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Filter.type == 0 ? type = "request" : type = "sell";
    loadProducts();
  }

  Future<void> loadProducts() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final ServerResponseProduct? response =
          await SearchAPI.getSearchedProduct(
              category, widget.name, type, context, currentPage);

      if (response != null) {
        productList.addAll(response.data);
        currentPage++;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshProducts() async {
    setState(() {
      productList.clear();
      currentPage = 1;
    });
    await loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SearchValue.searchValue = "";
        return false;
      },
      child: RefreshIndicator(
        onRefresh: refreshProducts,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Search results for "${SearchValue.searchValue == "" ? "ALL" : SearchValue.searchValue}"\n for type $type',
                    textAlign: TextAlign.center,
                    style: AppStyles.text16PxMedium,
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () {
                      showOptionsDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.green,
                    ),
                    child: const Row(
                      children: [
                        Text("Filter"),
                        Icon(Icons.arrow_drop_down_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
                final ProductModel datum = productList[index];
                return everyProductWidgetProduct(context, datum);
              },
            ),
            isLoading
                ? loadingIndicator(context)
                : ElevatedButton(
                    onPressed: loadProducts,
                    child: const Text(
                      'Load More',
                    ),
                  ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
