// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// class Sensor1Screen extends StatefulWidget {
//   const Sensor1Screen({Key? key, this.title}) : super(key: key);

//   final String? title;

//   @override
//   State<Sensor1Screen> createState() => _Sensor1ScreenState();
// }

// class _Sensor1ScreenState extends State<Sensor1Screen> {
//   List<double>? _accelerometerValues;
//   List<double>? _userAccelerometerValues;
//   List<double>? _gyroscopeValues;
//   List<double>? _magnetometerValues;
//   final _streamSubscriptions = <StreamSubscription<dynamic>>[];

//   @override
//   Widget build(BuildContext context) {
//     final accelerometer =
//         _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
//     final gyroscope =
//         _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
//     final userAccelerometer = _userAccelerometerValues
//         ?.map((double v) => v.toStringAsFixed(1))
//         .toList();
//     final magnetometer =
//         _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sensor Example'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Accelerometer: $accelerometer'),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('UserAccelerometer: $userAccelerometer'),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Gyroscope: $gyroscope'),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Magnetometer: $magnetometer'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     for (final subscription in _streamSubscriptions) {
//       subscription.cancel();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _streamSubscriptions.add(
//       userAccelerometerEvents.listen(
//         (UserAccelerometerEvent event) {
//           setState(() {
//             _accelerometerValues = <double>[event.x, event.y, event.z];
//           });
//         },
//       ),
//     );
//     _streamSubscriptions.add(
//       gyroscopeEvents.listen(
//         (GyroscopeEvent event) {
//           setState(() {
//             _gyroscopeValues = <double>[event.x, event.y, event.z];
//           });
//         },
//       ),
//     );
//     _streamSubscriptions.add(
//       userAccelerometerEvents.listen(
//         (UserAccelerometerEvent event) {
//           setState(() {
//             _userAccelerometerValues = <double>[event.x, event.y, event.z];
//           });
//         },
//       ),
//     );
//     _streamSubscriptions.add(
//       magnetometerEvents.listen(
//         (MagnetometerEvent event) {
//           setState(() {
//             _magnetometerValues = <double>[event.x, event.y, event.z];
//           });
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class Sensor1Screen extends StatelessWidget {
  const Sensor1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor1'),
      ),
      body: Column(
        children: const [
          Text('Sensor1Screen'),
        ],
      ),
    );
  }
}
