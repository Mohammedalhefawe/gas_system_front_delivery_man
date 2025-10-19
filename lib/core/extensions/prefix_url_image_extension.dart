import 'package:gas_delivery_app/core/services/network_service/api.dart';

extension ImageUrlExtension on String? {
  String get withImagePrefix {
    if (this == null || this!.isEmpty) return '';
    if (this!.startsWith('http://') || this!.startsWith('https://')) {
      return this!;
    }

    return '${Api.imageBaseUrl}${this!}';
  }
}
