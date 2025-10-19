// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_text_field.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
// import 'package:gas_delivery_app/presentation/pages/settings_page/sub_pages/report_problem_page/report_problem_page_controller.dart';
// import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
// import 'package:gas_delivery_app/presentation/util/widgets/card_widget.dart';

// class ReportProblemPage extends GetView<ReportProblemPageController> {
//   const ReportProblemPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(ReportProblemPageController());
//     return Scaffold(
//       backgroundColor: ColorManager.colorBackground,
//       appBar: NormalAppBar(title: "ReportProblem".tr, backIcon: true),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(AppSize.s16),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CardWidget(
//                         child: Padding(
//                           padding: const EdgeInsets.all(AppSize.s16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "ReportProblemTitle".tr,
//                                 style: Get.textTheme.headlineSmall?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: AppSize.s8),
//                               Text(
//                                 "ReportProblemSubtitle".tr,
//                                 style: Get.textTheme.bodyMedium?.copyWith(
//                                   color: ColorManager.colorGrey2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: AppSize.s16),
//                       CardWidget(
//                         child: Padding(
//                           padding: const EdgeInsets.all(AppSize.s16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CustomTextField(
//                                 title: "DescribeTheProblem".tr,
//                                 hint: "EnterProblemDescription".tr,
//                                 textEditingController:
//                                     controller.commentController,
//                                 textInputType: TextInputType.multiline,
//                                 fillColor: ColorManager.colorWhite,
//                                 maxLines: 5,
//                                 minLines: 3,
//                               ),
//                               Text(
//                                 "AttachImage".tr,
//                                 style: Get.textTheme.bodyLarge?.copyWith(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               const SizedBox(height: AppSize.s8),
//                               Text(
//                                 "AttachImageDescription".tr,
//                                 style: Get.textTheme.bodySmall?.copyWith(
//                                   color: ColorManager.colorGrey2,
//                                 ),
//                               ),
//                               const SizedBox(height: AppSize.s12),
//                               Obx(() {
//                                 if (controller.selectedImage.value != null) {
//                                   return Stack(
//                                     children: [
//                                       Container(
//                                         width: double.infinity,
//                                         height: 200,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             AppSize.s8,
//                                           ),
//                                           border: Border.all(
//                                             color: ColorManager.colorGrey1,
//                                           ),
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(
//                                             AppSize.s8,
//                                           ),
//                                           child: Image.file(
//                                             controller.selectedImage.value!,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 8,
//                                         right: 8,
//                                         child: GestureDetector(
//                                           onTap: controller.removeImage,
//                                           child: Container(
//                                             padding: const EdgeInsets.all(4),
//                                             decoration: BoxDecoration(
//                                               color: ColorManager.colorRed
//                                                   .withOpacity(0.8),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: Icon(
//                                               Icons.close,
//                                               color: ColorManager.colorWhite,
//                                               size: 16,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 } else {
//                                   return GestureDetector(
//                                     onTap: controller.pickImage,
//                                     child: Container(
//                                       width: double.infinity,
//                                       height: 120,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(
//                                           AppSize.s8,
//                                         ),
//                                         border: Border.all(
//                                           color: ColorManager.colorGrey1,
//                                           style: BorderStyle.solid,
//                                         ),
//                                         color: ColorManager.colorGrey1
//                                             .withOpacity(0.1),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Assets.icons.imageIcon.svg(
//                                             width: AppSize.s30,
//                                             colorFilter: ColorFilter.mode(
//                                               ColorManager.colorGrey2,
//                                               BlendMode.srcIn,
//                                             ),
//                                           ),
//                                           const SizedBox(height: AppSize.s8),
//                                           Text(
//                                             "TapToSelectImage".tr,
//                                             style: Get.textTheme.bodySmall
//                                                 ?.copyWith(
//                                                   color:
//                                                       ColorManager.colorGrey2,
//                                                 ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               }),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: AppSize.s16),
//               Obx(
//                 () => AppButton(
//                   loadingMode:
//                       controller.reportLoadingState.value ==
//                       LoadingState.loading,
//                   onPressed: controller.submitReport,
//                   backgroundColor: ColorManager.colorPrimary,
//                   text: "SubmitReport".tr,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
