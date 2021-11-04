import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class Background extends StatelessWidget {
  final double height, width;

  const Background({Key? key, this.height = 150, this.width = 500})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    int alpha = 85;
    int alpha2 = 85;
    int alpha3 = 85;

    return RotatedBox(
      quarterTurns: 2,
      child: WaveWidget(
        config: CustomConfig(
          gradients: [
            [
              // AppConfig.of(context).appColor.withAlpha(10),
              // AppConfig.of(context).appColor.withAlpha(20),
              // AppConfig.of(context).appColor.withAlpha(30),

              Colors.green.withAlpha(alpha),
              Colors.lightGreen.withAlpha(alpha),
              Colors.lightGreen.shade600.withAlpha(alpha)
            ],
            [
              Colors.green.withAlpha(alpha),
              Colors.lightGreenAccent.shade700.withAlpha(alpha)
            ],
            [
              const Color(0xFF7abf36).withAlpha(alpha),
              const Color(0xFFadf268).withAlpha(alpha),
              const Color(0xFF7abf36).withAlpha(alpha),
              //
              //
            ],
            [
              Colors.green.withAlpha(alpha),
              Colors.greenAccent.shade700.withAlpha(alpha)
              //
              //
            ],
          ],
          durations: [19440, 10800, 6000, 25345],
          heightPercentages: [0.08, 0.06, 0.05, 0.02],
          gradientBegin: Alignment.bottomCenter,
          gradientEnd: Alignment.topCenter,
        ),
        // size: Size(double.infinity, double.infinity),
        size: Size(width, height),

        waveAmplitude: 25,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
