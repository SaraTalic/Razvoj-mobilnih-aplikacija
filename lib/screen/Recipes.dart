import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/RecipeDetail.dart';

class Recipes extends StatefulWidget {
  final String selectedCategory;

  const Recipes({Key? key, required this.selectedCategory}) : super(key: key);

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  List<dynamic> recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final String data =
        await DefaultAssetBundle.of(context).loadString('assets/salate.json');
    final Map<String, dynamic> jsonData = json.decode(data);
    final List<dynamic> salate = jsonData['salate'];

    final filteredRecipes = salate
        .where((recipe) => recipe['kategorija'] == widget.selectedCategory)
        .toList();

    setState(() {
      recipes = filteredRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: maincolor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                '# ${widget.selectedCategory}',
                style: TextStyle(
                  fontSize: 20,
                  color: font,
                  fontFamily: 'ro',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RecipeDetail(recipes[index]),
                        ),
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
                                      'images/${recipes[index]['slika']}'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            recipes[index]['ime'],
                            style: TextStyle(
                              fontSize: 18,
                              color: font,
                              fontFamily: 'ro',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 15),
                              Image.asset(
                                'images/calorie.png',
                                height: 20,
                                width: 20,
                              ),
//SizedBox(width: 5),
                              // SizedBox(width: 5),
                              Text(
                                recipes[index]['kalorije'] + ' kcal',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: 'ro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.asset(
                                'images/clock.png',
                                height: 16,
                                width: 16,
                              ),
                              SizedBox(width: 5),
                              Text(
                                recipes[index]['vrijeme'] + ' min',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontFamily: 'ro',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: recipes.length,
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
