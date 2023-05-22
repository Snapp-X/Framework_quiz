import 'package:flutter_riverpod/flutter_riverpod.dart';

final resultProvider = Provider<Map<String, double>>((ref) => {
      '90% Flutter': 0.9,
      '8% Kotlin Multiplatform': 0.08,
      '2% Potato': 0.02,
      '0% React Native': 0.00
    });
