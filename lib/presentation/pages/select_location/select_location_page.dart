// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
// import 'package:gas_delivery_app/presentation/pages/select_location/select_location_page_controller.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';

// enum StatusLocation { update, add }

// class SelectLocationPage extends GetView<AddressPageController> {
//   final StatusLocation statusLocation;
//   const SelectLocationPage({super.key, required this.statusLocation});

//   void _onMapCreated(GoogleMapController googleMapController) {
//     controller.mapController = googleMapController;
//     ever(controller.currentPosition, (LatLng position) {
//       googleMapController.animateCamera(
//         CameraUpdate.newLatLngZoom(position, 14),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(AddressPageController());
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         appBar: NormalAppBar(title: "SelectLocation".tr, backIcon: true),
//         body: Stack(
//           children: [
//             Obx(
//               () => GoogleMap(
//                 padding: const EdgeInsets.only(bottom: 120),
//                 myLocationButtonEnabled: true,
//                 myLocationEnabled: true,
//                 onMapCreated: _onMapCreated,
//                 onTap: controller.onMapTap,
//                 initialCameraPosition: CameraPosition(
//                   target: controller.currentPosition.value,
//                   zoom: 14,
//                 ),
//                 markers: controller.markers.value,
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Obx(
//                       () => Text(
//                         controller.selectedAddress.value.isEmpty
//                             ? "SelectLocationPrompt".tr
//                             : controller.selectedAddress.value,
//                         style: Get.textTheme.titleLarge?.copyWith(
//                           color: controller.selectedAddress.value.isEmpty
//                               ? ColorManager.colorGrey2
//                               : ColorManager.colorBlack,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Obx(
//                       () => AppButton(
//                         loadingMode:
//                             controller.loadingState.value ==
//                             LoadingState.loading,
//                         onPressed: controller.saveSelectedLocation,
//                         text: "Continue".tr,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
