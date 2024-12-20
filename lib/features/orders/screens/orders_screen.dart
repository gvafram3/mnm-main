import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:m_n_m/features/orders/cart_item_model.dart';
import 'package:m_n_m/features/orders/providers/cart_provider.dart';
import 'package:m_n_m/order/upload_order.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import '../../../common/user_id_provider.dart';
import '../../../constants/global_variables.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../order_details/screens/order_details.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final List<Map<String, dynamic>> virtualOrder = [];
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  Future<void> getCartItems() async {
    print('fetching store items');
    final stores = await ref.read(cartProvider.notifier).fetchStores();
    print(
        'fetched stores: ${stores.map((e) => e.items.map((i) => i.addons.map((a) => a.name)))}');
  }

  Future<void> removeCartItem(String productId) async {
    await ref.read(cartProvider.notifier).removeItem(productId);
  }

  void addToVirtualOrder(CartItem item, String storeId) {
    // Find existing store in virtualOrder
    final existingOrder = virtualOrder.firstWhere(
      (order) => order['storeId'] == storeId,
      orElse: () => {},
    );

    if (existingOrder.isNotEmpty) {
      // Add item to the existing store order
      setState(() {
        existingOrder['items'].add({
          'itemSizeId': item.productId,
          'quantity': item.quantity,
          'addons': item.addons.map((addon) {
            return {
              'name': addon.name,
              'price': addon.price,
            };
          }).toList(),
        });
      });
    } else {
      // Create a new store order entry
      setState(() {
        virtualOrder.add({
          'storeId': storeId,
          'items': [
            {
              'itemSizeId': item.productId,
              'quantity': item.quantity,
              'addons': item.addons.map((addon) {
                return {
                  'name': addon.name,
                  'price': addon.price * addon.quantity,
                };
              }).toList(),
            },
          ],
          'address': {
            'longitude': '-0.2235431', // Replace with actual longitude
            'latitude': '5.5321491', // Replace with actual latitude
          },
        });
      });
    }
  }

  Future<void> confirmOrder() async {
    setState(() {
      isloading = true;
    });
    await uploadOrders(virtualOrder);
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final userIdAsync = ref.watch(userIdProvider);
    final theme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Orders",
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //   ),
      //   centerTitle: true,
      // ),
      body: userIdAsync.when(
        data: (userId) {
          if (userId == null) {
            return const Center(child: Text("User not logged in"));
          }

          if (cartState.isEmpty) {
            return const Center(child: Text("You have no orders yet"));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.026),
                const Center(
                  child: Text(
                    'Orders',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text('Today',
                    style: theme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartState.length,
                    itemBuilder: (context, storeIndex) {
                      final store = cartState[storeIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: store.items.map((item) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 14.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    IconlyLight.paper,
                                    size: 52,
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bulk order',
                                        style: theme.bodyLarge?.copyWith(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Text(
                                        "From: Apex Limited",
                                      ),
                                      const Text(
                                        "10:45 AM, Mon Aug 11 2024",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.yellow,
                                            radius: 4,
                                          ),
                                          SizedBox(width: 3),
                                          Text(
                                            'Ongoing order',
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 22),
                                      GestureDetector(
                                        onTap: () {
                                          // Dummy order data
                                          final order = Order(
                                            id: '1',
                                            products: [
                                              Product(
                                                  name: 'Product 1',
                                                  description: 'Description 1',
                                                  quantity: 1.0,
                                                  images: [
                                                    'https://via.placeholder.com/150'
                                                  ],
                                                  category: 'Category 1',
                                                  price: 10.0),
                                              Product(
                                                  name: 'Product 2',
                                                  description: 'Description 2',
                                                  quantity: 2.0,
                                                  images: [
                                                    'https://via.placeholder.com/150'
                                                  ],
                                                  category: 'Category 2',
                                                  price: 20.0),
                                            ],
                                            quantity: [2, 3],
                                            address: '123 Sample Street',
                                            userId: 'user123',
                                            orderedAt: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            status: 1,
                                            totalPrice: 99.99,
                                          );

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetailScreen(
                                                          order: order)));
                                        },
                                        child: const Text(
                                          'Track Order',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ListTile(
                            //   contentPadding: const EdgeInsets.symmetric(
                            //       vertical: 10.0, horizontal: 16.0),
                            //   leading: const Icon(
                            //     IconlyLight.paper,
                            //     size: 36,
                            //   ),
                            //   title: Text('Bulk order',
                            //       style: theme.bodyLarge?.copyWith(
                            //           color: AppColors.primaryColor,
                            //           fontWeight: FontWeight.w600)),
                            //   subtitle: const Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       SizedBox(height: 4),
                            //       Text(
                            //         "From: Apex Limited",
                            //         style: TextStyle(fontSize: 16),
                            //       ),
                            //       Text(
                            //         "10:45 AM, Mon Aug 11 2024",
                            //         style: TextStyle(fontSize: 11),
                            //       ),
                            //     ],
                            //   ),
                            //   trailing: const Expanded(
                            //     child: Column(
                            //       // mainAxisAlignment: MainAxisAlignment.end,
                            //       crossAxisAlignment: CrossAxisAlignment.end,
                            //       children: [
                            //         Row(
                            //           children: [
                            //             CircleAvatar(
                            //                 backgroundColor: Colors.yellow,
                            //                 radius: 4),
                            //             SizedBox(width: 3),
                            //             Text('Ongoing order',
                            //                 style: TextStyle(fontSize: 11)),
                            //           ],
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          );

                          // Old One

                          // Card(
                          // margin: const EdgeInsets.symmetric(vertical: 8.0),
                          // elevation: 3,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          //   child: ListTile(
                          //     contentPadding: const EdgeInsets.symmetric(
                          //         vertical: 10.0, horizontal: 16.0),
                          //     title: Text(
                          //       item.name,
                          //       style: const TextStyle(
                          //           fontSize: 18, fontWeight: FontWeight.w600),
                          //     ),
                          //     subtitle: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const SizedBox(height: 4),
                          //         Text(
                          //           "Quantity: ${item.quantity}",
                          //           style: const TextStyle(fontSize: 16),
                          //         ),
                          //         Text(
                          //           "Price: \$${item.price}",
                          //           style: const TextStyle(fontSize: 16),
                          //         ),
                          //         if (item.addons.isNotEmpty) ...[
                          //           const SizedBox(height: 8),
                          //           const Text(
                          //             "Add-ons:",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 16),
                          //           ),
                          //           const SizedBox(height: 4),
                          //           ...item.addons.map((addon) => Padding(
                          //                 padding:
                          //                     const EdgeInsets.only(left: 8.0),
                          //                 child: Text(
                          //                   "${addon.name} - \$${addon.price} x ${addon.quantity}",
                          //                   style:
                          //                       const TextStyle(fontSize: 14),
                          //                 ),
                          //               )),
                          //         ],
                          //       ],
                          //     ),
                          //     trailing: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         IconButton(
                          //           icon: const Icon(
                          //             Icons.add_shopping_cart,
                          //             color: Colors.blueAccent,
                          //           ),
                          //           onPressed: () =>
                          //               addToVirtualOrder(item, store.storeId),
                          //         ),
                          //         IconButton(
                          //           icon: const Icon(
                          //             Icons.delete,
                          //             color: Colors.redAccent,
                          //           ),
                          //           onPressed: () =>
                          //               removeCartItem(item.productId),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // );
                        }).toList(),
                      );
                    },
                  ),
                ),
                if (virtualOrder.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    "Virtual Order",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...virtualOrder.map((order) {
                    return ListTile(
                      title: Text("Store ID: ${order['storeId']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order['items'].map<Widget>((item) => Text(
                                "Item Size ID: ${item['itemSizeId']} - Quantity: ${item['quantity']}",
                              )),
                          const SizedBox(height: 8),
                          ...order['items'].map<Widget>(
                              (it) => Text('Addons: ${it['addons']}')),
                          const SizedBox(height: 8),
                          Text(
                              "Address: (${order['address']['longitude']}, ${order['address']['latitude']})"),
                        ],
                      ),
                    );
                  }),
                  ElevatedButton(
                    onPressed: confirmOrder,
                    child: isloading
                        ? const NutsActivityIndicator()
                        : const Text("Confirm Order"),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(child: Text("Error loading cart")),
      ),
    );
  }
}
