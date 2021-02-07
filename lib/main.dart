import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Hello World',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: RandomWords(),
    );
  }
}

// #docregion RWS-var
class RandomWordsState extends State<RandomWords> {
  //final _suggestions = <WordPair>[];
  final List<WordPair> _suggestions = generateWordPairs().take(10000).toList();
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // Constructor
  RandomWordsState() {
    _searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onCleared: () {
          setState(() {
            filter = '';
          });
        },
        onChanged: (String value) {
          setState(() {
            filter = value;
          });
        },
        onClosed: () {
          setState(() {
            filter = '';
          });
        });
    filter = '';
  }

  SearchBar _searchBar;
  List<WordPair> _filteredSuggestions = <WordPair>[];

  //filter for search
  void set filter(String value) {
    if (value.isEmpty) {
      _filteredSuggestions = _suggestions;
    } else {
      String filter = value.toLowerCase();
      _filteredSuggestions = _suggestions.where((element) => element.asLowerCase.startsWith(filter)).toList();
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text('Startup Name Generator'),
      actions: [
        _searchBar.getSearchAction(context),
        IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
      ],
    );
  }

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return Divider(); /*2*/

        final index = i ~/ 2; /*3*/

        return _buildRow(_filteredSuggestions[index]);
      },
      itemCount: _filteredSuggestions.length * 2,
    );
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchBar.build(context),
      body: _buildSuggestions(),
    );
  }
  // #enddocregion RWS-build

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  // #docregion RWS-var
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
