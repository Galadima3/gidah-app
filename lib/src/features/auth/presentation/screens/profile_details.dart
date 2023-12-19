import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gidah/main.dart';

import 'package:gidah/src/features/auth/data/firestore_repository.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class ProfileDetails extends ConsumerStatefulWidget {
  const ProfileDetails({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends ConsumerState<ProfileDetails> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  final phoneController = TextEditingController();
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
        // Continue with storing user data in Firestore
        await FirestoreRepository().storeUserDataInFirestore(
          // email: emailController.text,
          email: user.email!,
          dateOfBirth: dateController.text,
          fullName: fullNameController.text.trim(),
          gender: selectedValue,
          phoneNumber: phoneController.text,
          profileImage: _selectedImage!,
        );

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(ctx, MaterialPageRoute(
          builder: (context) {
            // return const HomeScreen();
            return const BottomNavBar();
          },
        ));
        ref.read(loadingProvider.notifier).state = false;
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

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      //uploadFile();
    } else {
      log('No image selected.');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      //uploadFile();
    } else {
      log('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Fill your Profile',
          style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Picture
            GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xffFDCF09),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _selectedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 15),

            //full name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.50),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: fullNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Full name',
                ),
              ),
            ),
            const SizedBox(height: 15),

            //date of birth
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.50),
              child: TextField(
                  controller:
                      dateController, //editing controller of this TextField
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.calendar_today),
                    //icon of text field
                    labelText: "Date of Birth",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 15),

            //TODO: Note
            //email
            // Form(
            //   key: emailFormKey,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //     child: TextFormField(
            //       autovalidateMode: AutovalidateMode.onUserInteraction,
            //       controller: emailController,
            //       validator: (value) => EmailValidator.validate(value!)
            //           ? null
            //           : "Please enter a valid email",
            //       keyboardType: TextInputType.emailAddress,
            //       decoration: InputDecoration(
            //         hintText: 'Email',
            //         prefixIcon: const Icon(Icons.email_outlined),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 15),

            //phone number
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: IntlPhoneField(
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
              width: 275,
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
            const SizedBox(height: 15),
            Consumer(builder: (context, ref, child) {
              final isLoading = ref.watch(loadingProvider);
              return InkWell(
                  onTap: () => onSubmit(context),
                  child: Container(
                      width: 328,
                      height: 53,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1AB65C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.50),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 5,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Center(
                        child: isLoading
                            ? Transform.scale(
                                scale: 0.65,
                                child: const CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : const Text(
                                'Proceed',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      )));
            })
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
