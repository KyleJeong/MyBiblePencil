import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:math';

class DeviceUtils {
  static Future<bool> isTablet() async {
    final deviceInfo = DeviceInfoPlugin();
    
    if (Theme.of(navigatorKey.currentContext!).platform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model.toLowerCase().contains('ipad');
    } else {
      final androidInfo = await deviceInfo.androidInfo;
      final size = MediaQuery.of(navigatorKey.currentContext!).size;
      final diagonal = sqrt(size.width * size.width + size.height * size.height);
      print('Screen size: ${size.width}x${size.height}');
      print('Diagonal size: $diagonal');
      print('Android model: ${androidInfo.model}');
      // 태블릿 기준을 600dp로 낮춤 (일반적인 태블릿 최소 너비)
      return size.width >= 600;
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 