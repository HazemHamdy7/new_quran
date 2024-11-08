import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _fontSize = 22.0;
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _fontSize,
      min: 18.0,
      max: 40.0,
      divisions: 11,
      label: _fontSize.round().toString(),
      onChanged: (newSize) {
        setState(() {
          _fontSize = newSize;
        });
      },
    );
  }
}
