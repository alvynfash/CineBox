import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> items = List.generate(200, (i) => i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        title: Text('CineBox'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.black,
        child: _buildList(context),
      ),
    );
  }

  Widget _getWelcomeBlock(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100.0,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Text(
              'Get started',
              style: Theme.of(context).primaryTextTheme.headline,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 10.0),
            child: Text(
              'Welcome! Use this app to watch movies & TV shows.',
              style: Theme.of(context).primaryTextTheme.subhead,
            ),
          ),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _getRecommendedHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Text(
        'Recommended',
        style: Theme.of(context).primaryTextTheme.title,
      ),
    );
  }

  Widget _getRecommendedList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListView.separated(
            itemCount: items.length,
            itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  color: Color.fromARGB(255, 33, 33, 33),
                  child: Container(
                    height: 320.0,
                    child: Stack(
                      children: <Widget>[
                        _getMovieImage(context),
                        _getThumbbnail(context),
                        _getMovieDetails(context)
                      ],
                    ),
                  ),
                ),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            separatorBuilder: (context, index) => Divider(height: 1),
          ),
        ],
      ),
    );
  }

  Widget _getThumbbnail(BuildContext context) {
    return Container(
      color: Colors.black,
      width: 80,
      margin: const EdgeInsets.fromLTRB(10, 180, 0, 10),
    );
  }

  Widget _getMovieDetails(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(100, 210, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'XXX xxx xxxxxxxxx xxx',
            style: TextStyle(fontSize: 21, color: Colors.white),
          ),
          Text(
            '3.5 *',
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
          Container(
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'ADD TO WISHLIST',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMovieImage(BuildContext context) {
    return Container(
      height: 200,
      color: Color.fromARGB(255, 255, 216, 216),
    );
  }

  Widget _buildList(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _getWelcomeBlock(context),
                _getRecommendedHeader(context),
                _getRecommendedList(context),
              ],
            )
          ]),
        )
      ],
    );
  }
}
