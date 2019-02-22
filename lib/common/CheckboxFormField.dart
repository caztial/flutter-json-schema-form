import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool initialValue = false,
    VoidCallback onChange(bool value),
    String title = '',
    bool autoValidate = false,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autoValidate,
          builder: (FormFieldState<bool> state) {
            if (state.hasError) {
              return CheckboxListTile(
                value: initialValue,
                title: Text(title),
                subtitle: Text(
                  'Required',
                  style: TextStyle(color: Color(0xFFd32f2f)),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool value) {
                  state.didChange(value);
                  onChange(value);
                },
              );
            } else {
              return CheckboxListTile(
                value: initialValue,
                title: Text(title),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool value) {
                  state.didChange(value);
                  onChange(value);
                },
              );
            }
          },
        );
}
