import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persist Theme'),
      ),
      body: ListView(
        children: MediaQuery.of(context).size.width >= 480
            ? <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Flexible(child: DarkModeSwitch()),
              Flexible(child: TrueBlackSwitch()),
            ],
          ),
          CustomThemeSwitch(),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Flexible(child: PrimaryColorPicker()),
              Flexible(child: AccentColorPicker()),
            ],
          ),
          DarkAccentColorPicker(),
        ]
            : <Widget>[
          DarkModeSwitch(),
          TrueBlackSwitch(),
          CustomThemeSwitch(),
          PrimaryColorPicker(),
          AccentColorPicker(),
          DarkAccentColorPicker(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _theme.accentColor,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}