import 'package:flutter_riverpod/flutter_riverpod.dart';

final resultProvider = Provider<Map<String, dynamic>>((ref) => {
      '90% Flutter': {
        'percentage': 0.9,
        'description': 'assets/flutter_icon.png',
      },
      '8% Kotlin Multiplatform': {
        'percentage': 0.08,
        'description': 'assets/kmm_icon.png',
      },
      '2% Potato': {
        'percentage': 0.02,
        'description': 'assets/potato_icon.png',
      },
      '0% React Native': {
        'percentage': 0.00,
        'description': 'assets/react_native_icon.png',
      },
    });
