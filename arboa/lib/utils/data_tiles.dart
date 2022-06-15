import 'package:ar_outfitter/model/model_tiles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final advancedTiles = <AdvancedTile>[
  AdvancedTile(
    icon: Icons.person,
    title: 'Salman Mustafa',
    tiles: [
      AdvancedTile(title: 'Chest:  18 inch'),
      AdvancedTile(title: 'Shoulders:'),
      AdvancedTile(title: 'Waist:'),
      AdvancedTile(title: 'Shirt Length:'),
      AdvancedTile(title: 'Sleeve Length:'),
      AdvancedTile(title: 'Pant Length:'),
     
    ],
  ),
  AdvancedTile(
    icon: Icons.person,
    title: 'Tariq Khan',
    tiles: [
      AdvancedTile(title: 'Chest:  18 inch'),
      AdvancedTile(title: 'Shoulders:'),
      AdvancedTile(title: 'Waist:'),
      AdvancedTile(title: 'Shirt Length:'),
      AdvancedTile(title: 'Sleeve Length:'),
      AdvancedTile(title: 'Pant Length:'),
    ],
  ),
  AdvancedTile(
    icon: Icons.person,
    title: 'Farhan',
    tiles: [
      AdvancedTile(title: 'Chest:  18 inch'),
      AdvancedTile(title: 'Shoulders: 22 inch'),
      AdvancedTile(title: 'Waist: 14inch'),
      AdvancedTile(title: 'Shirt Length: 35 inch'),
      AdvancedTile(title: 'Sleeve Length:30 inch'),
      AdvancedTile(title: 'Pant Length: 40 inch'),
    ],
  ),
];