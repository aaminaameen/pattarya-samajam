import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/home/widgets/alert_box.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../service/list_Items.dart';
import 'account_details.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({Key? key, required this.familyMemberIndex}) : super(key: key);
  final int familyMemberIndex;

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {



  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  final _formKey = GlobalKey<FormState>();
  TextEditingController namefamController = TextEditingController();
  TextEditingController agefamController = TextEditingController();
  TextEditingController phonefamController = TextEditingController();
  TextEditingController adhaarfamController = TextEditingController();
  TextEditingController membController = TextEditingController();
  TextEditingController jobfamController = TextEditingController();
  String profileImage = '';
  bool isLoading = false;
  String? relation = "";
  late String selectedBloodGroup;
  String? selectedStarsFam;
  String _age = '';
  Map? data;
  String? name,
      age,
      naal,
      job,
      blood,
      aadhar,
      phone,
      unitno,
      familyno,
      memberno,
      status;

  bool validateMobileNumber(String mobileNumber) {
    String pattern = r'^\d{10}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(mobileNumber);
  }

  bool isValidAadhaar(String input) {
    RegExp regex = RegExp(r'^\d{12}$');
    return regex.hasMatch(input);
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uid = user?.uid;
    membController.text = widget.familyMemberIndex.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final age = calculateAge(picked);
      setState(() {
        _age = '$age years';
        agefamController.text = formatDate(picked);
        agefamController.text = _age;
      });
    }
  }

  int calculateAge(DateTime dob) {
    final now = DateTime.now();
    final age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      return age - 1;
    }
    return age;
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  File? imageFile;
  final iconPicker = ImagePicker();

  Future categoryGallery() async {
    final pickedFile = await iconPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child:  SizedBox(
            height: height * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(addPadding * 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Family Member',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 24,
                            fontFamily: 'Inter',
                            color: kHeadDetail),
                      ),
                      InkWell(
                        onTap: () async {
                          categoryGallery();
                          setState(() {});
                        },
                        child:CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: kTextField,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(40)),
                              child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40)),
                                    border: Border.all(width: 0.3),
                                    color: Colors.white,
                                  ),
                                  child:imageFile != null
                                      ? Image.file(
                                    imageFile!,
                                    fit: BoxFit.fill,
                                  )
                                      : profileImage.isNotEmpty
                                      ? Image.network(
                                    profileImage,
                                    fit: BoxFit.fill,
                                  )
                                      : Image.asset('images/profile.png'),),


                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFieldFamily(
                    hintText: '${widget.familyMemberIndex}',

                    controller: membController,
                    keyboard: TextInputType.number,
                  ),
                  TextFieldFamily(
                    hintText: 'Name',
                    controller: namefamController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  TextFieldFamily(
                      hintText: 'Age',
                      controller: agefamController,
                      onChanged: (value) {
                        _selectDate(context);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: height * 0.075,
                    child: DropdownButtonFormField(
                      value: selectedStarsFam,
                      hint: Text('Stars',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                  fontSize: 14,
                                  color: kTextFieldBottom,
                                  fontWeight: FontWeight.w500)),
                      decoration: InputDecoration(
                        fillColor: kWhitColor,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: kWhitColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: kWhitColor,
                          ),
                        ),
                      ),
                      items: ListItems.naal.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStarsFam = value!;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: height * 0.075,
                          width: width * 0.4,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            hint: Text('Blood Group',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                        fontSize: 14,
                                        color: kTextFieldBottom,
                                        fontWeight: FontWeight.w500)),
                            decoration: InputDecoration(
                              fillColor: kWhitColor,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kWhitColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kWhitColor,
                                ),
                              ),
                            ),
                            items: ListItems.bloodGroup.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedBloodGroup = value!;
                              });
                            },
                          )),
                      SizedBox(
                          height: height * 0.075,
                          width: width * 0.45,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            hint: Text('Relation',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                        fontSize: 14,
                                        color: kTextFieldBottom,
                                        fontWeight: FontWeight.w500)),
                            decoration: InputDecoration(
                              fillColor: kWhitColor,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kWhitColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kWhitColor,
                                ),
                              ),
                            ),
                            items: ListItems.relation.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                relation = value!;
                              });
                            },
                          )),
                    ],
                  ),
                  TextFieldFamily(
                    hintText: 'Job',
                    controller: jobfamController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  TextFieldFamily(
                    hintText: 'Mobile Number',
                    controller: phonefamController,
                    keyboard: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a mobile number';
                      } else if (!validateMobileNumber(value)) {
                        return 'Please enter a valid mobile number';
                      }
                      return null;
                    },
                  ),
                  TextFieldFamily(
                    hintText: 'Aadhaar Number',
                    controller: adhaarfamController,
                    keyboard: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      } else if (!isValidAadhaar(value)) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomButton(
                    text: 'Add Member',
                    ontap: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        familySubmit();
                        setState(() {
                          isLoading = true;
                        });
                        Future.delayed(const Duration(seconds: 10), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void familySubmit() async {
    final url =
        Uri.parse('https://pattarya.besocial.pro/api/v1/addFamilyMembers');
    final request = http.MultipartRequest('POST', url);
    request.fields["uid"] = uid.toString();
    request.fields["name"] = namefamController.text;
    request.fields["age"] = agefamController.text;
    request.fields["memberno"] = membController.text;
    request.fields["job"] = jobfamController.text;
    request.fields["naal"] = selectedStarsFam.toString();
    request.fields["blood"] = selectedBloodGroup;
    request.fields["aadhar"] = adhaarfamController.text;
    request.fields["phone"] = phonefamController.text;
    request.fields["relation"] = relation.toString();

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('mem_photo', imageFile!.path));
    }

    var response = await request.send();
    var streamedResponse = await http.Response.fromStream(response);

    if (streamedResponse.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBox(
              content: Text("Added a family member successfully!"),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AccountDetails(
                              phoneNumber: '',
                            )),
                    (Route<dynamic> route) => false);
              });
        },
      );
    }
  }
}
