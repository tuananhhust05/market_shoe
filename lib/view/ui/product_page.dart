import 'package:antd_icons/antd_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorites_provider.dart';
import '../../controllers/mainscreen_provider.dart';
import '../../controllers/product_provider.dart';
import '../../models/constants.dart';
import '../../models/sneaker_model.dart';
import '../../services/helper.dart';
import '../shared/appstyle.dart';
import '../shared/checkout_btn.dart';
import 'favorites.dart';
import 'homepage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({ super.key, required this.id, required this.category });

  final String id;
  final String category;

  @override
  State<ProductPage> createState() => _ProductByCatState();
}

class _ProductByCatState extends State<ProductPage> {
  final PageController pageController = PageController();
  late Future<Sneakers> _sneaker;
  final _cartBox = Hive.box('cart_box');
  final _favBox = Hive.box('fav_box');

  // don't use provider because it's not optimize
  // when we change state in product provider, this page is rerender
  void getShoes(){
     if(widget.category == "Men's Running"){
       _sneaker = Helper().getMaleSneakersById(widget.id);
     }
     else if(widget.category == "Women's Running"){
       _sneaker = Helper().getFemaleSneakersById(widget.id);
     }
     else if(widget.category == "Kids' Running"){
       _sneaker = Helper().getKidsSneakersById(widget.id);
     }
  }

  //Future<void>:  as a promise but don't return anything
  //Map<String, dynamic> maps a String key with the dynamic value
  //value can be of any type, it is kept as dynamic to be on the safer side
  Future<void> _createCart(Map<String,dynamic> newCart) async {
       await _cartBox.add(newCart);
  }

  @override
  void initState(){
    super.initState();
    getShoes();
  }

