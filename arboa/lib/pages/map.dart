import 'dart:convert';
import 'package:ar_outfitter/pages/mapResponse.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';


class MapScreenPage extends StatefulWidget {
  final Function callback;
  const MapScreenPage({Key key, this.callback}) : super(key: key);

  @override
  _MapScreenPageState createState() => _MapScreenPageState();
}

class _MapScreenPageState extends State<MapScreenPage> {
  List<Features> autoCompleteOption = [];
  final apiKey = dotenv.env['MAP_BOX_KEY'];

  TextEditingController searchController = TextEditingController();

  void OnSelectLocation(Features feature) {
    widget.callback(feature);
    FocusScope.of(context).unfocus();
    setState(() {
      searchController.clear();
    });
    Navigator.pop(context, '/home');
  }

  Future placesSearch(String apiKey, String query) async {
    Response response = await Dio().get(
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${query}.json?access_token=${apiKey}&language=en');

    Map<String, dynamic> jsonObject = jsonDecode(response.data);
    MapResponse mapRes = MapResponse.fromJson(jsonObject);

    setState(() {
      autoCompleteOption = mapRes.features;
    });
  }

  Future<void> getPlacesRecommendations(query) async {
    await placesSearch(apiKey, query).catchError(print);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1C1C1C),
          title: Text("Find at your near location", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 4,
        ),
        backgroundColor: Color(0xFFFFFFFF),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(children: [
            FlutterMap(
              options: MapOptions(
                center: LatLng(33.6844, 73.0479),
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/hina2002/cku5s0o422vy817o52kgnoodz/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGluYTIwMDIiLCJhIjoiY2t1NW83NDE5MXhtZDJ1cWdsajJ1bDc1aCJ9.FlqSXqmSo1TdN-Ksn3-9Bg",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiaGluYTIwMDIiLCJhIjoiY2t1NW83NDE5MXhtZDJ1cWdsajJ1bDc1aCJ9.FlqSXqmSo1TdN-Ksn3-9Bg',
                    'id': "mapbox.mapbox-streets-v8"
                  },
                  attributionBuilder: (_) {
                    return Text("© OpenStreetMap contributors");
                  },
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 35.0,
                      height: 35.0,
                      point: LatLng(24.8607, 67.0011),
                      builder: (ctx) => Container(
                        child: Image(image: AssetImage("images/marker.png")),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(0, 3),
                        blurRadius: 6)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextFormField(
                controller: searchController,
                onChanged: (string) {
                  getPlacesRecommendations(string);
                },
                decoration: InputDecoration(
                  hintText: 'Enter your location',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1)),
                  contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1)),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 1)),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 65, left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(0, 3),
                          blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Features feature;
                      int placeLength = 0;
                      if (autoCompleteOption != null) {
                        feature = autoCompleteOption[index];
                        if (feature?.placeName?.length != null) {
                          placeLength = feature.placeName.length > 35
                              ? 35
                              : feature.placeName?.length;
                        }
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey.shade400,
                            onSurface: Colors.grey.shade50,
                            shadowColor: Colors.white,
                            elevation: 0),
                        onPressed: () {
                          OnSelectLocation(feature);
                        },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                            child: Row(children: [
                              Icon(Icons.location_on,
                                  color: Colors.grey.shade400),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 250,
                                    child: Text('${feature?.text}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          overflow: TextOverflow.fade,
                                        )),
                                  ),
                                  Container(
                                    width: 250,
                                    child: Text(
                                        '${feature?.placeName?.substring(0, placeLength)}...',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade400)),
                                  ),
                                ],
                              )
                            ])),
                      );
                    },
                    itemCount: autoCompleteOption?.length))
          ]),
        ));
  }
}
