import 'package:ar_outfitter/utils/data_tiles.dart';
import 'package:ar_outfitter/main.dart';
import 'package:ar_outfitter/model/model_tiles.dart';
import 'package:ar_outfitter/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdvancedTilePage extends StatefulWidget {
  @override
  _AdvancedTilePageState createState() => _AdvancedTilePageState();
}

class _AdvancedTilePageState extends State<AdvancedTilePage> {
       final Stream<QuerySnapshot> sizesStream =
      FirebaseFirestore.instance.collection('sizes').snapshots();
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,
         title: Text("Sizes Detail", style: TextStyle(color: Colors.black),),
     
          centerTitle: true,
        ),
        
        body: SingleChildScrollView(
          
          child: ExpansionPanelList.radio(
            expansionCallback: (index, isExpanded) {
              final tile = advancedTiles[index];
              setState(() => tile.isExpanded = isExpanded);

            },
            children: advancedTiles
                .map((tile) => ExpansionPanelRadio(
                      value: tile.title,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) => buildTile(tile),
                      body: Column(
                        children: tile.tiles.map(buildTile).toList(),
                      ),
                    ))
                .toList(),
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
            label: 'Add Profile',
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
      ));}
      

  Widget buildTile(AdvancedTile tile) => ListTile(
        leading: tile.icon != null ? Icon(tile.icon) : null,
        title: Text(tile.title),
      
      );
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