  @override
  Widget build(BuildContext context) {
    // data in provider is global
    // when we change data in it
    // any object is created by provider after have data
    var favorNotifier_init = Provider.of<FavoriteNotifier>(context,listen:true);
    favorNotifier_init.getFavorites();
    return Consumer<MainScreenNotifier>(
        builder:(context,mainScreenNotifier,child){
          return  FutureBuilder<Sneakers>(
              future: _sneaker, // take data
              builder:(context,snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                }
                else {
                  final sneaker = snapshot.data;
                  return Scaffold(
                    // controller for managing state
                    // connect to controller
                      body: Consumer<ProductNotifier>(
                        builder: (BuildContext context, productNotifier, Widget? child) {
                          return CustomScrollView(
                              slivers:[
                                // slide to show product
                                SliverAppBar(
                                    automaticallyImplyLeading:false,
                                    leadingWidth:0,
                                    title: Padding(
                                        padding: const EdgeInsets.only(bottom:10),
                                        child:Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children:[
                                              GestureDetector(
                                                  onTap:(){
                                                    Navigator.pop(context);
                                                    //productNotifier.shoeSizes.clear(); // clear list size
                                                  },
                                                  child: const Icon(Icons.close,color:Colors.black)
                                              ),
                                              GestureDetector(
                                                  onTap:null,
                                                  child: const Icon(Ionicons.ellipsis_horizontal)
                                              ),
                                            ]
                                        )
                                    ),
                                    pinned:true,
                                    snap:false,
                                    floating:true,
                                    backgroundColor:Colors.transparent,
                                    expandedHeight:MediaQuery.of(context).size.height,
                                    flexibleSpace:FlexibleSpaceBar(
                                        background: Stack(
                                            children:[

                                              // image and slide
                                              SizedBox(
                                                  height:MediaQuery.of(context).size.height * 0.3,
                                                  width:MediaQuery.of(context).size.height,
                                                  child: PageView.builder(
                                                    scrollDirection:Axis.horizontal,
                                                    itemCount:sneaker!.imageUrl.length,
                                                    controller:pageController,
                                                    onPageChanged:(page){
                                                      productNotifier.activepage = page; // update data in controller
                                                    },
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Stack(
                                                        // UI be repeated many time
                                                          children:[
                                                            Container(
                                                                height:MediaQuery.of(context).size.height * 0.39,
                                                                width:MediaQuery.of(context).size.width,
                                                                color:Colors.grey.shade300,
                                                                child:CachedNetworkImage(
                                                                    imageUrl:sneaker.imageUrl[index],
                                                                    fit:BoxFit.contain
                                                                )
                                                            ),

                                                            // put widget to any position you want
                                                            Positioned(
                                                              top:MediaQuery.of(context).size.height * 0.09,
                                                              right:20,
                                                              child: Consumer<FavoriteNotifier>(
                                                                  builder:(context,favoriteNotifier,child){
                                                                    return GestureDetector(
                                                                      onTap:(){
                                                                        if(favoriteNotifier.ids.contains(sneaker.id)){
                                                                          mainScreenNotifier.pageIndex = 2;
                                                                          Navigator.pop(context);
                                                                          // Navigator.push(
                                                                          //     context,
                                                                          //     MaterialPageRoute(
                                                                          //         builder:(context) => const Favorites()
                                                                          //     )
                                                                          // );
                                                                        }
                                                                        else{
                                                                          favoriteNotifier.createFav({
                                                                            "id":sneaker.id,
                                                                            "name":sneaker.name,
                                                                            "category":sneaker.category,
                                                                            "price":sneaker.price,
                                                                            "imageUrl":sneaker.imageUrl[0]
                                                                          });
                                                                          setState((){}); // update data in controller
                                                                        };
                                                                      },
                                                                      child: favoriteNotifier.ids.contains(sneaker.id) ? const Icon(CommunityMaterialIcons.heart,
                                                                          color:Colors.grey
                                                                      ): const Icon(CommunityMaterialIcons.heart_outline,
                                                                          color:Colors.grey
                                                                      ),
                                                                    );
                                                                  }
                                                                )
                                                            ),

                                                            Positioned(
                                                                bottom:0,
                                                                right:0,
                                                                left:0,
                                                                height:MediaQuery.of(context).size.height * 0.1,
                                                                child: Row(
                                                                    mainAxisAlignment:MainAxisAlignment.center,
                                                                    // auto take data from parents
                                                                    children:List<Widget>.generate(sneaker!.imageUrl.length,(index)=>
                                                                        Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal:4),
                                                                            child:CircleAvatar(
                                                                                radius:5,
                                                                                backgroundColor:productNotifier.activepage != index ? Colors.grey : Colors.black // config màu
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            ),

                                                          ]
                                                      );
                                                    },
                                                  )
                                              ),

                                              // Content
                                              // change top, bottom, left, right to put in postion you want
                                              Positioned(
                                                bottom:20,
                                                // ClipRRect for radius border
                                                child: ClipRRect(
                                                    borderRadius:const BorderRadius.only(
                                                        topLeft:Radius.circular(30),
                                                        topRight:Radius.circular(30)
                                                    ),
                                                    child:Container(
                                                        height:MediaQuery.of(context).size.height*0.675,
                                                        width:MediaQuery.of(context).size.width,
                                                        color:Colors.white,
                                                        child:Padding(
                                                            padding:const EdgeInsets.all(12),
                                                            child:Column(
                                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                                children:[
                                                                  Text(sneaker.name,
                                                                      style:appstyle(30,Colors.black,FontWeight.bold)
                                                                  ),

                                                                  Row(
                                                                      children:[
                                                                        Text(sneaker.category,
                                                                            style:appstyle(20,Colors.grey,FontWeight.w500)
                                                                        ),
                                                                        const SizedBox(
                                                                            width:20
                                                                        ),
                                                                        RatingBar.builder(
                                                                            initialRating:4,
                                                                            minRating:1,
                                                                            direction:Axis.horizontal,
                                                                            allowHalfRating:true,
                                                                            itemCount:5,
                                                                            itemSize:22,
                                                                            itemPadding:const EdgeInsets.symmetric(horizontal:1),
                                                                            itemBuilder:(context,_)
                                                                            => const Icon(Icons.star,size:18,color:Colors.black),
                                                                            onRatingUpdate: (rating){

                                                                            }
                                                                        )
                                                                      ]
                                                                  ),

                                                                  const SizedBox(height:20),
                                                                  Row(
                                                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                      children:[
                                                                        Text("\$${sneaker.price}",
                                                                            style:appstyle(26,Colors.black,FontWeight.w600)
                                                                        ),
                                                                        Row(
                                                                            children:[
                                                                              Text("Colors",
                                                                                  style:appstyle(18,Colors.black,FontWeight.w500)
                                                                              ),
                                                                              const SizedBox(width:5),
                                                                              const CircleAvatar(
                                                                                  radius:7,
                                                                                  backgroundColor:Colors.black
                                                                              ),
                                                                              const SizedBox(
                                                                                  width:5
                                                                              ),
                                                                              const CircleAvatar(
                                                                                  radius:7,
                                                                                  backgroundColor:Colors.amber
                                                                              ),
                                                                            ]
                                                                        )

                                                                      ]
                                                                  ),

                                                                  const SizedBox(
                                                                      height:20
                                                                  ),

                                                                  Column(
                                                                      children:[
                                                                        Row(
                                                                            children:[
                                                                              Text("Select sizes",
                                                                                  style:appstyle(20,Colors.black,FontWeight.w600)
                                                                              ),
                                                                              const SizedBox(
                                                                                  width:20
                                                                              ),
                                                                              Text("View size guide",
                                                                                  style:appstyle(20,Colors.grey,FontWeight.w600)
                                                                              )
                                                                            ]
                                                                        ),
                                                                        const SizedBox(
                                                                            height:10
                                                                        ),

                                                                        // list for select size
                                                                        SizedBox(
                                                                            height:40,
                                                                            child:ListView.builder(
                                                                              itemCount:productNotifier.shoeSizes.length,
                                                                              scrollDirection:Axis.horizontal,
                                                                              padding:EdgeInsets.zero,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                  child: ChoiceChip(
                                                                                    shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(60),
                                                                                        side:const BorderSide(
                                                                                            color:Colors.black,
                                                                                            width:1,
                                                                                            style:BorderStyle.solid
                                                                                        )
                                                                                    ),
                                                                                    disabledColor: Colors.white,
                                                                                    selectedColor:Colors.grey,
                                                                                    label: Text(
                                                                                        productNotifier.shoeSizes[index]['size'],
                                                                                        style:appstyle(18,Colors.black,FontWeight.w500)
                                                                                    ),
                                                                                    selected:  productNotifier.shoeSizes[index]['isSelected'],
                                                                                    onSelected: (newState){
                                                                                      productNotifier.toggleCheck(index);
                                                                                    },
                                                                                  ),
                                                                                );
                                                                              },)
                                                                        )
                                                                      ]
                                                                  ),

                                                                  const SizedBox(
                                                                      height:20
                                                                  ),
                                                                  const Divider(
                                                                      indent:10,
                                                                      endIndent:10,
                                                                      color:Colors.black
                                                                  ),
                                                                  const SizedBox(
                                                                      height:10
                                                                  ),
                                                                  SizedBox(
                                                                      width:MediaQuery.of(context).size.width*0.8,
                                                                      child:Text(sneaker.title,
                                                                          style:appstyle(20,Colors.black,FontWeight.w700)
                                                                      )
                                                                  ),
                                                                  const SizedBox(
                                                                      height:10
                                                                  ),
                                                                  Text(sneaker.description,
                                                                      textAlign:TextAlign.justify,
                                                                      maxLines:4,
                                                                      style: appstyle(14,Colors.black,FontWeight.normal)
                                                                  ),
                                                                  const SizedBox(
                                                                      height:10
                                                                  ),
                                                                  Align(
                                                                      alignment:Alignment.bottomCenter,
                                                                      child:Padding(
                                                                          padding:const EdgeInsets.only(top:12),
                                                                          child:CheckoutButton(
                                                                              onTap:() async {
                                                                                List<String> sizes = [];
                                                                                for(int i=0; i< productNotifier.shoeSizes.length; i++){
                                                                                  if(productNotifier.shoeSizes[i]['isSelected'] == true){
                                                                                    sizes.add(productNotifier.shoeSizes[i]['size']);
                                                                                  }
                                                                                };
                                                                                if(sizes.isNotEmpty){
                                                                                  for(int i = 0; i< sizes.length; i++){
                                                                                    await _createCart({
                                                                                      "id":sneaker.id,
                                                                                      "name":sneaker.name,
                                                                                      "category":sneaker.category,
                                                                                      "sizes":sizes[i],
                                                                                      "imageUrl":sneaker.imageUrl[0],
                                                                                      "price":sneaker.price,
                                                                                      "qty":1
                                                                                    });
                                                                                  }
                                                                                  productNotifier.clearSelected();
                                                                                  // go to cart page
                                                                                  mainScreenNotifier.pageIndex = 3;
                                                                                  Navigator.pop(context);
                                                                                }
                                                                                else{
                                                                                  print("Don't Choose size");
                                                                                }
                                                                              },
                                                                              label:"Add to cart"
                                                                          )
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                ),
                                              ),
                                            ]
                                        )
                                    )
                                )
                              ]
                          );
                        },

                      )

                  );
                };
              }
          );
        });
  }
}