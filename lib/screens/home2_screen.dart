import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:ihc_app/helpers/helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;
  late ShakeDetector detector;
  Map<String, String> contact = {
    'name': 'Darwin Mamani',
    'phone': '59172182712',
    'email': 'darwinjr40@gmail.com',
  };
  Map<String, String> personalInfo = {
    'name': 'Andres Montano',
    'phone': '59175684756',
    'email': 'amontano.user@gmail.com',
  };

  _HomeScreenState() {
    AlanVoice.addButton(
      '248a9bbe9688fcab42c7133779c438ef2e956eca572e1d8b807a3e2338fdd0dc/stage',
    );

    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command['command']) {
      case 'increment':
        incrementCounter();
        sendSOSAlert();
        break;
      default:
        debugPrint('Unknown Command');
    }
    // _deactivateAlan();
  }

  void _activateAlan() {
    AlanVoice.activate();
  }

  void _deactivateAlan() {
    AlanVoice.deactivate();
  }

  void _playText(String text) async {
    if (!await AlanVoice.isActive()) {
      AlanVoice.activate();
    }
    AlanVoice.playText(text);
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

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
    playResp = await _sendSMS(location);

    playResp += '.\n';
    //? Sending Email
    playResp += await sendEmail(location);

    _playText('All Good');
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        // _activateAlan();
        _playText('Still Alive yes');
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: incrementCounter,
              child: Text('Counter $counter'),
            ),
            ElevatedButton(
              onPressed: () {
                // _sendSMS();
              },
              child: const Text('Send SMS'),
            ),
            ElevatedButton(
              onPressed: () {
                // sendEmail();
              },
              child: const Text('Send Email'),
            ),
            ElevatedButton(
              onPressed: () {
                sendSOSAlert();
              },
              child: const Text('SOS'),
            ),
          ],
        ),
      ),
    );
  }
}
