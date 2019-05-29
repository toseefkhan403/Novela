import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arctic_pups/login_page.dart';

class drawer extends StatefulWidget {
  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Text('toseef')
            , accountEmail: Text('blah@gmail.com'),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
              ),
            ),
          ),

          //body
          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('My Orders'),
              leading: Icon(Icons.shop),
            ),
          ),

          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('Favourites'),
              leading: Icon(Icons.favorite,color: Colors.red,),
            ),
          ),

          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('CATegories'),
              leading: Icon(Icons.dashboard),
            ),
          ),

          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('My Pets'),
              leading: Icon(Icons.pets,color: kShrineBrown900,),
            ),
          ),

          Divider(),

          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings,color: kShrineBrown900,),
            ),
          ),

          InkWell(
            onTap: (){},
            child: ListTile(
              title: Text('About'),
              leading: Icon(Icons.help, color: Colors.blue,),
            ),
          ),
          InkWell(
            onTap: (){
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));

            },
            child: ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app, color: kShrineBrown900,),
            ),
          ),

        ],
      ),
    );
  }
}
