import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../utils/fonts.dart';
import '../utils/style.dart';
import '../utils//colors.dart';

class InputField extends StatefulWidget {
  InputField(
      {this.label,
      this.controller,
      this.onChanged,
      this.validator,
      this.textInputType});
  final TextEditingController controller;
  final TextInputType textInputType;
  final String label;
  final Function onChanged;
  final Function validator;
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  Color focusColor = ColorRefer.kGreyColor;
  final _focusNode = FocusNode();
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kGreyColor;
        });
      } else {
        setState(() {
          focusColor = Colors.black;
        });
      }
    });
  }

  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: StyleRefer.kTextFieldDecoration.copyWith(
              labelText: widget.label,
              labelStyle: TextStyle(
                  fontSize: 15,
                  fontFamily: FontRefer.OpenSans,
                  color: ColorRefer.kGreyColor)),
        ),
      ]),
    );
  }
}



// ignore: must_be_immutable
class PasswordField extends StatefulWidget {
  PasswordField(
      {this.label,
      this.controller,
      this.onChanged,
      this.validator,
      this.obscureText,
      this.textInputType});
  final TextEditingController controller;
  final TextInputType textInputType;
  final String label;
  final Function onChanged;
  final Function validator;
  bool obscureText;
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  Color focusColor = ColorRefer.kGreyColor;
  final _focusNode = FocusNode();
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kGreyColor;
        });
      } else {
        setState(() {
          focusColor = Colors.black;
        });
      }
    });
  }

  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _togglePasswordStatus() {
      setState(() {
        print(widget.obscureText);
        widget.obscureText = !widget.obscureText;
      });
    }

    return Container(
      child: Column(children: [
        TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: StyleRefer.kTextFieldDecoration.copyWith(
            labelText: widget.label,
            labelStyle: TextStyle(
                fontSize: 15,
                fontFamily: FontRefer.OpenSans,
                color: ColorRefer.kGreyColor),
            suffixIcon: IconButton(
              icon: Icon(
                  widget.obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: _togglePasswordStatus,
              color: ColorRefer.kGreyColor,
            ),
          ),
        ),
      ]),
    );
  }
}

class SelectDateField extends StatefulWidget {
  SelectDateField({this.hint, this.label, this.onChanged, this.controller});
  final String hint;
  final String label;
  final Function onChanged;
  final TextEditingController controller;
  @override
  _SelectDateFieldState createState() => _SelectDateFieldState();
}

class _SelectDateFieldState extends State<SelectDateField> {
  Color focusColor = ColorRefer.kGreyColor;
  final _focusNode = FocusNode();
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kGreyColor;
        });
      } else {
        setState(() {
          focusColor = ColorRefer.kGreyColor;
        });
      }
    });
  }

  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          Theme(
            data: theme.brightness == Brightness.light ? ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(primary: ColorRefer.kOrangeColor)
            ) : ThemeData.dark().copyWith(

              colorScheme: ColorScheme.dark                                                                                                                                                                                                          (primary: ColorRefer.kOrangeColor),
            ),
            child: DateTimePicker(
              controller: widget.controller,
              focusNode: _focusNode,
              initialDate: DateTime(DateTime.now().subtract(Duration(days: 365 * 18)).year, DateTime.now().month, DateTime.now().day),
              type: DateTimePickerType.date,
              dateMask: 'yyyy/MM/dd',
              use24HourFormat: false,
              firstDate: DateTime(1950),
              style: TextStyle(
                color: theme.brightness == Brightness.light ? Colors.black : Colors.white,
              ),
              lastDate: DateTime(DateTime.now().subtract(Duration(days: 365 * 18)).year, DateTime.now().month, DateTime.now().day),
              decoration: StyleRefer.kTextFieldDecoration.copyWith(
                contentPadding: EdgeInsets.only(top: 15),
                hintText: widget.hint,
                hintStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: FontRefer.OpenSans,
                    color: ColorRefer.kGreyColor),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Icon(
                    CupertinoIcons.calendar,
                    color: ColorRefer.kGreyColor,
                    size: 25,
                  ),
                ),
              ),
              selectableDayPredicate: (date) {
                return true;
              },
              onChanged: widget.onChanged,
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val) => print(val),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectBox extends StatefulWidget {
  SelectBox({this.label, this.selectionList, this.onChanged, this.value});
  final String label;
  final List<String> selectionList;
  final Function onChanged;
  final String value;
  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  Color focusColor = ColorRefer.kGreyColor;
  final _focusNode = FocusNode();
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kGreyColor;
        });
      } else {
        setState(() {
          focusColor = ColorRefer.kDarkColor;
        });
      }
    });
  }

  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: DropdownButton<String>(
              isExpanded: true,
              value: widget.value,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              icon: Icon(
                Icons.expand_more_outlined,
                color: ColorRefer.kGreyColor,
              ),
              style: TextStyle(
                  color: ColorRefer.kDarkColor, fontFamily: FontRefer.OpenSans),
              hint: Text(
                widget.label,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontRefer.OpenSans,
                    color: ColorRefer.kDarkColor),
              ),
              underline: Container(
                height: 2,
                color: ColorRefer.kDarkColor,
              ),
              items: widget.selectionList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Divider(
            color: focusColor,
            height: 3,
          ),
        ],
      ),
    );
  }
}
