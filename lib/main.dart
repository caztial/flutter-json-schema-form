import 'package:flutter/material.dart';
import 'package:flutter_jsonschema/bloc/JsonSchemaBloc.dart';
import 'package:flutter_jsonschema/models/Properties.dart';
import 'package:flutter_jsonschema/models/Schema.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'JsonSchema Form Demo';
    JsonSchemaBloc jsonSchemaBloc = JsonSchemaBloc();
    jsonSchemaBloc.getTestSchema();
    //StreamBuilder<Schema>(stream: jsonSchemaBloc.jsonSchema, builder: (context, snapshot){},);
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

class JsonSchemaForm extends StatefulWidget {
  final Schema schema;
  final JsonSchemaBloc jsonSchemaBloc;

  JsonSchemaForm({@required this.schema, this.jsonSchemaBloc});

  @override
  State<StatefulWidget> createState() {
    return _jsonSchemaForm(schema: schema, jsonSchemaBloc: jsonSchemaBloc);
  }
}

class _jsonSchemaForm extends State<JsonSchemaForm> {
  final Schema schema;
  final _formKey = GlobalKey<FormState>();
  final JsonSchemaBloc jsonSchemaBloc;

  _jsonSchemaForm({@required this.schema, this.jsonSchemaBloc});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Form(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            schema.title != null ? schema.title : '',
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Container(
                          child: Text(
                            schema.description != null
                                ? schema.description
                                : '',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: schema.properties.map<Widget>((item) {
                        return getWidget(item);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: schema.properties.map<Widget>((item) {
                return StreamBuilder(
                  stream: jsonSchemaBloc.formData[item.id],
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          item.id + ": '" + snapshot.data.toString() + "'");
                    } else {
                      return Text(item.id + ": ''");
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getWidget(Properties properties) {
    switch (properties.type) {
      case 'string':
        return getTextField(properties);
      case 'boolean':
        return getCheckBox(properties);
      default:
        return Container();
    }
  }

  Widget getTextField(Properties properties) {
    return Container(
      child: TextField(
        onChanged: (value) {
          Map<String, dynamic> data = Map<String, dynamic>();
          data[properties.id] = value;
          jsonSchemaBloc.jsonDataAdd.add(data);
        },
        decoration: InputDecoration(
          hintText:
              properties.defaultValue != null ? properties.defaultValue : '',
          labelText: properties.title,
        ),
      ),
    );
  }

  Widget getCheckBox(Properties properties) {
    return StreamBuilder(
      stream: jsonSchemaBloc.formData[properties.id],
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            children: <Widget>[
              CheckboxListTile(
                value: snapshot.data,
                title: new Text(properties.title),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (val) {
                  Map<String, dynamic> data = Map<String, dynamic>();
                  data[properties.id] = val;
                  jsonSchemaBloc.jsonDataAdd.add(data);
                },
              ),
            ],
          );
        }else{
          return Container();
        }

      },
    );
  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
