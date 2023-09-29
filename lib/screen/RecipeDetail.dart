import 'package:flutter/material.dart';
import 'package:recipe/screen/home.dart';
import 'package:recipe/consent/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RecipeDetail extends StatefulWidget {
  final Map<String, dynamic> recipe;

  RecipeDetail(this.recipe);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  bool isFavorite = false;
  Color favoriteColor = Colors.yellow;
  Color notFavoriteColor = Colors.grey;
  Color starColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.userName;

    final url = 'http://192.168.100.57/phpsalate/favorite/isFS.php';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': userName!,
        'id_salate': widget.recipe['id'].toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      setState(() {
        isFavorite = responseData == 'Yes';
        starColor = isFavorite ? favoriteColor : notFavoriteColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userName = userProvider.userName;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'images/${widget.recipe['slika']}',
                  fit: BoxFit.cover,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: 80,
                        height: 4,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                        starColor =
                            isFavorite ? favoriteColor : notFavoriteColor;
                      });
                      _updateFavoriteStatus(
                          userName!, int.parse(widget.recipe['id']));
                    },
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                      radius: 18,
                      child: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        size: 25,
                        color: starColor,
                      ),
                    ),
                  ),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                  radius: 18,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _getBody(),
            )
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      widget.recipe['ime'],
                      style: TextStyle(
                        fontSize: 30,
                        color: const Color.fromARGB(255, 17, 17, 17),
                        fontFamily: 'ro',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Image.asset(
                      'images/calories.png',
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${widget.recipe['kalorije']} kalorija',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontFamily: 'ro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'images/clock.png',
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${widget.recipe['vrijeme']} minuta',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontFamily: 'ro',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildExpansionTile('Sastojci', widget.recipe['kolicine']),
              _buildExpansionTile('Priprema', widget.recipe['opis']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontFamily: 'ro',
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontFamily: 'ro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFavoriteStatus(String userName, int recipeId) async {
    final url = 'http://192.168.100.57/phpsalate/favorite/updateFS.php';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': userName,
        'id_salate': recipeId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = response.body;
      if (responseData == 'Success') {
        print('Recept je uspješno dodan ili uklonjen iz omiljenih.');
        setState(() {
          isFavorite = !isFavorite;
          starColor = isFavorite ? favoriteColor : notFavoriteColor;
        });
      } else if (responseData == 'Error') {
        print('Greška pri dodavanja ili uklanjanja recepta iz omiljenih.');
      }
    } else {
      print('Greska.');
    }
  }
}
