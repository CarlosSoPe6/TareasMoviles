import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _actionIconColor = true;
  var _clickCounter = 0;
  var _color = Colors.white;
  var _icon = Icons.star_border;

  Future<void> _showSelectionDialog(String content, BuildContext ctx) async {
    await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text("Snackbar Action"),
            content: Text("La fecha y hora son:\n $content"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Click the FAB'),
        actions: [
          IconButton(
              icon: Icon(_icon, color: _color),
              onPressed: () {
                var icon;
                var color;
                var actionIconColor = !_actionIconColor;
                var clickCounter = _clickCounter + 1;
                if (!actionIconColor) {
                  icon = Icons.star;
                  color = Colors.red[300];
                } else {
                  icon = Icons.star_border;
                  color = Colors.white;
                }
                setState(() {
                  _actionIconColor = actionIconColor;
                  _clickCounter = clickCounter;
                  _icon = icon;
                  _color = color;
                });
                var snackBar;
                if(actionIconColor) {
                  snackBar = SnackBar(content: Text("Snackbar text"), action: SnackBarAction(label: "Abrir diálogo", onPressed: () {
                    var currentTime = DateTime.now();
                    var fecha = currentTime.toIso8601String();
                    _showSelectionDialog(fecha, context);
                  }));
                } else {
                  snackBar = SnackBar(content: Text("Snackbar text"));
                }
                _scaffoldKey.currentState.hideCurrentSnackBar();
                _scaffoldKey.currentState.showSnackBar(snackBar);
              })
        ],
      ),
      body: Container(
          child: Center(
        child: Container(
          child: Text('Clicks $_clickCounter'),
        ),
      )),
    );
  }
}
