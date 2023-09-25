import 'package:flutter/material.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/recipe.dart';
import 'dart:convert';
import 'package:recipe/screen/RecipeDetail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indexx = 1;
  List category = ['All', 'Lunch', 'Dinner', 'Breakfast'];
  List categoryname = ['dinner', 'lunch', 'dinner', 'fast'];
  List<dynamic> food = [];

  Future<List<dynamic>> loadSalads() async {
    var data = await DefaultAssetBundle.of(context).loadString('assets/salate.json');
    return json.decode(data)['salate'];
  }

  @override
  void initState() {
    super.initState();
    loadSalads().then((salate) {
      setState(() {
        food = salate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: appbar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                'Prijedlozi mjeseca',
                style: TextStyle(
                  fontSize: 20,
                  color: font,
                  fontFamily: 'ro',
                ),
              ),
            ),
          ),
         
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RecipeDetail(food[index])),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 185, 185, 185),
                            offset: Offset(1, 1),
                            blurRadius: 15,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Icon(Icons.favorite_border)],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/${food[index]['slika']}'), // Postavljamo sliku iz JSON-a
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            food[index]['ime'],
                            style: TextStyle(
                              fontSize: 18,
                              color: font,
                              fontFamily: 'ro',
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '100 min',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                  fontFamily: 'ro',
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: maincolor, size: 15),
                                  Text(
                                    '4.2',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontFamily: 'ro',
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: 4,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 270,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
