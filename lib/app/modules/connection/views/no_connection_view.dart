import 'package:flutter/material.dart';

class NoConnectionView extends StatelessWidget {
  const NoConnectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 100,
                color: Color(0xFFCDE7BE),
              ),
              SizedBox(height: 20),
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Gotham',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}