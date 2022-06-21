import 'package:flutter/material.dart';
import 'package:ar_outfitter/pages/map.dart';
import 'package:ar_outfitter/pages/mapResponse.dart';
import 'package:ar_outfitter/pages/viewDetails.dart';
import 'package:ar_outfitter/utils/data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String title;
  final List<ServiceCardData> data;

  const HomePage({Key key, this.title, this.data}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  List<ServiceCardData> listData = [];

  @override
  void initState() {
    super.initState();
    controller.clear();
    setState(() {
      listData = widget.data;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
  }

  void callBackToGetLocation(Features feature) {
    print("home page ${feature?.placeName}");
  }

  void onChangeNavigation(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/addService');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/size');
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/details');
    }else if (index == 4) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6E6E6),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
              padding: EdgeInsetsDirectional.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Home',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller,
                          onChanged: (string) {
                            dynamic filteredList = widget.data
                                .where((ServiceCardData element) => element
                                    .company_name
                                    .toLowerCase()
                                    .contains(string.toLowerCase()))
                                .toList();

                            setState(() {
                              listData = filteredList;
                            });
                          },
                          style: TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                            hintText: 'Search Outfit Store',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                            suffixIcon: controller.text.length > 0
                                ? IconButton(
                                    onPressed: () {
                                      controller.text = '';
                                      setState(() {
                                        listData = widget.data;
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: Icon(Icons.clear))
                                : Icon(Icons.search),
                          ),
                          cursorColor: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(controller.text);
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Tooltip(
                              message: 'Search by Location',
                              child: IconButton(
                                icon: Icon(
                                  Icons.location_pin,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                             MapScreenPage(
                                                 callback:
                                                      callBackToGetLocation)));
                                },
                              )),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 3.0,
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 0),
                      width: double.infinity,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final currentItem = listData[index];
                          return SearchedCards(context, currentItem);
                        },
                        itemCount: listData.length,
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: onChangeNavigation,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Store Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.boy_rounded),
            label: 'Sizes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Details',
          ),BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        selectedItemColor: Colors.blue,
      ),
    );
  }
}

Widget SearchedCards(context, ServiceCardData currentItem) {
  return (Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Color(0xFFF5F5F5),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.blue.shade100,
            child: Image.network(
              currentItem.cover_image,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, -0.15),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        '${currentItem.company_name}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF151B1E),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.1, -0.05),
                        child: Text(
                          currentItem.rating.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      RatingBarIndicator(
                        itemBuilder: (context, index) => Icon(
                          Icons.star_rounded,
                          color: Color(0xFFfaaf00),
                        ),
                        direction: Axis.horizontal,
                        rating: (currentItem.rating / 5.0),
                        unratedColor: Color(0xFF9E9E9E),
                        itemCount: 1,
                        itemSize: 18,
                      )
                    ],
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Text(
              currentItem.description.length > 80
                  ? "${currentItem.description.substring(0, 80)}..."
                  : '${currentItem.description}',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 13),
            ),
          ),
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ViewProfileDetails(
                                        currentItem: currentItem)));
                      },
                      child:
                          Text("View Details", style: TextStyle(fontSize: 12)),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blue)))))
                ],
              ))
        ],
      )));
}
// TODO Implement this library.