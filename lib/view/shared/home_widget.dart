import 'package:app3/view/shared/product_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_provider.dart';
import '../../models/sneaker_model.dart';
import '../ui/product_by_cat.dart';
import '../ui/product_page.dart';
import 'appstyle.dart';
import 'new_shoes.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required Future<List<Sneakers>> male, required this.tabIndex,
  }): _male = male;

  final Future<List<Sneakers>> _male;
  final int tabIndex;
  @override
  Widget build(BuildContext context) {
    // list size of a product
    var productNotifier = Provider.of<ProductNotifier>(context);
    return
      Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height*0.405,
              child:
              FutureBuilder<List<Sneakers>>(
                  future: _male, // take data
                  builder:(context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    else if(snapshot.hasError){
                      return Text("Error ${snapshot.error}");
                    }
                    else{
                      final male = snapshot.data;
                      return  ListView.builder(
                          itemCount:male?.length,
                          // 2 type for render list
                          // vertical, horizontal , we just understand after we do
                          // horizontal: slide ngang
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            final shoe = snapshot.data![index];
                            return GestureDetector(
                              onTap:(){
                                // update data in controller
                                productNotifier.shoeSizes = shoe.sizes;
                                // navi to other page
                                Navigator.push(context,MaterialPageRoute(
                                  builder: (context)=>
                                      ProductPage(
                                        id:shoe.id,
                                        category:shoe.category
                                      )
                                ));
                              },
                              child: ProductCard(
                                  price: shoe.price,
                                  category:shoe.category,
                                  id: shoe.id,
                                  name: shoe.name,
                                  image: shoe.imageUrl[0]
                              ),
                            );
                          });
                    }
                  }
              )
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12,20,12,20),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Latest Shoes",
                      style: appstyle(24, Colors.black, FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                              return  ProductByCat(tabIndex:tabIndex);
                            }
                          )
                        );
                      },
                      child: Row(
                        children: [
                          Text("Show All",
                            style: appstyle(22, Colors.black, FontWeight.w500),
                          ),
                          const Icon(Icons.arrow_right,size:40)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
              height:MediaQuery.of(context).size.height*0.13,
              child:
              FutureBuilder<List<Sneakers>>(
                  future: _male, // take data
                  builder:(context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const CircularProgressIndicator();
                    }
                    else if(snapshot.hasError){
                      return Text("Error ${snapshot.error}");
                    }
                    else{
                      final male = snapshot.data;
                      return  ListView.builder(
                          itemCount:male?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            final shoe = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: NewShoes(
                                  imageUrl: shoe.imageUrl[1]
                              ),
                            );
                          });
                    }
                  }
              )
          )
        ],
      );
  }


}