import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff23192d),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Logging you in \n',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  letterSpacing: 1.4,
                ),
              ),
              SpinKitFoldingCube(
                color: Colors.white,
                size: 30.0,
              ),
            ],
          ),
        )
    );
  }
}
