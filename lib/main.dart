import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sharing data between screens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result;
  final textEditingController = TextEditingController(text: "Text from first screen");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sharing data between screens'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: textEditingController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'TextField',
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  OutlineButton(
                    onPressed: () => goAhead(true),
                    highlightColor: Colors.lightBlue,
                    child: Text("Standard"),
                  ),
                  OutlineButton(
                    onPressed: () => goAhead(false),
                    highlightColor: Colors.lightBlue,
                    child: Text("Using settings"),
                  ),
                ],
              ),
              Text(_result != null ? "Result from second page: '$_result'" : "")
            ]
        ),
      ),
    );
  }

  Future<void> goAhead(bool standardType) async {
    var result;
    if (standardType) {
      result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(textEditingController.text),
          )
      );
    } else {
      result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(),
            settings: RouteSettings(
              arguments: textEditingController.text,
            ),
          )
      );

    }

    if (result != null) {
      setState(() {
        _result = result;
      });
    }
  }
}

class SecondPage extends StatelessWidget {
  final String _title;
  final textEditingController = TextEditingController(text: "Text from second screen");
  SecondPage([this._title]);


  @override
  Widget build(BuildContext context) {
    final String title = _title != null ?
        _title :
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Passed data: $title"),
            TextField(
              controller: textEditingController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TextField',
              ),
            ),
            ButtonBar(
              children: <Widget>[
                OutlineButton(
                  onPressed: () => returnWithValue(context),
                  highlightColor: Colors.lightBlue,
                  child: Text("Return with value"),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  void returnWithValue(BuildContext context) {
    Navigator.pop(context, textEditingController.text);
  }
}
