import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihc_app/widgets/widgets.dart';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class DarwinScreen extends StatelessWidget {
  const DarwinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Darwin'),
          backgroundColor: const Color.fromARGB(255, 12, 17, 156),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Center(
              child: SafeArea(
                  child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  _buttonRequest(
                      context,
                      () async => debugPrint(await getPosToString()),
                      Colors.black,
                      Colors.white,
                      'donde estoy!'),
                  const SizedBox(
                    height: 10,
                  ),
                  _buttonRequest(
                      context,
                      () => Navigator.pushNamed(context, 'pedometer'),
                      Colors.grey,
                      Colors.white,
                      'pedometer'),
                  const SizedBox(
                    height: 10,
                  ),
                  _buttonRequest(
                      context,
                      () => Navigator.pushNamed(context, 'sensor'),
                      Colors.blue,
                      Colors.white,
                      'sensor'),
                  // const SizedBox(height: 10,),
                  // _buttonRequest(context, (){Vibration.vibrate(duration: 1000);}, Colors.blueGrey, Colors.black, 'vibrar'),
                  // _buttonRequest(context, (){Vibration.vibrate(pattern: [0, 1000, 1000, 2000]);}, Colors.blueGrey, Colors.black, 'vibrar'),
                  const SizedBox(
                    height: 10,
                  ),
                  _buttonRequest(
                      context,
                      () => Navigator.pushNamed(context, 'flash'),
                      Colors.yellow,
                      Colors.black,
                      'flash'),
                ],
              )),
            )
          ],
        ));
  }

  Widget _buttonRequest(BuildContext context, Function? function, Color color,
      Color textColor, String text) {
    return Container(
      height: 50,
      width: 200,
      alignment: Alignment.bottomCenter,
      // margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: BtnSolicit(
        onPressed: function,
        text: text,
        color: color,
        textColor: textColor,
      ),
    );
  }

  Future<String> getPosToString() async {
    String resp;
    try {
      // final isGranted = await Permission.location.isGranted;
      // debugPrint('isGranted: $isGranted');
      //askGpsAccess------------------------
      final status = await Permission.location.request();
      debugPrint('status: $status');
      switch (status) {
        case PermissionStatus.granted:
          final posicionActual = await Geolocator.getCurrentPosition();
          resp = await getDirecctionToString(
              posicionActual.latitude, posicionActual.longitude);
          return resp;
        case PermissionStatus.denied:          
          break;
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
        case PermissionStatus.permanentlyDenied:
          // add(GpsAndPermissionEvent(
          //   isGpsEnable: state.isGpsEnable,
          //   isGpsPermissionGranted: false,
          // ));
          openAppSettings();
      }
      resp = 'no acepto permisos';
    } catch (e) {
      resp = 'error <getPosToString>  ${e.toString()}';
    }
    return resp;
  }

  Future<String> getDirecctionToString(
      double latitude, double longitude) async {
    String resp;
    try {
      List<Placemark> address =
          await placemarkFromCoordinates(latitude, longitude);
      // print(address);
      if (address.isEmpty) {
        resp = 'sin direcciones';
      } else {
        String direction = address[0].thoroughfare!;
        String street = address[0].subThoroughfare!;
        String city = address[0].locality!;
        String department = address[0].administrativeArea!;
        // String country = address[0].country!;
        resp = '$direction #$street, $city, $department';
      }
    } catch (e) {
      resp = 'Error <getDirecctionToString>:  ${e.toString()}';
      throw FormatException(e.toString());
    }
    return resp;
  }
}
