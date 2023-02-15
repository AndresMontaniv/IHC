import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihc_app/widgets/widgets.dart';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
                      () => Navigator.pushNamed(context, 'environment'),
                      Colors.blue,
                      Colors.white,
                      'environment'),
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
      await _validatePermissionLocation();
      await _validateNet();
      await _validateGps();
      final pos = await Geolocator.getCurrentPosition();
      resp = await getDirecctionToStr(pos.latitude, pos.longitude);
    } on FormatException catch (e) {
      resp = e.message;
    } catch (e) {
      resp = 'Ocurrio un error inesperado, consulte a su administador';
      debugPrint('!Error <getPosToString>: ${e.toString()}');
    }
    return resp;
  }

  Future<void> _validatePermissionLocation() async {
    Object status;
    status = await Permission.location.request();
    //Permi ssionStatus[denied, permanentlyDenied]
    if (status != PermissionStatus.granted) {
      throw const FormatException('Debe aceptar los permisos de ubicacion');
    }
  }

  Future<void> _validateNet() async {
    var status = await (Connectivity().checkConnectivity());
    if (!(status == ConnectivityResult.mobile ||
        status == ConnectivityResult.wifi)) {
      throw const FormatException("Debe tener internet");
    }
  }

  Future<void> _validateGps() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    if (!isEnable) {
      throw const FormatException("Debe habilitar la Ubicacion");
    }
  }

  Future<String> getDirecctionToStr(double lat, double long) async {
    String resp, direction, street, city, department;
    List<Placemark> address;
    try {
      address = await placemarkFromCoordinates(lat, long);
      // print(address);
      if (address.isEmpty) {
        resp = 'No se pudo encontrar su direccion';
      } else {
        direction = address[0].thoroughfare!;
        street = address[0].subThoroughfare!;
        city = address[0].locality!;
        department = address[0].administrativeArea!;
        // String country = address[0].country!;
        resp = '$direction #$street, $city, $department';
      }
    } catch (e) {
      resp = '!Error <getDirecctionToStr>:  ${e.toString()}';
      throw DeferredLoadException(resp);
    }
    return resp;
  }
}
