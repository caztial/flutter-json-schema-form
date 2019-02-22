import 'package:flutter/material.dart';
import 'package:flutter_jsonschema/bloc/JsonSchemaBloc.dart';
import 'package:flutter_jsonschema/common/JsonSchemaForm.dart';
import 'package:flutter_jsonschema/models/Schema.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter JsonSchema Demo';
    JsonSchemaBloc jsonSchemaBloc = JsonSchemaBloc();
    jsonSchemaBloc.getTestSchema();

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: StreamBuilder<Schema>(
          stream: jsonSchemaBloc.jsonSchema,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return JsonSchemaForm(
                schema: snapshot.data,
                jsonSchemaBloc: jsonSchemaBloc,
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}



