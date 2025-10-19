// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/core/app_config/app_translation.dart';
// import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/phone_number_formater.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

// class PhoneNumberInput extends StatelessWidget {
//   const PhoneNumberInput({
//     super.key,
//     this.textEditingController,
//     required this.onChanged,
//     required this.countryCode,
//     required this.readOnly,
//     required this.hintText,
//     this.minHeight = 65,
//     this.validator,
//     this.borderRadius = 16,
//     this.focusNode,
//     this.initialValue,
//     this.title = '',
//     required this.languageCode,
//     this.autoValidateMode = AutovalidateMode.disabled,
//   });

//   final dynamic Function(String) onChanged;
//   final TextEditingController? textEditingController;
//   final RxString countryCode;
//   final String hintText;
//   final String? initialValue;
//   final String languageCode;
//   final FocusNode? focusNode;
//   final bool readOnly;
//   final double minHeight;
//   final double borderRadius;
//   final String? Function(String?)? validator; // Adjusted for TextField
//   final AutovalidateMode? autoValidateMode;
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     // Initialize country code to Syria's dial code
//     countryCode.value = '+963';

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: Get.textTheme.titleMedium,
//           textAlign: TextAlign.start,
//         ),
//         const SizedBox(height: 8),
//         Directionality(
//           textDirection: TextDirection.ltr,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(borderRadius),
//               color: ColorManager.colorWhite,
//             ),
//             constraints: BoxConstraints(minHeight: minHeight),
//             child: TextFormField(
//               maxLength: 11,
//               autovalidateMode: autoValidateMode,
//               focusNode: focusNode,
//               readOnly: readOnly,
//               controller: textEditingController,
//               initialValue: initialValue,
//               textAlign: AppTranslations.isArabic
//                   ? TextAlign.end
//                   : TextAlign.start,
//               style: TextStyle(
//                 fontSize: FontSize.s14,
//                 fontWeight: FontWeight.w500,
//                 color: ColorManager.colorFontPrimary,
//               ),
//               textInputAction: TextInputAction.next,
//               keyboardType: TextInputType.phone,
//               inputFormatters: [PhoneNumberFormatter(onChanged: onChanged)],
//               validator: validator,
//               decoration: InputDecoration(
//                 isDense: true,
//                 constraints: const BoxConstraints(minHeight: 40),
//                 counterText: '',
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: AppPadding.p16,
//                   vertical: AppPadding.p12,
//                 ),
//                 filled: true,
//                 hintText: hintText,
//                 hintTextDirection: TextDirection.ltr,
//                 fillColor: ColorManager.colorWhite,
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Custom Syrian flag (replace with your asset path)
//                       Assets.icons.flagSyriaIcon.svg(width: AppSize.s28),
//                       const SizedBox(width: 8),
//                       Text(
//                         '+963',
//                         style: TextStyle(
//                           fontSize: FontSize.s14,
//                           fontWeight: FontWeight.w500,
//                           color: ColorManager.colorFontPrimary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 suffixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   child: Assets.icons.mobileIcon.svg(width: AppSize.s28),
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/app_config/app_translation.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/phone_number_formater.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    super.key,
    required this.textEditingController,
    required this.onChanged,
    this.focusNode,
    this.validator,
    this.hintText = '',
    this.title,
    this.readOnly = false,
    this.minHeight = 50,
    this.borderRadius = 16,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.requiredField = true,
  });

  final TextEditingController textEditingController;
  final void Function(String) onChanged;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final String hintText;
  final String? title;
  final bool readOnly;
  final double minHeight;
  final double borderRadius;
  final AutovalidateMode autoValidateMode;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? RichText(
                text: TextSpan(
                  text: title!,
                  style: Get.textTheme.titleMedium,
                  children: requiredField
                      ? [
                          TextSpan(
                            text: ' *',
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ]
                      : [],
                ),
              )
            : const SizedBox.shrink(),
        title != null ? const SizedBox(height: 8) : const SizedBox.shrink(),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            child: TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              readOnly: readOnly,
              validator: validator,
              onChanged: onChanged,
              autovalidateMode: autoValidateMode,
              maxLength: 11,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [PhoneNumberFormatter(onChanged: onChanged)],
              textAlign: AppTranslations.isArabic
                  ? TextAlign.end
                  : TextAlign.start,
              style: TextStyle(
                fontSize: FontSize.s14,
                fontWeight: FontWeight.w500,
                color: ColorManager.colorFontPrimary,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: hintText,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16,
                  vertical: AppPadding.p12,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.icons.flagSyriaIcon.svg(width: AppSize.s28),
                      const SizedBox(width: 8),
                      Text(
                        '+963',
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.colorFontPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Assets.icons.mobileIcon.svg(width: AppSize.s24),
                ),
                filled: true,
                fillColor: ColorManager.colorWhite,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: ColorManager.colorTextFieldEnabledBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: ColorManager.colorTextFieldFocusedBorder,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: ColorManager.colorTextFieldErrorBorder,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide(
                    color: ColorManager.colorTextFieldErrorBorder,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
