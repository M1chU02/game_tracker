import 'package:flutter/material.dart';

void main() {
  runApp(GameTrackerApp());
}

class GameTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameListScreen(),
    );
  }
}

class Game {
  String name;
  String status;

  Game({required this.name, required this.status});
}

class GameListScreen extends StatefulWidget {
  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  final List<Game> _games = [];
  final TextEditingController _gameController = TextEditingController();

  void _addGame() {
    if (_gameController.text.isNotEmpty) {
      setState(() {
        _games.add(Game(name: _gameController.text, status: 'Want to Play'));
      });
      _gameController.clear();
    }
  }

  void _updateGameStatus(Game game) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children:
              ['Currently Playing', 'Want to Play', 'Finished'].map((status) {
            return ListTile(
              title: Text(status),
              onTap: () {
                setState(() {
                  game.status = status;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _deleteGame(Game game) {
    setState(() {
      _games.remove(game);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gameController,
                    decoration: InputDecoration(
                      labelText: 'Game Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addGame,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _games.isEmpty
                ? Center(child: Text('No games added yet'))
                : ListView.builder(
                    itemCount: _games.length,
                    itemBuilder: (context, index) {
                      final game = _games[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(game.name),
                          subtitle: Text('Status: ${game.status}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _updateGameStatus(game),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteGame(game),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
