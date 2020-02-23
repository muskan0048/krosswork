import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  Color color;
  double height, weight;

  VerticalDivider(this.color, this.height, this.weight);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: color),
        height: height,
        width: weight,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  Color color;
  double height, weight;

  HorizontalDivider(this.color, this.height, this.weight);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: color),
        height: height,
        width: weight,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      ),
    );
  }
}
