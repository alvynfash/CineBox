import 'package:flutter/material.dart';

class RankDisplayWidget extends StatelessWidget {
  final double _rank;
  final double size;

  RankDisplayWidget(this._rank, {this.size = 15});

  @override
  Widget build(BuildContext context) {
    Color _rankColor;
    Color _rankTextColor;
    double percentage;
    double roughStarCount;
    int starCount;

    if (_rank != null) {
      percentage = _rank / 10;
      roughStarCount = percentage * 5;
      starCount = roughStarCount.ceil();
    } else
      starCount = 0;

    switch (starCount) {
      case 0:
        _rankColor = Colors.transparent;
        _rankTextColor = Colors.transparent;
        break;

      case 1:
      case 2:
        _rankColor = Colors.red;
        _rankTextColor = Colors.white;
        break;

      case 3:
        _rankColor = Colors.yellow;
        _rankTextColor = Colors.black;
        break;

      case 4:
      case 5:
        _rankColor = Colors.green;
        _rankTextColor = Colors.white;
        break;
      default:
    }

    return _getStars(starCount);
  }

  Widget _getStars(int starCount) {
    var c = List<Widget>();
    const int max = 5;
    for (var i = 0; i < starCount; i++) {
      c.add(Icon(
        Icons.star,
        color: Colors.white,
        size: size,
      ));
    }

    for (var i = 0; i < max - starCount; i++) {
      c.add(Icon(
        Icons.star_border,
        color: Colors.white,
        size: size,
      ));
    }

    return new Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: c,
    );
  }
}
