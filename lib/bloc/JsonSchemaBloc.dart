import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_jsonschema/models/Properties.dart';
import 'dart:convert';
import 'package:rxdart/subjects.dart';
import 'package:flutter_jsonschema/models/Schema.dart';

class JsonSchemaBloc {
  Map<String, BehaviorSubject<dynamic>> _formData =
      Map<String, BehaviorSubject<dynamic>>();

  Map<String, Stream<dynamic>> formData = Map<String, Stream<dynamic>>();

  StreamController<Map<String, dynamic>> jsonDataAdd =
      StreamController<Map<String, dynamic>>();

  BehaviorSubject<Schema> _jsonSchema =
      BehaviorSubject<Schema>(seedValue: null);

  Stream<Schema> get jsonSchema => _jsonSchema;

  JsonSchemaBloc() {
    _jsonSchema.stream.listen((schema) {
      initDataBinding(schema.properties);
    });

    jsonDataAdd.stream.listen((data){
      data.forEach((key,value){
        if(_formData.containsKey(key)){
          _formData[key].add(value);
        }
      });
    });
  }

  Future<Schema> readFromFile() async {
    String content = await rootBundle.loadString('assets/testSchema.json');
    Map<String, dynamic> jsonMap = json.decode(content);
    Schema schema = Schema.fromJson(jsonMap);
    initDataBinding(schema.properties);
    return schema;
  }

  void getTestSchema() async {
    String content = await rootBundle.loadString('assets/testSchema.json');
    Map<String, dynamic> jsonMap = json.decode(content);
    _jsonSchema.add(Schema.fromJson(jsonMap));
  }

  void initDataBinding(List<Properties> properties) {
    properties.forEach((prop) {
      _formData[prop.id] = BehaviorSubject<dynamic>();
      formData[prop.id] = _formData[prop.id].stream;
      _formData[prop.id].add(prop.defaultValue);


    });
  }

  dispose() {
    _formData.forEach((key, value) {
      value.close();
    });

    _jsonSchema.close();
    jsonDataAdd.close();
  }
}
