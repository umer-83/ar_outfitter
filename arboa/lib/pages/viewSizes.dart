import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class AdvancedTilePage extends StatefulWidget {
  @override
  _AdvancedTilePageState createState() => _AdvancedTilePageState();
}

class _AdvancedTilePageState extends State<AdvancedTilePage> {
  final Stream<QuerySnapshot> sizesStream =
      FirebaseFirestore.instance.collection('sizes').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: sizesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff1C1C1C),
              title: Text(
                "Outfit Size Record",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              centerTitle: true,
              elevation: 1,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: ExpandedTileList.builder(
                itemCount: storedocs.length,
                itemBuilder: (context, index, controller) {
                  return ExpandedTile(
                    controller: index == 2
                        ? controller.copyWith(isExpanded: true)
                        : controller,
                    leading: Image(
                        image: AssetImage('images/people.png'),
                        width: 50,
                        height: 50),
                    title: Text(storedocs[index]['name'].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    contentSeperator: 4,
                    content: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Chest:",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
                                  Text(storedocs[index]['chest'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),),
                                ],
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Shoulders:",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
                                  Text(storedocs[index]['shoulder'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),),
                                ],
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Shirt Length:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                                  Text(storedocs[index]['shirt'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),),
                                ],
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sleeve Length:",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
                                  Text(storedocs[index]['sleeve'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),),
                                ],
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Pent Length:",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
                                  Text(storedocs[index]['pant'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),),
                                ],
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Pent Waist:",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,),),
                                  Text(storedocs[index]['waist'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),)
                                ],
                                ),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  );         
                       },
              ),
            ),
  
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 3,
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
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout),
                  label: 'Logout',
                ),
              ],
              selectedItemColor: Colors.blue,
            ),
          );
        });
  }

  void onChangeNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/addService');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/size');
    } else if (index == 4) {
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
