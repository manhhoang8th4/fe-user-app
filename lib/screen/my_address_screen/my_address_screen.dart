import '../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../utility/app_color.dart';
import '../../widget/custom_text_field.dart';

class MyAddressPage extends StatelessWidget {
  const MyAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.profileProvider.retrieveSavedAddress();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "my_address".tr(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.darkOrange),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: context.profileProvider.addressFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            labelText: 'phone'.tr(),
                            onSave: (value) {},
                            inputType: TextInputType.number,
                            controller: context.profileProvider.phoneController,
                            validator: (value) => value!.isEmpty ? 'enter_phone'.tr() : null,
                          ),
                          CustomTextField(
                            labelText: 'street'.tr(),
                            onSave: (val) {},
                            controller: context.profileProvider.streetController,
                            validator: (value) => value!.isEmpty ? 'enter_street'.tr() : null,
                          ),
                          CustomTextField(
                            labelText: 'city'.tr(),
                            onSave: (value) {},
                            controller: context.profileProvider.cityController,
                            validator: (value) => value!.isEmpty ? 'enter_city'.tr() : null,
                          ),
                          CustomTextField(
                            labelText: 'state'.tr(),
                            onSave: (value) {},
                            controller: context.profileProvider.stateController,
                            validator: (value) => value!.isEmpty ? 'enter_state'.tr() : null,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: 'postal_code'.tr(),
                                  onSave: (value) {},
                                  inputType: TextInputType.number,
                                  controller: context.profileProvider.postalCodeController,
                                  validator: (value) => value!.isEmpty ? 'enter_postal_code'.tr() : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  labelText: 'country'.tr(),
                                  onSave: (value) {},
                                  controller: context.profileProvider.countryController,
                                  validator: (value) => value!.isEmpty ? 'enter_country'.tr() : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        if (context.profileProvider.addressFormKey.currentState!.validate()) {
                          context.profileProvider.storeAddress();
                        }
                      },
                      child: Text('update_address'.tr(), style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
