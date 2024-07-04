import 'package:app3/view/shared/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_provider.dart';
import '../../models/sneaker_model.dart';
import '../../services/helper.dart';
import '../shared/appstyle.dart';
import '../shared/bottom_nav.dart';
import '../shared/home_widget.dart';
import '../shared/new_shoes.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//TickerProviderStateMixin
//Provides Ticker objects that are configured to only tick while the current tree is enabled
class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  late final TabController _tabController = TabController(length:3,vsync:this);
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
  }

  @override
  Widget build(BuildContext context) {
    var productNotifier_init = Provider.of<ProductNotifier>(context,listen:true);
    productNotifier_init.getMale();
    productNotifier_init.getFemale();
    productNotifier_init.getKids();
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body:SizedBox(
        
        height:MediaQuery.of(context).size.height,
        child:Stack(
          children:[
            // banner and tabbar
            Container(
              padding:const EdgeInsets.fromLTRB(16,45,0,0),
              height:MediaQuery.of(context).size.height*0.4,
              decoration:const BoxDecoration(
                 image:DecorationImage(
                   image:AssetImage("assets/images/top_image.png"),
                   fit:BoxFit.fill // ảnh điền đầy
                 )
              ),
              child:Container(
                padding:const EdgeInsets.only(left:0,bottom:15),
                width:MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    Text("Athletics Shoes",
                       style:appstyleWithHt(42,Colors.white,FontWeight.bold,1.5),
                    ),
                    Text("Collection",
                      style:appstyleWithHt(42,Colors.white,FontWeight.bold,1.2)
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
                ),
              )
            ),

            // body
            Padding(
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.265),
              child: Container(
                padding:const EdgeInsets.only(left:12),
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      // data is taken in out
                      // this widget just render
                      HomeWidget(male:productNotifier_init.male,tabIndex:0),
                      HomeWidget(male:productNotifier_init.female,tabIndex:1),
                      HomeWidget(male:productNotifier_init.kids,tabIndex:2),
                    ]
                ),
              ),
            )
          ]
        )
      ),
    );
  }
}