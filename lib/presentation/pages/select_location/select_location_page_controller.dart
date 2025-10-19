// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:gas_delivery_app/core/services/cache_service.dart';
// import 'package:gas_delivery_app/core/services/permission_service.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/data/models/position_model.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';

// class AddressPageController extends GetxController {
//   PermissionService permissionService = Get.find<PermissionService>();
//   CacheService cacheService = Get.find<CacheService>();
//   GoogleMapController? mapController;
//   final Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
//   final loadingState = LoadingState.idle.obs;
//   final Rx<LatLng> currentPosition = Rx<LatLng>(
//     const LatLng(33.513778530945466, 36.27656523117847),
//   );
//   final RxString selectedAddress = ''.obs;
//   // Default fallback location (e.g., Damascus, Syria)
//   static const LatLng defaultLocation = LatLng(
//     33.513778530945466,
//     36.27656523117847,
//   );

//   @override
//   void onInit() {
//     final arguments = Get.arguments;
//     if (arguments != null && arguments is LatLng) {
//       updateMarkerAndCamera(arguments.latitude, arguments.longitude);
//     } else {
//       getCurrentLocation();
//     }
//     super.onInit();
//   }

//   void getCurrentLocation() async {
//     loadingState.value = LoadingState.loading;
//     if (!(await permissionService.checkLocationServiceAndPermission(
//       retries: 60,
//     ))) {
//       await updateMarkerAndCamera(
//         defaultLocation.latitude,
//         defaultLocation.longitude,
//       );
//       return;
//     }
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         // ignore: deprecated_member_use
//         desiredAccuracy: LocationAccuracy.high,
//         locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
//       );
//       currentPosition.value = LatLng(position.latitude, position.longitude);
//       await updateMarkerAndCamera(
//         currentPosition.value.latitude,
//         currentPosition.value.longitude,
//       );
//     } catch (e) {
//       loadingState.value = LoadingState.hasError;
//       CustomToasts(
//         message: "ErrorFetchingLocation".tr,
//         type: CustomToastType.error,
//       ).show();
//       await updateMarkerAndCamera(
//         defaultLocation.latitude,
//         defaultLocation.longitude,
//       );
//     }
//   }

//   Future<void> updateMarkerAndCamera(double latitude, double longitude) async {
//     try {
//       loadingState.value = LoadingState.loading;
//       currentPosition.value = LatLng(latitude, longitude);
//       var addressCoordinate = await getAddressFromCoordinate(
//         currentPosition.value,
//       );
//       markers.value = {
//         Marker(
//           markerId: MarkerId('CurrentLocation'.tr),
//           position: currentPosition.value,
//           infoWindow: InfoWindow(
//             title: 'CurrentLocation'.tr,
//             snippet: addressCoordinate,
//           ),
//         ),
//       };
//       markers.refresh(); // Ensure UI updates
//       selectedAddress.value = addressCoordinate;
//       if (mapController != null) {
//         await mapController!.animateCamera(
//           CameraUpdate.newLatLngZoom(currentPosition.value, 14),
//         );
//       }
//       loadingState.value = LoadingState.doneWithData;
//     } catch (e) {
//       loadingState.value = LoadingState.hasError;
//       CustomToasts(
//         message: "ErrorUpdatingLocation".tr,
//         type: CustomToastType.error,
//       ).show();
//     }
//   }

//   Future<String> getAddressFromCoordinate(LatLng latLng) async {
//     try {
//       List<Placemark> placeMarks = await placemarkFromCoordinates(
//         latLng.latitude,
//         latLng.longitude,
//       );
//       if (placeMarks.isNotEmpty) {
//         final placeMark = placeMarks.first;
//         final address =
//             '${placeMark.street ?? ''}, ${placeMark.locality ?? ''}, ${placeMark.country ?? ''}'
//                 .trim();
//         return address;
//       }
//       return '${latLng.latitude} , ${latLng.longitude}';
//     } catch (e) {
//       return '${latLng.latitude} , ${latLng.longitude}';
//     }
//   }

//   void saveSelectedLocation() async {
//     if (loadingState.value == LoadingState.loading) {
//       return;
//     }
//     final long = currentPosition.value.longitude;
//     final lat = currentPosition.value.latitude;
//     if (long == 0 || lat == 0) {
//       CustomToasts(
//         message: "YouNeedToSelectLocation".tr,
//         type: CustomToastType.warning,
//       ).show();
//       return;
//     }
//     PositionModel selectedLocation = PositionModel(
//       latLng: LatLng(lat, long),
//       id: 0,
//       title: selectedAddress.value,
//     );
//     Get.back(result: selectedLocation);
//   }

//   void onMapTap(LatLng position) async {
//     loadingState.value = LoadingState.loading;
//     currentPosition.value = position;
//     markers.value = {
//       Marker(
//         markerId: MarkerId('SelectedLocation'.tr),
//         position: position,
//         infoWindow: InfoWindow(
//           title: 'SelectedLocation'.tr,
//           snippet: await getAddressFromCoordinate(position),
//         ),
//       ),
//     };
//     markers.refresh(); // Ensure UI updates
//     try {
//       selectedAddress.value = await getAddressFromCoordinate(position);
//       if (mapController != null) {
//         await mapController!.animateCamera(
//           CameraUpdate.newLatLngZoom(position, 14),
//         );
//       }
//       loadingState.value = LoadingState.doneWithData;
//     } catch (e) {
//       loadingState.value = LoadingState.hasError;
//       CustomToasts(
//         message: "ErrorUpdatingMap".tr,
//         type: CustomToastType.error,
//       ).show();
//     }
//   }

//   @override
//   void onClose() {
//     mapController?.dispose();
//     super.onClose();
//   }
// }
