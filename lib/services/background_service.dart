import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shake/shake.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:alan_voice/alan_voice.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:ihc_app/helpers/helpers.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'package:flutter_background_service/flutter_background_service.dart'
    show
        AndroidConfiguration,
        FlutterBackgroundService,
        IosConfiguration,
        ServiceInstance;

//* Variables

final service = FlutterBackgroundService();
ShakeDetector? detector;
int counter = 0;
int steps = 0;
bool isCountingSteps = false;
Map<String, String> contact = {
  'name': 'Ross Geller',
  'phone': '59172182712',
  'email': 'montanoa63@gmail.com',
};
Map<String, String> personalInfo = {
  'name': 'Andres Montano',
  'phone': '59175684756',
  'email': 'amontano.user@gmail.com',
};

//* Background Service Config

Future initializeService() async {
  _initAll();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  await service.startService();
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('FLUTTER BACKGROUND FETCH');
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  _initAll();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) async {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
      );
    }
    _startListening();
    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        "counter": counter,
      },
    );
  });
}

void _initAll() async {
  AlanVoice.addButton(
    '248a9bbe9688fcab42c7133779c438ef2e956eca572e1d8b807a3e2338fdd0dc/stage',
  );

  AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  detector = ShakeDetector.autoStart(
    onPhoneShake: () {
      _activateAlan();
      // _handleCommand({'command': 'increment'});
    },
  );
}

void _stopAll() {
  _deactivateAlan();
  _stopListening();
}

//* Shake Detector Config
void _startListening() async {
  detector?.startListening();
}

void _stopListening() async {
  detector?.stopListening();
}

//* Alan Ai Voice Config
Future<void> _activateAlan() async {
  if (!await AlanVoice.isActive()) {
    AlanVoice.activate();
  }
}

Future<void> _deactivateAlan() async {
  if (await AlanVoice.isActive()) {
    AlanVoice.deactivate();
  }
}

void _playText(String text) async {
  await _activateAlan();
  AlanVoice.playText(text);
}

void speak() {
  AlanVoice.playText('Hi from flutter');
}

//? Handle Commands
void _handleCommand(Map<String, dynamic> command) {
  print('Llego a handle=> $command');
  switch (command['command']) {
    case 'increment':
      incrementCounter();
      break;
    case 'sos':
      sendSOSAlert();
      break;
    case 'location':
      runLocationCommand();
      break;
    case 'start_step_count':
      startCountingSteps();
      break;
    case 'stop_step_count':
      stopCountingSteps();
      break;
    case 'get_step_count':
      getStepsCount();
      break;
    case 'shut_down':
      _stopAll();
      break;
    default:
      debugPrint('Unknown Command');
  }
}

//* Commands Operations

//? Test Command
void incrementCounter() {
  counter++;
}

//? Send SOS Command
Future<String> _sendSMS(String location) async {
  String msg = """
    Hola ${contact['name']?.split(' ').first}, esto una emergencia, te comparto mi ubicacion.\n
    https://maps.google.com/?q=$location \n
    Att.- ${personalInfo['name']} via Lingoo App
    """;
  try {
    bool isDenied = await Permission.sms.isDenied;
    if (isDenied) {
      var status = await Permission.sms.request();
      if (PermissionStatus.permanentlyDenied == status) {
        await openAppSettings();
      }
      isDenied = await Permission.sms.isDenied;
      if (isDenied) {
        return 'Error!, SMS permission disabled';
      }
    }
    String? recipient = contact['phone'];
    if (recipient == null) {
      return 'Error!, No contact phone number';
    }
    return await sendSMS(
      message: msg,
      recipients: [recipient],
      sendDirect: true,
    );
  } catch (e) {
    debugPrint(e.toString());
    return 'Error sending message';
  }
}

Future<String> sendEmail(String location) async {
  try {
    const serviceId = 'service_hfdcdgp';
    const templateId = 'template_jvjafia';
    const userId = 'MDsUtWxIECjP5mdWV';
    String htmlMsg = buildEmailHtml(
      personalInfo['name'],
      contact['name'],
      location,
    );

    if (!contact.containsKey('email')) {
      return 'Error!, contact email not found';
    }

    if (!personalInfo.containsKey('email')) {
      return 'Error!, personal email not found';
    }

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': personalInfo['name'],
          'to_name': contact['name'],
          'user_email': personalInfo['email'],
          'to_email': contact['email'],
          'my_html': htmlMsg,
          'user_subject': 'Lingoo : Modo SOS Activado - Urgente',
        }
      }),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return 'Email Sent Successfuly';
    } else {
      return 'Error sending email';
    }
  } catch (e) {
    debugPrint(e.toString());
    return 'Error sending email';
  }
}

void sendSOSAlert() async {
  print('entro al case');
  String playResp = '';
  //* Get Permissions
  bool isLocationDenied = await Permission.location.isDenied;
  if (isLocationDenied) {
    var status = await Permission.location.request();
    if (PermissionStatus.permanentlyDenied == status) {
      await openAppSettings();
    }
    isLocationDenied = await Permission.location.isDenied;
    if (isLocationDenied) {
      _playText('Error!, Location permission disabled');
      return;
    }
  }
  final isGpsEnable = await Geolocator.isLocationServiceEnabled();
  if (!isGpsEnable) {
    _playText('Error!, gps is not enabled in the phone');
    return;
  }
  //* Get user location
  Position userPosition = await Geolocator.getCurrentPosition();
  debugPrint(userPosition.toJson().toString());
  String location = '${userPosition.latitude},${userPosition.longitude}';

  //? Sending SMS
  // playResp = await _sendSMS(location);

  // playResp += '.\n';
  //? Sending Email
  playResp += await sendEmail(location);

  _playText(playResp);
}

//* Location Command
void runLocationCommand() async {
  final res = await InternetConnectionChecker().hasConnection;
  if (!res) {
    _playText('No Internet');
  }

  //! Aqui poner el codigo de get location en String
  _playText('Calle 1, Santa Cruz de la Sierra');
}

//* Pedometer Commands

void startCountingSteps() {
  steps = 0;
  isCountingSteps = true;
}

void stopCountingSteps() {
  _playText('Stoping Count, You walked $steps steps');
  isCountingSteps = false;
}

void getStepsCount() {
  steps = DateTime.now().hour;
  _playText('You have walked $steps steps');
}