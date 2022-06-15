import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvancedTile {
  String id;
  String title;
  IconData icon;
  List<AdvancedTile> tiles;
  bool isExpanded;
  Timestamp createdAt;
  Timestamp updatedAt;

 

  AdvancedTile({
    @required this.title,
    this.id,
    this.icon,
    this.tiles = const [],
    this.isExpanded = false,
  });
  AdvancedTile.fromMap(Map<String, dynamic> data, this.id, this.title, this.icon, this.tiles) {
    id = data['id'];
    title = data['name'];
    icon = data['icon'];
    tiles = data['list'];
    isExpanded = data['expand'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'icon': icon,
      'expand': isExpanded,
      'list': tiles,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }


}
