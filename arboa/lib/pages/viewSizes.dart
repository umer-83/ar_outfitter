
import 'package:cloud_firestore/cloud_firestore.dart';
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
        backgroundColor: Colors.white,
              title: Text(
                "Sizes Detail",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
      ),
      body: ExpandedTileList.builder(
        itemCount: storedocs.length,
        
        itemBuilder: (context, index, controller) {
          return ExpandedTile(
            
            controller:
                index == 2 ? controller.copyWith(isExpanded: true) : controller,
            title: Text(storedocs[index]['name'].toString()),
            
            content: Container(
              
              child: Column(
                children: [
                  ListTile(title: Text("Chest: "+ storedocs[index]['chest'].toString())),
                  ListTile(title: Text("Shoulders: "+ storedocs[index]['shoulder'].toString())),
                  ListTile(title: Text("Waist: "+ storedocs[index]['waist'].toString())),
                  ListTile(title: Text("Shirt Length: "+ storedocs[index]['shirt'].toString())),
                  ListTile(title: Text("Sleeve Length: "+ storedocs[index]['sleeve'].toString())),
                  ListTile(title: Text("Pant Length: "+ storedocs[index]['pant'].toString())),
                  
                 
                ],
              ),
            ),
            
            );
            },
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
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
