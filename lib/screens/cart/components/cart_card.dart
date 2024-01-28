import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/Cart.dart';
import '../../../models/Product.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network("http://172.16.0.2:3000/"+product.images[0]),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded( // Wrap the Column with Expanded
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Add this line to handle long text
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: "\$${product.price}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  // children: [
                  //   TextSpan(
                  //       text: " x${cart.numOfItem}",
                  //       style: Theme.of(context).textTheme.bodyLarge),
                  // ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

