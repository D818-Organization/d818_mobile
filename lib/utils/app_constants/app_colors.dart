import 'package:flutter/material.dart';

class AppColors {
  static Color scaffoldBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color lighterGrey = fromHex('#F3F3F3');

  static Color lightGrey = fromHex('#D9D9D9');

  static Color regularGrey = Colors.grey;

  static Color coolRed = fromHex('#ED1C24');

  static Color kPrimaryColor = fromHex('#ED1C24');

  // static Color kPrimaryColor = fromHex('#FE6225');

  static Color fullBlack = fromHex('#111111');

  static Color amber = fromHex('#FFAD0D');

  static Color darkGrey = fromHex('#7e1a1818');

  static Color blueGray = fromHex('#6cd3dde7');

  static Color plainWhite = fromHex('#ffffff');

  static Color regularBlue = fromHex('#037FFF');

  static Color normalGreen = Colors.green.shade900;

  static Color transparent = Colors.transparent;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
