import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/screen/RecipeDetail.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> food = [];

  @override
  void initState() {
    super.initState();
    loadSalads();
  }

  Future<void> loadSalads() async {
    var data =
        await DefaultAssetBundle.of(context).loadString('assets/salate.json');
    setState(() {
      food = json.decode(data)['salate'];
    });
  }

  double calculateMatchPercentage(String searchText, String recipeIngredients) {
  List<String> searchIngredients =
      searchText.toLowerCase().split(',').map((s) => s.trim()).toList();
  List<String> recipeIngredientsList =
      recipeIngredients.toLowerCase().split(',').map((s) => s.trim()).toList();

  int totalIngredients = searchIngredients.length;
  int matchedIngredients = 0;

  for (String searchIngredient in searchIngredients) {
    if (recipeIngredientsList.contains(searchIngredient)) {
      matchedIngredients++;
    }
  }

  return (matchedIngredients / totalIngredients) * 100;
}


  void performSearch(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    searchResults = food
        .where((recipe) =>
            calculateMatchPercentage(
                  searchText.toLowerCase(),
                  recipe['sastojci'],
                ) > 0.0)
        .toList();

    // Sortiranje rezultata prema postotku
    searchResults.sort((a, b) {
      double matchA =
          calculateMatchPercentage(searchText.toLowerCase(), a['sastojci']);
      double matchB =
          calculateMatchPercentage(searchText.toLowerCase(), b['sastojci']);
      return matchB.compareTo(matchA);
    });

    setState(() {});
  }

  List<dynamic> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 185, 185, 185),
                        offset: Offset(1, 1),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (text) {
                      // Ovdje obavljamo pretragu kada korisnik pritisne Enter
                      performSearch(text);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Unesi sastojke koje imas',
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final recipe = searchResults[index];
                    final matchPercentage = calculateMatchPercentage(
                        searchController.text.toLowerCase(),
                        recipe['sastojci']);
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RecipeDetail(recipe),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
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
                                          'images/${recipe['slika']}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  recipe['ime'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: font,
                                    fontFamily: 'ro',
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(width: 115),
                                    Image.asset(
                                      'images/calorie.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                    Text(
                                      '${recipe['kalorije']} kcal',
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
                                      '${recipe['vrijeme']} min',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontFamily: 'ro',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Podudaranje: ${matchPercentage.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 196, 30, 30),
                                    fontFamily: 'ro',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: searchResults.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
