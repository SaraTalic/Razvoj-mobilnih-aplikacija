import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/Recipes.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final String data = await DefaultAssetBundle.of(context)
        .loadString('assets/kategorije.json');
    final Map<String, dynamic> jsonData = json.decode(data);
    final List<dynamic> kategorije = jsonData['kategorije'];

    for (var item in kategorije) {
      categories.add(item['kategorija']);
    }

    setState(() {});
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
                'Kategorije',
                style: TextStyle(
                  fontSize: 20,
                  color: font,
                  fontFamily: 'ro',
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Recipes(
                            selectedCategory: categories[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 206, 239, 216),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/${categories[index]}.png',
                            height: 100,
                            width: 100,
                          ),
                          SizedBox(height: 20),
                          Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'ro',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: categories.length,
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
