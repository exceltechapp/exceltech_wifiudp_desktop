import 'package:flutter/material.dart';

class appBar_ extends StatefulWidget {
  const appBar_(
      {
      this.bgColor,
      this.centerTitle,
      this.title,
      this.actions,
      this.leading});
  final Color? bgColor;
  final bool? centerTitle;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  @override
  State<appBar_> createState() => _appBar_State();
}

class _appBar_State extends State<appBar_> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.bgColor,
      centerTitle: widget.centerTitle,
      title: widget.title,
      actions: widget.actions,
      leading: widget.leading,
    );
  }
}
