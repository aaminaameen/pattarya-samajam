import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/config/routes_name.dart';
import 'package:pattarya_samajam/home/account/add_members.dart';
import 'package:pattarya_samajam/home/screen/home_screen.dart';
import 'package:pattarya_samajam/home/account/member_details.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../service/list_Items.dart';
import '../widgets/alert_box.dart';
import 'package:intl/intl.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({Key? key, required this.phoneNumber}) : super(key: key);
  final String phoneNumber;

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {


  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }


  File? imageFile;
  final iconPicker = ImagePicker();
  late String? valueChoose;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  List<dynamic> familyMembers = [];
  List<dynamic> accountData = [];
  String? selectedBlood;
  String? selectedStars;
  String _age = '';
  final bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController adhaarController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController memberController = TextEditingController();



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
  String? profileImage;

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
    phoneController.text = widget.phoneNumber;
    memberController.text = '1';
    fetchData();
   fetchAccountData();
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
        ageController.text = formatDate(picked);
        _age = '$age years';
        ageController.text = _age;
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

  Future profileGallery() async {
    final pickedFile = await iconPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {

        Navigator.pushNamedAndRemoveUntil(context, homeScreen, (route) => false);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(addPadding / 1),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: kTextField,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: kTextBlack,
                                  ),
                                )),
                            InkWell(
                              onTap: () async {
                                profileGallery();
                                setState(() {});
                              },
                              child: CircleAvatar(
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
                                        child: imageFile != null
                                            ? Image.file(
                                                imageFile!,
                                                fit: BoxFit.fill,
                                              )
                                            : profileImage!=null && profileImage!.isNotEmpty
                                                ? Image.network(
                                                    profileImage!,
                                                    fit: BoxFit.fill,
                                                  )
                                                : Image.asset(
                                                    'images/profile.png')),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                            child: Text('Account Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontFamily: 'inter'))),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: height*0.08,
                          child: TextFormField(
                           readOnly: true,
                            keyboardType: TextInputType.number,
                            controller: memberController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kTextField,
                              enabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'member no.',
                              hintStyle: const TextStyle(
                                  fontSize: 16,
                                  color: kHintText,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height*0.01,),
                        CustomTextField(
                          hintText: 'Name',
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                        CustomTextField(
                            hintText: 'Age',
                            controller: ageController,
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
                            height: height * 0.08,
                            child: DropdownButtonFormField(
                              value: selectedStars?.isNotEmpty == true ? selectedStars : null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },

                              hint: Text('Stars',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                      fontSize: 14,
                                      color: kHintText,
                                      fontWeight: FontWeight.w600)),
                              decoration: InputDecoration(
                                fillColor: kTextField,
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
                              items:
                              ListItems.naal.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.centerLeft,
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedStars = value!;
                                });
                              },
                            )),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        CustomTextField(
                          hintText: 'Job',
                          controller: jobController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                            height: height * 0.08,
                            child: DropdownButtonFormField(
                              value: selectedBlood?.isNotEmpty == true ? selectedBlood : null,
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
                                          color: kHintText,
                                          fontWeight: FontWeight.w600)),
                              decoration: InputDecoration(
                                fillColor: kTextField,
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
                              items:
                              ListItems.bloodGroup.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.centerLeft,
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBlood = value!;
                                });
                              },
                            )),

                  SizedBox(
                          height: height * 0.01,
                        ),
                        CustomTextField(
                          keyboard: TextInputType.number,
                          hintText: '9876543210',
                          controller: phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a mobile number';
                            } else if (!validateMobileNumber(value)) {
                              return 'Please enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          keyboard: TextInputType.number,
                          hintText: 'Aadhaar Number',
                          controller: adhaarController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            } else if (!isValidAadhaar(value)) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          keyboard: TextInputType.number,
                          hintText: 'Unit no',
                          controller: unitController,
                        ),
                        CustomTextField(
                          keyboard: TextInputType.number,
                          hintText: 'Family no',
                          controller: familyController,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            _addMember(context, familyMembers.length+2);
                          },
                          child: Row(
                            children: [
                              Text('Add family members  ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w600)),
                              Image.asset('images/+.png')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        SizedBox(
                            height: height * .16,
                            child: ListView.builder(
                              itemCount: familyMembers.length,
                              itemBuilder: (context, index) {
                                String status = familyMembers[index]['status'] ??
                                    'not-activated';
                                bool isActivated = status == 'activated';
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 4),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MemberUpdate(
                                              memberData: familyMembers[index]),
                                        ),
                                      );
                                    },
                                    child: Visibility(
                                      visible: !isActivated,
                                      replacement: Container(
                                        height: height * 0.07,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Padding(
                                          padding:const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${familyMembers[index]['name']}  ${familyMembers[index]['age']} | ${familyMembers[index]['relation']}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                      fontSize: 18,
                                                      fontFamily: 'Inter'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        height: height * 0.07,
                                        decoration: BoxDecoration(
                                          color: kLinear,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                '${familyMembers[index]['name']}  ${familyMembers[index]['age']} | ${familyMembers[index]['relation']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                        fontSize: 18,
                                                        fontFamily: 'Inter'),
                                              ),
                                            ),
                                           const SizedBox(width: 16),
                                            InkWell(
                                                onTap: () {
                                                  deleteMember(
                                                      familyMembers[index]
                                                          ['family_members_id']);
                                                },
                                                child: Image.asset(
                                                    'images/Close.png')),
                                            const SizedBox(width: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                updateAccount();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kBlackColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: kBlackColor, width: 2),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? SizedBox(
                                        height: height * .0213,
                                        width: width * .0432,
                                        child: const CircularProgressIndicator(
                                          color: kWhitColor,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                        'Update Account',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(color: kWhitColor),
                                      )),
                              ),
                            ),
                          ),
                        )
                      ]),
                )),
          ),
        ),
      ),
    );
  }

  void _addMember(BuildContext ctx, int index) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: kPrimaryColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddMembers(familyMemberIndex: index);
      },
    );
  }



  void updateAccount() async {
    final url = Uri.parse('https://pattarya.besocial.pro/api/v1/updateAccount');
    final request = http.MultipartRequest('POST', url);
    request.fields["uid"] = uid.toString();
    request.fields["name"] = nameController.text;
    request.fields["memberno"] = memberController.text;
    request.fields["job"] = jobController.text;
    request.fields["naal"] = selectedStars.toString();
    request.fields["blood"] = selectedBlood.toString();
    request.fields["aadhar"] = adhaarController.text;
    request.fields["phone"] = phoneController.text;
    request.fields["unitno"] = unitController.text;
    request.fields["familyno"] = familyController.text;
    request.fields["age"] = ageController.text;

    try {
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile!.path));
      }
    } catch (e) {
      print('Error: $e');
    }

    try {
      final response = await request.send();
      final streamedResponse = await http.Response.fromStream(response);
      final responseData = json.decode(streamedResponse.body);

      if (!_isDisposed) {
        if (streamedResponse.statusCode == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertBox(
                content: Text('Details added Successfully'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(
                        phoneNumber: '',
                        uid: '',
                      ),
                    ),
                        (Route<dynamic> route) => false,
                  );
                },
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertBox(
                content: Text('Error: Failed to update details.'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      if (!_isDisposed) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertBox(
              content: Text('An error occurred while updating details.'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    }
  }



  Future<void> fetchAccountData() async {
    String apiUrl =
        'https://pattarya.besocial.pro/api/v1/getTableDatas?table=account&where=uid&value=$uid';
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200 && mounted) {
      final jsonData = json.decode(response.body);

      var data = jsonData['data'][0];
      setState(() {
        nameController.text = data['name'].toString();
        ageController.text = data['age'].toString();
        selectedStars = data['naal'].toString();
        jobController.text = data['job'].toString();
        selectedBlood = data['blood'].toString();
        phoneController.text = data['phone'].toString();
        adhaarController.text = data['aadhar'].toString();
        unitController.text = data['unitno'].toString();
        familyController.text = data['familyno'].toString();
        //memberController.text = data['memberno'].toString();
        print(data['image']);
        profileImage = data['image'];
        List<String> bloodList = ListItems.bloodGroup.toSet().toList();
        if (selectedBlood != null && !bloodList.contains(selectedBlood!)) {
          bloodList.add(selectedBlood!);
        }
        ListItems.bloodGroup.clear();
        ListItems.bloodGroup.addAll(bloodList);

        List<String> starList = ListItems.naal.toSet().toList();
        if (!starList.contains(selectedStars)) {
          starList.add(selectedStars!);
        }
        ListItems.naal.clear();
        ListItems.naal.addAll(starList);
      });
    }
  }



  Future<void> fetchData() async {
    String apiUrl =
        'https://pattarya.besocial.pro/api/v1/getTableDatas?table=family_members&where=uid&value=$uid';
    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['data'].isNotEmpty) {
        setState(() {
          familyMembers = jsonData['data'];
        });
      } else {
        // Handle the case where the data list is empty
      }
    }
  }

  void deleteMember(int familyMemberId) async {
    final response = await http.delete(
      Uri.parse('https://pattarya.besocial.pro/api/delete-family'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'family_members_id': familyMemberId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        familyMembers.removeWhere(
            (member) => member['family_members_id'] == familyMemberId);
      });
    }
  }
}
