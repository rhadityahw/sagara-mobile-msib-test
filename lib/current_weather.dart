import 'package:flutter/material.dart';

Widget currentWeather({
  required IconData icon,
  required String temp,
  required String date,
  required String location,
  Color iconColor = Colors.orange,
  double iconSize = 128.0,
}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          temp,
          style: const TextStyle(
            fontSize: 46.0,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          date,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          location,
          style: const TextStyle(fontSize: 18.0, color: Colors.grey),
        )
      ],
    ),
  );
}
