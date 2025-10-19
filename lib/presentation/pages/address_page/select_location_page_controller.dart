import 'package:flutter/material.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/core/services/permission_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/address_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';

class AddressPageController extends GetxController {
  final PermissionService permissionService = Get.find<PermissionService>();
  final CacheService cacheService = Get.find<CacheService>();
  GoogleMapController? mapController;
  final Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
  final loadingState = LoadingState.idle.obs;
  final Rx<LatLng> currentPosition = Rx<LatLng>(
    const LatLng(33.513778530945466, 36.27656523117847),
  );
  final RxString selectedAddress = ''.obs;
  final LatLng? initialPosition;
  static const LatLng defaultLocation = LatLng(
    33.513778530945466,
    36.27656523117847,
  );

  // Text controllers for form fields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController floorNumberController = TextEditingController();
  final TextEditingController addressNameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  AddressPageController({this.initialPosition});

  @override
  void onInit() {
    if (initialPosition != null) {
      updateMarkerAndCamera(
        initialPosition!.latitude,
        initialPosition!.longitude,
      );
      // Pre-fill fields if updating an existing address
      if (Get.arguments is AddressModel) {
        final address = Get.arguments as AddressModel;
        addressController.text = address.address;
        cityController.text = address.city;
        floorNumberController.text = address.floorNumber ?? '';
        addressNameController.text = address.addressName ?? '';
        detailsController.text = address.details ?? '';
      }
    } else {
      getCurrentLocation();
    }
    super.onInit();
  }

  void getCurrentLocation() async {
    loadingState.value = LoadingState.loading;
    if (!(await permissionService.checkLocationServiceAndPermission(
      retries: 60,
    ))) {
      await updateMarkerAndCamera(
        defaultLocation.latitude,
        defaultLocation.longitude,
      );
      return;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      currentPosition.value = LatLng(position.latitude, position.longitude);
      await updateMarkerAndCamera(
        currentPosition.value.latitude,
        currentPosition.value.longitude,
      );
    } catch (e) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: "ErrorFetchingLocation".tr,
        type: CustomToastType.error,
      ).show();
      await updateMarkerAndCamera(
        defaultLocation.latitude,
        defaultLocation.longitude,
      );
    }
  }

  Future<void> updateMarkerAndCamera(double latitude, double longitude) async {
    try {
      loadingState.value = LoadingState.loading;
      currentPosition.value = LatLng(latitude, longitude);
      var addressCoordinate = await getAddressFromCoordinate(
        currentPosition.value,
      );
      markers.value = {
        Marker(
          markerId: MarkerId('CurrentLocation'.tr),
          position: currentPosition.value,
          infoWindow: InfoWindow(
            title: 'CurrentLocation'.tr,
            snippet: addressCoordinate,
          ),
        ),
      };
      markers.refresh();
      selectedAddress.value = addressCoordinate;
      addressController.text = addressCoordinate;
      cityController.text = addressCoordinate
          .split(',')
          .last
          .trim(); // Update city field
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentPosition.value, 14),
        );
      }
      loadingState.value = LoadingState.doneWithData;
    } catch (e) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: "ErrorUpdatingLocation".tr,
        type: CustomToastType.error,
      ).show();
    }
  }

  Future<String> getAddressFromCoordinate(LatLng latLng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placeMarks.isNotEmpty) {
        final placeMark = placeMarks.first;
        final address =
            '${placeMark.street ?? ''}, ${placeMark.locality ?? ''}, ${placeMark.country ?? ''}'
                .trim();
        return address;
      }
      return '${latLng.latitude} , ${latLng.longitude}';
    } catch (e) {
      return '${latLng.latitude} , ${latLng.longitude}';
    }
  }

  void saveSelectedLocation() async {
    if (loadingState.value == LoadingState.loading) {
      return;
    }
    final long = currentPosition.value.longitude;
    final lat = currentPosition.value.latitude;
    final addressText = addressController.text.trim();
    final cityText = cityController.text.trim();
    if (long == 0 || lat == 0) {
      CustomToasts(
        message: "YouNeedToSelectLocation".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }
    if (addressText.isEmpty || cityText.isEmpty) {
      CustomToasts(
        message: "RequiredFieldsMissing".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }

    if (addressNameController.text.trim().isEmpty) {
      CustomToasts(
        message: "PleaseEnterAddressName".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }
    final address = AddressModel(
      addressId: Get.arguments is AddressModel
          ? (Get.arguments as AddressModel).addressId
          : 0,
      customerId: cacheService.getLoggedInUser().userId,
      address: addressText,
      city: cityText,
      latitude: lat,
      longitude: long,
      floorNumber: floorNumberController.text.trim().isEmpty
          ? null
          : floorNumberController.text.trim(),
      addressName: addressNameController.text.trim().isEmpty
          ? null
          : addressNameController.text.trim(),
      details: detailsController.text.trim().isEmpty
          ? null
          : detailsController.text.trim(),
    );
    Get.back(result: address);
  }

  void onMapTap(LatLng position) async {
    loadingState.value = LoadingState.loading;
    currentPosition.value = position;
    markers.value = {
      Marker(
        markerId: MarkerId('SelectedLocation'.tr),
        position: position,
        infoWindow: InfoWindow(
          title: 'SelectedLocation'.tr,
          snippet: await getAddressFromCoordinate(position),
        ),
      ),
    };
    markers.refresh();
    try {
      selectedAddress.value = await getAddressFromCoordinate(position);
      addressController.text = selectedAddress.value;
      cityController.text = selectedAddress.value.split(',').last.trim();
      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(position, 14),
        );
      }
      loadingState.value = LoadingState.doneWithData;
    } catch (e) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: "ErrorUpdatingMap".tr,
        type: CustomToastType.error,
      ).show();
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    addressController.dispose();
    cityController.dispose();
    floorNumberController.dispose();
    addressNameController.dispose();
    detailsController.dispose();
    super.onClose();
  }
}
