import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:antd_icons/antd_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../models/sneaker_model.dart';
import '../../services/helper.dart';
import '../shared/appstyle.dart';
import '../shared/category_btn.dart';
import '../shared/custom_spacer.dart';
import '../shared/latest_shoes.dart';
import '../shared/product_card.dart';
import '../shared/stagger_tile.dart';

class ProductByCat extends StatefulWidget {
  const ProductByCat({ super.key, required this.tabIndex });
  final int tabIndex;
  @override
  State<ProductByCat> createState() => _ProductByCatState();
}

//Provides Ticker objects that are configured to only tick while the current tree is enabled
class _ProductByCatState extends State<ProductByCat> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(length:3,vsync:this,initialIndex:widget.tabIndex); // init index tab 

  late Future<List<Sneakers>> _male;
  late Future<List<Sneakers>> _female;
  late Future<List<Sneakers>> _kids;

  void getMale(){
    _male = Helper().getMaleSneakers();
  }

  void getFemale(){
    _female = Helper().getFemaleSneakers();
  }

  void getKids(){
    _kids = Helper().getKidsSneakers();
  }

  // hàm khởi tạo mặc định
  @override
  void initState(){
    super.initState();
    getMale();
    getFemale();
    getKids();
  }

  List<String> brand = [
    "assets/images/adidas.png",
    "assets/images/gucci.png",
    "assets/images/jordan.png",
    "assets/images/nike.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body:SizedBox(
        height:MediaQuery.of(context).size.height,
        child:Stack(
          children:[
            // icon image
            Container(
              padding:const EdgeInsets.fromLTRB(16,45,0,0),
              height:MediaQuery.of(context).size.height*0.4,
              decoration:const BoxDecoration(
                  image:DecorationImage(
                      image:AssetImage("assets/images/top_image.png"),
                      fit:BoxFit.fill // ảnh điền đầy
                  )
              ),
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children:[
                  Padding(
                    padding:const EdgeInsets.fromLTRB(6,12,16,18),
                    child:Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[
                            // back to previous page
                            // we can have error here if we don't have any popup is showing
                            GestureDetector(
                               onTap:(){
                                 Navigator.pop(context); // close action
                               },
                               child:const Icon(Icons.close,color:Colors.white)
                           ),
                            GestureDetector(
                                onTap:(){
                                    filter(); // show popup filter
                                },
                                child:const Icon(
                                    FontAwesomeIcons.sliders,
                                    color:Colors.white
                                )
                            ),
                      ]
                    )
                  ),
                  TabBar(
                    padding:EdgeInsets.zero,
                    indicatorSize:TabBarIndicatorSize.label,
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.white,
                    labelStyle: appstyle(24, Colors.white, FontWeight.bold),
                    unselectedLabelColor: Colors.grey.withOpacity(0.3),
                    tabs: const [
                      Tab(text:"Men Shoes"),
                      Tab(text:"Women Shoes"),
                      Tab(text:"Kids Shoes"),
                    ],
                  ),
                ]
              )
            ),
            // can set in any position
            Padding(
              padding: EdgeInsets.only(
                  top:MediaQuery.of(context).size.height*0.175,
                  left:16,
                  right:12
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: TabBarView(
                  controller:_tabController,
                  children: [
                    latestShoes(male:_male),
                    latestShoes(male:_female),
                    latestShoes(male:_kids),
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }


  // buttom filter
  Future<dynamic> filter(){
    double _value = 100;
    // this is an amazing animation
    return showModalBottomSheet( // default function in flutter
        context: context,
        isScrollControlled:true,
        backgroundColor:Colors.transparent,
        barrierColor:Colors.white,
        builder: (BuildContext context) {
          return Container(
               height:MediaQuery.of(context).size.height * 0.98,
               decoration: const BoxDecoration(
                 color:Colors.white,
                 borderRadius:BorderRadius.only(
                    topLeft:Radius.circular(25),
                    topRight:Radius.circular(25),
                 )
               ),
               child: Column(
                  children:[
                     const SizedBox(
                       height:10,
                     ),
                     Container(
                       height:5,
                       width:40,
                       decoration:const BoxDecoration(
                         borderRadius:BorderRadius.all(Radius.circular(10)),
                         color:Colors.black38
                       )
                     ),
                     SizedBox(
                       height:MediaQuery.of(context).size.height * 0.7,
                       child: Column(
                         children:[
                           const CustomSpacer(),  // khoảng cách
                           Text("Filter",
                               style:appstyle(40,Colors.black,FontWeight.bold)
                           ),
                           const CustomSpacer(),
                           Text("Gender",style:appstyle(20,Colors.black,FontWeight.bold)),
                           const SizedBox(
                             height:20,
                           ),
                           const Row(
                             children:[
                               CategoryBtn(
                                 label:"Men",
                                 buttonClr:Colors.black,
                               ),
                               CategoryBtn(
                                 label:"Women",
                                 buttonClr:Colors.grey,
                               ),
                               CategoryBtn(
                                 label:"Kids",
                                 buttonClr:Colors.grey,
                               )
                             ]
                           ),
                           const CustomSpacer(),
                           Text("Category",
                               style:appstyle(20,Colors.black,FontWeight.w600)
                           ),
                           const CustomSpacer(),
                           const Row(
                             children:[
                               CategoryBtn(
                                 label:"Shoes",
                                 buttonClr:Colors.black,
                               ),
                               CategoryBtn(
                                 label:"Apparrels",
                                 buttonClr:Colors.grey,
                               ),
                               CategoryBtn(
                                 label:"Accessories",
                                 buttonClr:Colors.grey,
                               ),
                             ]
                           ),
                           const CustomSpacer(),
                           Text("Price",
                               style:appstyle(20,Colors.black,FontWeight.w600)
                           ),

                           // thanh trượt
                           Slider(
                             value: _value,
                             activeColor:Colors.black,
                             inactiveColor:Colors.grey,
                             thumbColor:Colors.black,
                             max:500,
                             divisions:50,
                             label:_value.toString(),
                             secondaryTrackValue:200,
                             onChanged:(double value){

                             }
                           ),

                           Text("Brand",style:appstyle(20,Colors.black,FontWeight.bold)),
                           const SizedBox(
                             height:20
                           ),

                           Container(
                             padding:const EdgeInsets.all(8),
                             height:60,
                             child:ListView.builder(
                               scrollDirection:Axis.horizontal,
                               itemCount:brand.length,
                               itemBuilder: (BuildContext context, int index) {
                                 return Padding(
                                   padding:const EdgeInsets.all(8),
                                   child:Container(
                                     decoration:BoxDecoration(
                                       color:Colors.grey.shade200,
                                       borderRadius:const BorderRadius.all(
                                         Radius.circular(12)
                                       ),
                                     ),
                                     child:Image.asset(brand[index],
                                        height:50,
                                        width:80,
                                        color:Colors.black
                                     ),
                                   )
                                 );
                               },
                             )
                           )
                         ]
                       )
                     )
                  ]
              )
          );
        }
    );
  }
}