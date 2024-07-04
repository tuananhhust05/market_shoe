import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_provider.dart';
import '../../controllers/mainscreen_provider.dart';
import '../shared/appstyle.dart';
import '../shared/checkout_btn.dart';
import 'homepage.dart';
import 'mainscreen.dart';

class CartPage extends StatelessWidget {
  CartPage({ super.key });
  final _cartBox = Hive.box('cart_box');
  @override
  Widget build(BuildContext context){
    // _cartBox.clear();

    // Scaffold là một class trong Flutter,
    // Scaffold thông qua API cung cấp nhiều Widget
    // để hiển thị như Drawer, SnackBar, BottomNavigationBar,
    // FloatingActionButton, AppBar, … Scaffold có khả năng mở
    // rộng để lấp đầy màn hình hoặc không gian có sẵn
    return Consumer<MainScreenNotifier>(
        builder:(context,mainScreenNotifier,child){
          var cartNotifier_init = Provider.of<CartProvider>(context,listen:true);
          cartNotifier_init.getCart();
          return Scaffold(
              body:Padding(
                  padding:const EdgeInsets.all(12),
                  child:Stack(
                      children:[
                        Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children:[
                              const SizedBox(height:40),
                              GestureDetector(
                                  onTap:(){
                                    mainScreenNotifier.pageIndex = 0;
                                    //Navigator.pop(context);
                                    //Navigator.push(context,MaterialPageRoute(builder:(context)=> const HomePage()));
                                  },
                                  child:const Icon(Icons.close, color:Colors.black)
                              ),

                              Text("My Cart",
                                  style:appstyle(36,Colors.black,FontWeight.bold)
                              ),
                              const SizedBox(height:20),
                              SizedBox(
                                  height:MediaQuery.of(context).size.height * 0.65,
                                  child: ListView.builder(
                                      itemCount:cartNotifier_init.cart.length,
                                      padding:EdgeInsets.zero,
                                      itemBuilder:(context,index){
                                        final data = cartNotifier_init.cart[index];
                                        return Padding(
                                            padding:const EdgeInsets.all(8),
                                            // for radius
                                            child:ClipRRect(
                                                borderRadius:const BorderRadius.all(Radius.circular(12)),
                                                // for animation delete
                                                child:Slidable(
                                                  key:const ValueKey(0),
                                                  endActionPane:ActionPane(
                                                    motion: const ScrollMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        // An action can be bigger than the others.
                                                        flex: 1,
                                                        onPressed: (BuildContext context) async  {
                                                          cartNotifier_init.deleteCart(data['key']);
                                                        },
                                                        backgroundColor: const Color(0xFF000000),
                                                        foregroundColor: Colors.white,
                                                        icon: Icons.delete,
                                                        label: 'Delete',
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                      height:MediaQuery.of(context).size.height * 0.15,
                                                      width:MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(
                                                          color:Colors.grey.shade100,
                                                          boxShadow:[
                                                            BoxShadow(
                                                                color:Colors.grey.shade500,
                                                                spreadRadius:5,
                                                                blurRadius:0.3,
                                                                offset:const Offset(0,1)
                                                            )
                                                          ]
                                                      ),
                                                      child:Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children:[
                                                            Padding(
                                                                padding:const EdgeInsets.all(12),
                                                                child:SizedBox(
                                                                  width:MediaQuery.of(context).size.width*0.2,
                                                                  child: CachedNetworkImage(
                                                                      imageUrl: data['imageUrl'],
                                                                      width:70,
                                                                      height:70,
                                                                      fit:BoxFit.fill
                                                                  ),
                                                                )
                                                            ),
                                                            Padding(
                                                                padding:const EdgeInsets.only(top:12,left:12),
                                                                child:SizedBox(
                                                                  width:MediaQuery.of(context).size.width*0.6,
                                                                  child: Column(
                                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                                      children:[
                                                                        Text(data['name'],
                                                                            style:appstyle(16,Colors.black,FontWeight.bold)
                                                                        ),
                                                                        const SizedBox(height:5),
                                                                        Text(data['category'],
                                                                           style:appstyle(14,Colors.grey,FontWeight.w600)
                                                                        ),
                                                                        const SizedBox(height:5),

                                                                        Row(
                                                                          children: [
                                                                            Text("\$${data['price']}",
                                                                              style:appstyle(14,Colors.black,FontWeight.w600)
                                                                            ),
                                                                            const SizedBox(width:25),
                                                                            Text("Size:",
                                                                                style:appstyle(14,Colors.black,FontWeight.w600)
                                                                            ),
                                                                            const SizedBox(width:5),
                                                                            Text(data['sizes'],
                                                                                style:appstyle(14,Colors.black,FontWeight.w600)
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ]
                                                                  ),
                                                                )
                                                            )
                                                          ]
                                                      )
                                                  ),
                                                )
                                            )
                                        );
                                      }
                                  )
                              )
                            ]
                        ),
                        const Align(
                           alignment:Alignment.bottomCenter,
                           child:CheckoutButton(
                             label:"Procced to Checkout",
                           )
                        )
                      ]
                  )
              )
          );
        },
    );
  }
}

