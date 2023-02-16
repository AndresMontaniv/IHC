import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({Key? key}) : super(key: key);

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = ' ?', _steps = '?';
  int _stepInit = 0, _stepHistory = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    debugPrint('$event');
    _stepHistory = event.steps;
    if (_stepInit == 0) {
      _stepInit = event.steps;
    }
    _steps = (_stepHistory - _stepInit).toString();
    _refresh();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint('$event');
    _status = event.status;
    _refresh();
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    _status = 'Pedestrian Status not available';
    _refresh();
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    _steps = 'Step Count not available';
    _refresh();
  }

  Future<void> _validatePermissionActivity() async {
    final status = await Permission.activityRecognition.request();
    //PermissionStatus[denied, permanentlyDenied]
    if (status != PermissionStatus.granted) {
      throw const FormatException('Debe aceptar los permisos de actividad');
    }
  }

  String getInit() {
    _stepInit = 0;
    return 'iniciando actividad de pasos';
  }

  String getSteps() {
    return 'actualmente llevamos $_steps pasos';
  }

  String getHistorySteps() {
    return 'hay $_stepHistory pasos en el historial';
  }

  void initPlatformState() async {
    await _validatePermissionActivity();
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                getSteps(),
                style: const TextStyle(fontSize: 30),
              ),
              Text(
                getHistorySteps(),
                style: const TextStyle(fontSize: 30),
              ),
              const Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              const Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: (_status == 'walking' || _status == 'stopped')
                      ? const TextStyle(fontSize: 30)
                      : const TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
