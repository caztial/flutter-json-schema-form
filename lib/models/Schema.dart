import 'package:flutter_jsonschema/models/Properties.dart';

class Schema {
  String title;
  String type;
  String description;
  List<dynamic> required;
  List<Properties> properties;

  Schema({
    this.title,
    this.type,
    this.description,
    this.required,
    this.properties,
  });

  factory Schema.fromJson(Map<String, dynamic> json) {
    Schema newSchema = Schema(
      title: json['title'],
      type: json['type'],
      description: json['description'],
      required: json['required'],
    );
    newSchema.setProperties(json['properties'], newSchema.required);
    print(newSchema.properties);
    return newSchema;
  }

  setProperties(Map<String, dynamic> json, List<dynamic> requiredList) {
    List<Properties> props = List<Properties>();
    json.forEach((key, data) {
      bool required = true;
      if (requiredList.indexOf(key) == -1) {
        required = false;
      }
      props.add(
        Properties(
          id: key,
          type: data['type'],
          title: data['title'],
          defaultValue: data['default'],
          required: required,
        ),
      );
    });

    this.properties = props;
  }
}

