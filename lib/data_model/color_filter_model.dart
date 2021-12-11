// To parse this JSON data, do
//
//     final filterColorModel = filterColorModelFromJson(jsonString);

import 'dart:convert';

List<String> filterColorModelFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String filterColorModelToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
