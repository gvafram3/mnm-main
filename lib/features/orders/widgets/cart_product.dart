// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart';

// import '../../../models/product.dart';
// import '../../../providers/user_provider.dart';
// import '../../product_details/services/product_details_services.dart';
// import '../providers/cart_provider.dart';
// import '../services/cart_services.dart';

// class CartProduct extends ConsumerStatefulWidget {
//   final int index;
//   const CartProduct({
//     super.key,
//     required this.index,
//   });

//   @override
//   ConsumerState<CartProduct> createState() => _CartProductState();
// }

// class _CartProductState extends ConsumerState<CartProduct> {
//   final ProductDetailsServices productDetailsServices =
//       ProductDetailsServices();
//   final CartServices cartServices = CartServices();

//   void increaseQuantity(Product product) {
//     productDetailsServices.addToCart(
//       context: context,
//       product: product,
//     );
//   }

//   void decreaseQuantity(Product product) {
//     cartServices.removeFromCart(
//       context: context,
//       product: product,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cart = ref.watch(cartProvider)[widget.index];
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(
//             horizontal: 10,
//           ),
//           child: Row(
//             children: [
//               // Image.network(
//               //   cart.images[0],
//               //   fit: BoxFit.contain,
//               //   height: 135,
//               //   width: 135,
//               // ),
//               Column(
//                 children: [
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       cart.name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                       ),
//                       maxLines: 2,
//                     ),
//                   ),
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.only(left: 10, top: 5),
//                     child: Text(
//                       '\$${cart.price}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 2,
//                     ),
//                   ),
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.only(left: 10),
//                     child: const Text('Eligible for FREE Shipping'),
//                   ),
//                   Container(
//                     width: 235,
//                     padding: const EdgeInsets.only(left: 10, top: 5),
//                     child: const Text(
//                       'In Stock',
//                       style: TextStyle(
//                         color: Colors.teal,
//                       ),
//                       maxLines: 2,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.all(10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.black12,
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(5),
//                   color: Colors.black12,
//                 ),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       // onTap: () => decreaseQuantity(product),
//                       child: Container(
//                         width: 35,
//                         height: 32,
//                         alignment: Alignment.center,
//                         child: const Icon(
//                           Icons.remove,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                     DecoratedBox(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black12, width: 1.5),
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(0),
//                       ),
//                       child: Container(
//                         width: 35,
//                         height: 32,
//                         alignment: Alignment.center,
//                         child: Text(
//                           cart.quantity.toString(),
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       // onTap: () => increaseQuantity(product),
//                       child: Container(
//                         width: 35,
//                         height: 32,
//                         alignment: Alignment.center,
//                         child: const Icon(
//                           Icons.add,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
