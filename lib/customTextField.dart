import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
      this.hint,
      this.obsecure = false,
      this.validator,
      this.onSaved,
      this.labelText});
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final String labelText;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        autofocus: true,
        obscureText: obsecure,
        style: TextStyle(
          color: Color(0xFFEEEEEE),
          fontSize: 20,
        ),
        decoration: InputDecoration(
            fillColor: Color(0xFF121212),
            filled: true,
            labelText: labelText,
            labelStyle: TextStyle(color: Color(0xFFEEEEEE)),
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFD6D6D6)),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[350],
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.grey[350],
                width: 3,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Color(0xFF009999),
                width: 2,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Color(0xFF009999)),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }
}
