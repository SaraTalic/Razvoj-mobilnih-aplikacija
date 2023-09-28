import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/consent/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:recipe/screen/login.dart';
import 'package:recipe/screen/favorite.dart';
import 'package:recipe/consent/appbar.dart';

class Profil extends StatelessWidget {
  Profil({Key? key});

  _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Odjava'),
          content: Text('Da li ste sigurni da želite da se odjavite?'),
          actions: <Widget>[
            TextButton(
              child: Text('Ne'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Da'),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  _navigateToFavorite(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Favorite()));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName;

    return Scaffold(
      backgroundColor: background,
      appBar: appbar(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              'Zdravo, $userName!',
              style: TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 40,
                thickness: 2,
              ),
            ),
            ListTile(
              onTap: () {
                _navigateToFavorite(context);
              },
              leading: Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    _navigateToFavorite(context);
                  },
                  child: Icon(Icons.star, color: maincolor),
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    _navigateToFavorite(context);
                  },
                  child: Text(
                    'Omiljene salate',
                    style: TextStyle(fontSize: 17, color: font),
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              ),
            ),
            ListTile(
              onTap: () {
                _showLogoutDialog(context);
              },
              leading: Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.logout, color: maincolor),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Odjavi se',
                  style: TextStyle(fontSize: 17, color: font),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
