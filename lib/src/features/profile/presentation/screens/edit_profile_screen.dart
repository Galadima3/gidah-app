import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gidah/src/constants/fancy_green_button.dart';
import 'package:gidah/src/features/auth/presentation/widgets/custom_text_formfield.dart';
import 'package:gidah/src/features/profile/data/profile_repository.dart';
import 'package:gidah/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends ConsumerState<EditProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController dateController;
  late TextEditingController phoneController;
  final emailFormKey = GlobalKey<FormState>();
  final List<String> items = [
    'Gender',
    'Male',
    'Female',
  ];
  String selectedValue = "Gender";

  Future<void> onSubmit(BuildContext ctx) async {
    ref.read(loadingProvider.notifier).state = true;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Continue with updating user data in Firestore
        await ProfileFirestoreRepository()
            .updateProfileData(
              email: emailController.text,
              dateOfBirth: dateController.text,
              fullName: fullNameController.text.trim(),
              gender: selectedValue,
              phoneNumber: phoneController.text,
            )
            .whenComplete(() => showDialog(
                  context: context,
                  builder: (context) => const AlertDialog.adaptive(
                      content: Text('Data Updated successfully')),
                ))
            .then((value) => ref.read(loadingProvider.notifier).state = false);
      } else {
        ref.read(loadingProvider.notifier).state = false;
        log('No authenticated user found.');
      }
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      log('Error updating displayName: $e');
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dateController.dispose();

    super.dispose();
  }

  final db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    dateController = TextEditingController();
    phoneController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editInfo = ref.watch(profileInfoProvider);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 18.5.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: editInfo.when(
            data: (data) {
              fullNameController.text = data!.fullName;
              emailController.text = data.email;
              dateController.text = data.dateOfBirth;
              phoneController.text = data.phoneNumber;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    //full name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17.50),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: fullNameController,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          fullNameController.text = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Full name',
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    //date of birth
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17.50),
                      child: TextField(
                          controller:
                              dateController, //editing controller of this TextField
                          onChanged: (value) => dateController.text = value,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.calendar_today),
                            //icon of text field
                            labelText: "Date of Birth",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ), //label text of field
                          ),
                          readOnly: true, // when true user cannot edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              log(formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateController.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          }),
                    ),
                    SizedBox(height: 15.h),

                    //email
                    Form(
                      key: emailFormKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: CustomTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email",
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    //phone number
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: IntlPhoneField(
                        initialValue: phoneController.text,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        initialCountryCode: "NG",
                        onSubmitted: (phoneNumber) {
                          log(phoneNumber);
                          setState(() {
                            phoneController.text = "+234$phoneNumber";
                          });
                        },
                      ),
                    ),

                    SizedBox(
                      width: 275.w,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                          log(selectedValue);
                        },
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Consumer(builder: (context, ref, child) {
                      final isLoading = ref.watch(loadingProvider);
                      return InkWell(
                        onTap: () => onSubmit(context),
                        child: FancyGreenButton(
                          inputWidget: isLoading
                              ? Transform.scale(
                                  scale: 0.65,
                                  child:
                                      const CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 15.5.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    })
                  ],
                ),
              );
            },
            error: (error, stackTrace) =>
                CustomScreen(input: Text(error.toString())),
            loading: () => const CustomScreen(
                  input: CircularProgressIndicator.adaptive(),
                )));
  }
}
