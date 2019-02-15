import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:flutter_jsonschema/models/Schema.dart';

class JsonSchemaBloc{

  Future<Schema> readFromFile() async{
    String content = await rootBundle.loadString('assets/testSchema.json');
    Map<String, dynamic> jsonMap =json.decode(content);
    return Schema.fromJson(jsonMap);
  }


}