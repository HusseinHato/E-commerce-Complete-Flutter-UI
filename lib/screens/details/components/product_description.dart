import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../models/Product.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    // this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  // final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            product.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
            top: 12
          ),
          child: Text(
            product.desc,
            // maxLines: 3,
          ),
        ),
        Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 64,
          top: 20
        ), child: Text(
          'Price : \$${product.price} / qty',
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),
        ),)
        // const Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: 20,
        //     vertical: 12,
        //   ),
        //   // child: GestureDetector(
        //   //   onTap: () {},
        //   //   child: const Row(
        //   //     children: [
        //   //       Text(
        //   //         "See More Detail",
        //   //         style: TextStyle(
        //   //             fontWeight: FontWeight.w600, color: kPrimaryColor),
        //   //       ),
        //   //       SizedBox(width: 5),
        //   //       Icon(
        //   //         Icons.arrow_forward_ios,
        //   //         size: 12,
        //   //         color: kPrimaryColor,
        //   //       ),
        //   //     ],
        //   //   ),
        //   // ),
        // )
      ],
    );
  }
}
