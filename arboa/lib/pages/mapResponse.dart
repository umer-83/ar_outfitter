import 'dart:convert';

class MapResponse {
  String type;
  List<String> query;
  List<Features> features;
  String attribution;

  MapResponse({this.type, this.query, this.features, this.attribution});

  MapResponse.fromJson(dynamic json) {
    type = json['type'];
    query = json['query'].cast<String>();
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        features?.add(new Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['query'] = this.query;
    if (this.features != null) {
      data['features'] = this.features?.map((v) => v.toJson()).toList();
    }
    data['attribution'] = this.attribution;
    return data;
  }
}

class Features {
  String id;
  String type;
  List<String> placeType;
  dynamic relevance;
  Properties properties;
  String text;
  String placeName;
  String matchingText;
  String matchingPlaceName;
  List<dynamic> bbox;
  List<double> center;
  Geometry geometry;
  List<Context> context;

  Features(
      {this.id,
      this.type,
      this.placeType,
      this.relevance,
      this.properties,
      this.text,
      this.placeName,
      this.matchingText,
      this.matchingPlaceName,
      this.bbox,
      this.center,
      this.geometry,
      this.context});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    placeType = json['place_type'].cast<String>();
    relevance = json['relevance'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    text = json['text'];
    placeName = json['place_name'];
    matchingText = json['matching_text'];
    matchingPlaceName = json['matching_place_name'];
    bbox = json['bbox'];
    center = json['center'] != null ? json['center'].cast<double>() : null;
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    if (json['context'] != null) {
      context = [];
      json['context']?.forEach((v) {
        context?.add(new Context.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['place_type'] = this.placeType;
    data['relevance'] = this.relevance;
    if (this.properties != null) {
      data['properties'] = this.properties?.toJson();
    }
    data['text'] = this.text;
    data['place_name'] = this.placeName;
    data['matching_text'] = this.matchingText;
    data['matching_place_name'] = this.matchingPlaceName;
    data['bbox'] = this.bbox;
    data['center'] = this.center;
    if (this.geometry != null) {
      data['geometry'] = this.geometry?.toJson();
    }
    if (this.context != null) {
      data['context'] = this.context?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Properties {
  String wikidata;
  String shortCode;

  Properties({this.wikidata, this.shortCode});

  Properties.fromJson(Map<String, dynamic> json) {
    wikidata = json['wikidata'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wikidata'] = this.wikidata;
    data['short_code'] = this.shortCode;
    return data;
  }
}

class Geometry {
  String type;
  List<double> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Context {
  String id;
  String wikidata;
  String shortCode;
  String text;

  Context(this.id, this.wikidata, this.shortCode, this.text);

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wikidata = json['wikidata'];
    shortCode = json['short_code'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wikidata'] = this.wikidata;
    data['short_code'] = this.shortCode;
    data['text'] = this.text;
    return data;
  }
}
