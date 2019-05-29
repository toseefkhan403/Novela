import 'package:flutter/material.dart';
import 'package:arctic_pups/utils/colors.dart';
import 'package:arctic_pups/utils/cut_corners_border.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arctic_pups/utils/custom_shape_clipper.dart';
import 'package:intl/intl.dart';
import 'package:arctic_pups/flight_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arctic_pups/utils/drawer.dart';
import 'package:arctic_pups/login_page.dart';
import 'package:arctic_pups/bottom_nav_bar/fancy_tab_bar.dart';
import 'package:arctic_pups/pages/home_page.dart';
import 'package:arctic_pups/pages/profile_page.dart';
import 'package:arctic_pups/services.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(App());
  });
}

class App extends StatelessWidget {

  static final myTabbedPageKey = new GlobalKey<HomeScreenState>();

  @override
  Widget build(BuildContext context) {
    FirebaseService();
    return MaterialApp(
      title: 'Arctic Pups',
      debugShowCheckedModeBanner: false,
      home: new StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {

              //Build appropriate splash screen here
              return new Center(
                child: CircularProgressIndicator(
                ),
              );
            } else {
              if (snapshot.hasData) {
                return HomeScreen(key: myTabbedPageKey,);
              }
              return new LoginPage();
            }
          }
      ),
      theme: ThemeData(
          primaryColor: kShrinePink300,
          fontFamily: 'Raleway'
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
    App.myTabbedPageKey.currentState.tabController.animateTo(1);
  }


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
         /* bottom: TabBar(
            controller: tabController,
            tabs: myTabs,
          ),*/
          elevation: 0.0,
          backgroundColor: kShrinePink300,
          title: Text(
              "Arctic Pups", style: new TextStyle(color: kShrineBrown600),
              textAlign: TextAlign.center),
        ),
        bottomNavigationBar: FancyTabBar(),
        drawer: drawer(),
        body: new TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: <Widget>[
            HomePage(),
            _buildBody(),
            ProfilePage(),
          ]
          /*myTabs.map((Tab tab) {
            return new Center(child: new Text(tab.text));
          }).toList()*/,
        ),
      );
  }

  Widget _buildBody() {

    FirebaseAuth.instance.currentUser().then((user){
      print('this is the uid ${user.uid}');
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          HomeScreenTopPart(),
          HomeScreenServices(),
          //      HomeScreenBottomPart(),
        ],
      ),
    );
  }
}

class HomeScreenServices extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Service> arr = new List();

    arr.add(new Service(title: 'Pet Services',imagePath:"assets/images/dogCute.jpeg" ));
    arr.add(new Service(title: 'Pet Grooming',imagePath:"assets/images/dogGroom.jpeg" ));
    arr.add(new Service(title: 'Pet Vet' , imagePath: "assets/images/dogDoc.jpeg" ));
    arr.add(new Service(title: 'Pet Luxury',imagePath:"assets/images/dogLux2.jpeg" ));


    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 210.0,
        child: ServiceCard(arr),
    ),
    );

  }

}


const TextStyle dropDownLabelStyle =
TextStyle(color: Colors.white, fontSize: 16.0);
const TextStyle dropDownMenuItemStyle =
TextStyle(color: Colors.black, fontSize: 16.0);

