import 'package:flutter/material.dart';

class textFieldForm extends StatefulWidget {
  const textFieldForm(
      {
        required this.obscureText,
        required this.labelText,
        this.controller,
        this.icon,
        this.inputType, this.validator, this.onChanged});
  final bool obscureText;
  final String labelText;
  final Widget? icon;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  @override
  State<textFieldForm> createState() => _textFieldState();
}

class _textFieldState extends State<textFieldForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: TextFormField(
        onChanged: widget.onChanged,
        validator:widget.validator,
        keyboardType: widget.inputType,
        cursorColor: Color.fromRGBO(0, 165, 146, 1),
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          floatingLabelStyle: TextStyle(color: Color.fromRGBO(0, 165, 146, 1)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(0, 165, 146, 1))),
          border: const OutlineInputBorder(),
          labelText: widget.labelText,
          suffixIcon: widget.icon,
          hintText: 'Enter ${widget.labelText}',
        ),
      ),
    );
  }
}
