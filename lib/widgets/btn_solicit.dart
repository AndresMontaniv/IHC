import 'package:flutter/material.dart';

class BtnSolicit extends StatelessWidget {

  final Color color;
  final Color textColor;
  final String text;
  final IconData icon;
  final Function? onPressed;

  const BtnSolicit({
    Key? key, 
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    this.onPressed,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed!();
      },
      style: ElevatedButton.styleFrom(
        primary: color, // background
        onPrimary: textColor, // foreground
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                  text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.yellow,
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 203, 206, 218),
                ),
              ),
            ),
          )
        ],
      ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(15)
      // ),
    );
  }
}
