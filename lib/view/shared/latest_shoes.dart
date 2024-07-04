import 'package:app3/view/shared/product_card.dart';
import 'package:app3/view/shared/stagger_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/sneaker_model.dart';
import 'appstyle.dart';
import 'new_shoes.dart';

class latestShoes extends StatelessWidget {
  const latestShoes({
    super.key,
    required Future<List<Sneakers>> male,
  }): _male = male;

  final Future<List<Sneakers>> _male;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding:const EdgeInsets.only(top:10),
        child: FutureBuilder<List<Sneakers>>(
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
                //return Container();
                return  StaggeredGridView.countBuilder(
                    padding:EdgeInsets.zero,
                    crossAxisCount:2,
                    crossAxisSpacing:20,
                    mainAxisSpacing: 16,
                    itemCount:male?.length,
                    // 2 type for render list
                    // vertical, horizontal , we just understand after we do
                    // horizontal: slide ngang
                    scrollDirection: Axis.vertical,
                    staggeredTileBuilder:(index) =>
                    // config height , width base on index
                    StaggeredTile.extent(
                        (index % 2 == 0) ? 1 : 1,
                        (index % 4 == 1 || index % 4 == 3)
                            ? MediaQuery.of(context).size.height * 0.35
                            : MediaQuery.of(context).size.height * 0.33
                    ),
                    itemBuilder: (context,index){
                      final shoe = snapshot.data![index];
                      return StaggerTile(
                          imageUrl:shoe.imageUrl[1],
                          name: shoe.name,
                          price: shoe.price
                      );
                    });
              }
            }
        ),
      );
  }


}