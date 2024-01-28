import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import dio package
import 'package:shop_app/components/product_card_home.dart';
import 'package:shop_app/models/Product.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  _PopularProductsState createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  List<Product> products = []; // List to store fetched products

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch products when the widget initializes
  }

  Future<void> fetchProducts() async {
    try {
      // Make API call using dio
      Response response = await Dio().get('http://172.16.0.2:3000/shoes');
      // Assuming the response contains a list of products
      List<dynamic> data = response.data['data'];
      // print(data);
      setState(() {
        // Update the products list with fetched data
        products = data.map((json) => Product.fromJson(json)).toList();
      });
    } catch (error) {
      // Handle errors
      print('Error fetching products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "All Products",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...products.map((product) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: ProductCardHome(
                    product: product,
                    onPress: () => Navigator.pushNamed(
                      context,
                      DetailsScreen.routeName,
                      arguments: ProductDetailsArguments(product: product),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}
