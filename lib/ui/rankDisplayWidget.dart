import 'package:flutter/material.dart';

class RankDisplayWidget extends StatelessWidget {
  final double _rank;

  RankDisplayWidget(this._rank);

  @override
  Widget build(BuildContext context) {
    Color _rankColor;
Color _rankTextColor;

    var percentage = _rank / 10;
    var roughStarCount = percentage * 5;
    var starCount = roughStarCount.ceil();

    switch (starCount) {
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

    return Row(
      children: <Widget>[
        CircleAvatar(
          maxRadius: 15,
          backgroundColor: _rankColor,
          foregroundColor: _rankTextColor,
          child: Text(
            "${_rank.toString()}",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: _getStars(starCount),
        ),
      ],
    );
  }

  Widget _getStars(int starCount) {
    var c = List<Widget>();

    for (var i = 0; i < starCount; i++) {
      c.add(Icon(
        Icons.star,
        color: Colors.deepOrange,
        size: 25,
      ));
    }
    return new Row(
      children: c,
    );
  }
}