class HomeScreenTopPart extends StatefulWidget {
  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {

  var selectedLocationIndex = 0;
  var isFlightSelected = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 380.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kShrinePink300, kShrinePink400],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
//                StreamBuilder(
//                  stream: app .locationsStream,
//                  builder: (context, snapshot) {
//                    return !snapshot.hasData
//                        ? Container()
//                        : Padding(
//                      padding: const EdgeInsets.all(16.0),
//                      child: Row(
//                        children: <Widget>[
//                          Icon(
//                            Icons.location_on,
//                            color: Colors.white,
//                          ),
//                          SizedBox(
//                            width: 16.0,
//                          ),
//                          PopupMenuButton(
//                            onSelected: (index) {
//                              app .addFromLocation
//                                  .add(app .locations[index]);
//                            },
//                            child: Row(
//                              children: <Widget>[
//                                StreamBuilder(
//                                  stream: app .fromLocationStream,
//                                  initialData: app .locations[0],
//                                  builder: (context, snapshot) {
//                                    return Text(
//                                      snapshot.data,
//                                      style: dropDownLabelStyle,
//                                    );
//                                  },
//                                ),
//                                Icon(
//                                  Icons.keyboard_arrow_down,
//                                  color: Colors.white,
//                                )
//                              ],
//                            ),
//                            itemBuilder: (BuildContext context) =>
//                                _buildPopupMenuItem(context),
//                          ),
//                          Spacer(),
//                          Icon(
//                            Icons.settings,
//                            color: Colors.white,
//                          ),
//                        ],
//                      ),
//                    );
//                  },
//                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'How can we\nhelp your pet?',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: TextField(
                      onChanged: (text) {
                      },
                      style: dropDownMenuItemStyle,
                      cursorColor: kShrinePink300,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 14.0),
                        suffixIcon: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InheritedFlightListing(
                                            child: FlightListingScreen(),
                                          )));
                            },
                            child: Icon(
                              Icons.search,
                              color: kShrineBrown600,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      child: StreamBuilder(
                        stream: null,
                        initialData: true,
                        builder: (context, snapshot) {
                          print('in hotel - ${snapshot.data}');
                          return ChoiceChip(
                              Icons.portrait, "Services", snapshot.data);
                        },
                      ),
                      onTap: () {
                      //  homeScreen .updateFlightSelection(true);
                      },
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    InkWell(
                      child: StreamBuilder(
                        stream: null,
                        initialData: true,
                        builder: (context, snapshot) {
                          print('in hotel - ${!snapshot.data}');
                          return ChoiceChip(
                              Icons.hotel, "Hotels", !snapshot.data);
                        },
                      ),
                      onTap: () {
                    //    homeScreen .updateFlightSelection(false);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Service{

  final String title,imagePath;

  Service({this.title,this.imagePath});
}

class ServiceCard extends StatelessWidget {
  final List<Service> serviceList;

  ServiceCard(this.serviceList);

  Widget _buildCard(BuildContext context,int index){

    return GestureDetector(
      onTap: (){
       /* Scaffold
            .of(context)
            .showSnackBar(SnackBar(content: Text(index.toString())));*/

        switch(index){

          case 0:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            break;
          case 1:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreenServices()));

            break;
          case 2:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreenTopPart()));

            break;
          case 3:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));

            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 210.0,
                      width: 160.0,
                      child: Image.asset(serviceList[index].imagePath,fit: BoxFit.cover,)
                  ),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 160.0,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(0.01),
                              ])),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${serviceList[index].title}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: _buildCard
        ,scrollDirection: Axis.horizontal,
      itemCount: serviceList.length,

    );
  }
}


class ChoiceChip extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  ChoiceChip(this.icon, this.text, this.isSelected);

  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      decoration: widget.isSelected
          ? BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 20.0,
            color: Colors.white,
          ),
          SizedBox(
            width: 8.0,
          ),
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }
}

var viewAllStyle = TextStyle(fontSize: 14.0, color: kShrinePink300);

class Location {
  final String name;

  Location.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        name = map['name'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}

class Services {
  String imagePath, serviceName, discount;
  
  Services(this.imagePath,this.serviceName,this.discount);

  Services.fromList(Services ls){
    imagePath = ls.imagePath;
    serviceName = ls.serviceName;
    this.discount = ls.discount;
  }

}

final formatCurrency = NumberFormat.simpleCurrency();


//Theme Data
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: kShrineColorScheme,
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: kShrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    inputDecorationTheme:
    const InputDecorationTheme(border: CutCornersBorder()),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kShrineBrown900);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
    headline: base.headline.copyWith(fontWeight: FontWeight.w500),
    title: base.title.copyWith(fontSize: 18.0),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    body2: base.body2.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
    button: base.button.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),
  )
      .apply(
    fontFamily: 'Raleway',
    displayColor: kShrineBrown900,
    bodyColor: kShrineBrown900,
  );
}

const ColorScheme kShrineColorScheme = ColorScheme(
  primary: kShrinePink100,
  primaryVariant: kShrineBrown900,
  secondary: kShrinePink50,
  secondaryVariant: kShrineBrown900,
  surface: kShrineSurfaceWhite,
  background: kShrineBackgroundWhite,
  error: kShrineErrorRed,
  onPrimary: kShrineBrown900,
  onSecondary: kShrineBrown900,
  onSurface: kShrineBrown900,
  onBackground: kShrineBrown900,
  onError: kShrineSurfaceWhite,
  brightness: Brightness.light,
);