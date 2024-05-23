import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moroccan_explorer/ui/pages/Second_city.dart';
import 'package:moroccan_explorer/ui/pages/besty.dart';
import 'package:moroccan_explorer/ui/widgets/app.bar.dart';
import 'package:moroccan_explorer/ui/widgets/drawer.widget.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';


// ignore: must_be_immutable
class HomePage extends StatelessWidget
{
  final FirebaseAuth _auth = FirebaseAuth.instance;
    void _handleCityTap(BuildContext context, String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondPage(cityName: cityName)),
);
}
void _handleCategoryTap(BuildContext context, String category) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Besty(categoryName: category)),
);
}
 var category = ['Best Places','Most Visited','New Added'];
  final List<String> cityNames = ["Casablanca", "Rabat", "Chefchaouen", "Fez", "Tanger","Essaouira"];
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      // drawer: MyDrawer(),
       drawer: MyDrawer(
        user: _auth.currentUser, // Passez l'utilisateur actuel au Drawer
      ),
      // appBar: AppBar(title: Text('Home')),
    //  body: Center(child: Text('Meteo page' , style: Theme.of(context).textTheme.headline3)),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child : HomeAppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: SingleChildScrollView(
          child: Column( 
            children: [
                Row(
                  children: [
                    
                    Expanded(child: Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: cityNames.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context , int index )
                      {
                        return InkWell(
                           onTap: () {
                          // Utiliser l'index pour personnaliser l'action pour chaque image
                          _handleCityTap(context,cityNames[index]);
                        },
                            child: Container(
                              width: 160,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: AssetImage("images/city${index+1}.jpg"),
                                      fit: BoxFit.cover,
                                      opacity: 0.7,
                                  ),
                    
                              ),
                              child : Column(
                                children: [
                                  Spacer(),
                                      Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(cityNames[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600, 
                                          ),
                                          
                                          ),
                                      ),

                              ],
                              ),
                            ),
                        );
                      }
                      ),
                    )
                    ),
                  ],
                ),
            SizedBox(height: 20),
            SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          InkWell(
                            onTap: () {
                              _handleCategoryTap(context, category[i]);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                category[i],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            SizedBox(height: 10),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
              return Padding(padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  InkWell(
                       onTap: () {
                          // Utiliser l'index pour personnaliser l'action pour chaque image
                          _handleCityTap(context,cityNames[index]);
                        },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage("images/city${index + 1}.jpg"),
                            fit: BoxFit.cover,
                            opacity: 0.8,
                  
                          ),
                  
                        ),
                       ),
                  
                  
                  ),
                   Padding(
                padding:EdgeInsets.only(top: 10),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                          Text(cityNames[index],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,

                          ),
                          ),
                        // Icon(
                        //   Icons.more_vert,
                        //   size: 40
                        // ),
                    ],
              ),
              ),
              SizedBox(height: 5),
             
                ],
              ),
             
              );
            })
            ],
            ),
          ),
          ),
    ),

    bottomNavigationBar: HomeBottomBar(),
    );

}
}










