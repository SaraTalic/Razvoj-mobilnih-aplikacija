import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/RecipeDetail.dart';
import 'package:provider/provider.dart';
import 'package:recipe/consent/UserProvider.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<String> favoriteSaladIds = [];

  List<Map<String, dynamic>> saladsData = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteSalads();
  }

  Future<void> _loadFavoriteSalads() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.userName;

    final url = 'http://192.168.100.57/phpsalate/favorite/getFS.php';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': userName!,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        favoriteSaladIds = responseData.map((id) => id.toString()).toList();
      });

      final saladsJsonData =
          await DefaultAssetBundle.of(context).loadString('assets/salate.json');
      final saladsJson = json.decode(saladsJsonData);
      final List<dynamic> saladsList = saladsJson['salate'];

      final Map<String, Map<String, dynamic>> saladsMap = {};
      for (var salad in saladsList) {
        saladsMap[salad['id']] = salad;
      }

      setState(() {
        saladsData = favoriteSaladIds
            .map((id) => saladsMap[id])
            .where((salad) => salad != null)
            .map((salad) => salad!)
            .toList();
      });
    } else {
      // fali da dodam ako je greska
    }
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
                'Omiljene salate',
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
                  final salad = saladsData[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              RecipeDetail(salad),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.star, color: Colors.yellow)
                              ],
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
                                  image: AssetImage('images/${salad['slika']}'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            salad['ime'],
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
                              SizedBox(width: 5),
                              Text(
                                '${salad['kalorije']} kcal',
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
                                '${salad['vrijeme']} min',
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
                childCount: saladsData.length,
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
