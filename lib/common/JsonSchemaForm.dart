import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_jsonschema/bloc/JsonSchemaBloc.dart';
import 'package:flutter_jsonschema/common/CheckboxFormField.dart';
import 'package:flutter_jsonschema/models/Properties.dart';
import 'package:flutter_jsonschema/models/Schema.dart';

class JsonSchemaForm extends StatefulWidget {
  final Schema schema;
  final JsonSchemaBloc jsonSchemaBloc;

  JsonSchemaForm({@required this.schema, this.jsonSchemaBloc});

  @override
  State<StatefulWidget> createState() {
    return _jsonSchemaForm(schema: schema, jsonSchemaBloc: jsonSchemaBloc);
  }
}

typedef JsonSchemaFormSetter<T> = void Function(T newValue);

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
            key: _formKey,
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
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Map<String, dynamic> data = Map<String, dynamic>();
                        data['submit'] = true;
                        jsonSchemaBloc.jsonDataAdd.add(data);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: jsonSchemaBloc.submitData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else {
                  return Container();
                }
              }
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
      child: TextFormField(
        onSaved: (value) {
          Map<String, dynamic> data = Map<String, dynamic>();
          data[properties.id] = value;
          jsonSchemaBloc.jsonDataAdd.add(data);
        },
        validator: (String value) {
          if (properties.required) {
            if (value.isEmpty) {
              return 'Required';
            }
          }
        },
        decoration: InputDecoration(
          hintText:
              properties.defaultValue != null ? properties.defaultValue : '',
          labelText:
              properties.required ? properties.title + ' *' : properties.title,
        ),
      ),
    );
  }

  Widget getCheckBox(Properties properties) {
    return StreamBuilder(
      stream: jsonSchemaBloc.formData[properties.id],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CheckboxFormField(
            autoValidate: false,
            initialValue: snapshot.data,
            title: properties.title,
            validator: (bool val) {
              if (properties.required) {
                if (!val) {
                  return "Required";
                }
              }
            },
            onSaved: (bool val) {},
            onChange: (val) {
              Map<String, dynamic> data = Map<String, dynamic>();
              data[properties.id] = val;
              jsonSchemaBloc.jsonDataAdd.add(data);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    jsonSchemaBloc.dispose();
  }
}
