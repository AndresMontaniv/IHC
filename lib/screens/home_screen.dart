import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  _HomeScreenState() {
    AlanVoice.addButton(
      '248a9bbe9688fcab42c7133779c438ef2e956eca572e1d8b807a3e2338fdd0dc/stage',
      buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
    );

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command['command']) {
      case 'increment':
        incrementCounter();
        _deactivateAlan();
        break;
      default:
        debugPrint('Unknoen command');
    }
  }

  //* Activate Alan Button programmatically
  void _activateAlan() {
    AlanVoice.activate();
  }

  //* Deactivate Alan Button programmatically
  void _deactivateAlan() {
    AlanVoice.deactivate();
  }

  

  void sendData() async {
    var isActive = await AlanVoice.isActive();
    if (!isActive) {
      _activateAlan();
    }
    var params = jsonEncode({'count': counter});
    debugPrint(params);
    await AlanVoice.callProjectApi('script::getCount', params);
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _activateAlan,
            icon: const Icon(Icons.bug_report),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have pushed the button this many times'),
            Text(
              counter.toString(),
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          incrementCounter();
          sendData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
