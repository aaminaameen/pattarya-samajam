import 'package:flutter/material.dart';
import 'package:pattarya_samajam/utils/constants.dart';
import '../../utils/colors.dart';
import '../widgets/text_form.dart';

class MemberUpdate extends StatefulWidget {
  const MemberUpdate({Key? key, required this.memberData,}) : super(key: key);
  final Map<String, dynamic> memberData;

  @override
  State<MemberUpdate> createState() => _MemberUpdateState();
}

class _MemberUpdateState extends State<MemberUpdate> {

  Map<String, dynamic> _updatedMemberData = {};

  @override
  void initState() {
    super.initState();
    _updatedMemberData = widget.memberData;
  }


  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: kTextField,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_rounded, color: kTextBlack,),
                      )
                  ),
                  CircleAvatar(
                    maxRadius: 40,
                    backgroundColor: kTextField,
                    child: _updatedMemberData['mem_photo'] != null
                        ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius:const BorderRadius.all(Radius.circular(40)),
                          border: Border.all(width: 0.3),
                          color: Colors.white,
                        ),
                        child: Image.network(
                          _updatedMemberData['mem_photo'],
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            // Display the asset image if the network image fails to load
                            return Image.asset(
                              'images/profile.png',
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      ),
                    )
                        : Image.asset(
                      'images/profile.png',
                      fit: BoxFit.fill,
                    ),
                  )

                ],
              ),
              SizedBox(
                  child: Text('Member Details', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontFamily: 'inter'))),
              SizedBox(height: height*0.01,),
              MyTextFormField(
                labelText: 'Member No:',
                initialValue: _updatedMemberData['memberno'],
                onChanged: (value) {
                  _updatedMemberData['memberno'] = value;
                },
              ),
              MyTextFormField(
                labelText: 'Name:',
                initialValue: _updatedMemberData['name'],
                onChanged: (value) {
                  _updatedMemberData['name'] = value;
                },
              ),




              MyTextFormField(
                labelText: 'Age:',
                initialValue: _updatedMemberData['age'].toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updatedMemberData['age'] = int.parse(value);
                },
              ),
              MyTextFormField(
                labelText: 'Relation:',
                initialValue: _updatedMemberData['relation'],
                onChanged: (value) {
                  _updatedMemberData['relation'] = value;
                },
              ),
              MyTextFormField(
                labelText: 'Stars:',
                initialValue: _updatedMemberData['naal'],
                onChanged: (value) {
                  _updatedMemberData['naal'] = value;
                },
              ),

              MyTextFormField(
                labelText: 'Blood Group:',
                initialValue: _updatedMemberData['blood'],
                onChanged: (value) {
                  _updatedMemberData['blood'] = value;
                },
              ),

              MyTextFormField(
                labelText: 'Job:',
                initialValue: _updatedMemberData['job'],
                onChanged: (value) {
                  _updatedMemberData['job'] = value;
                },
              ),

              MyTextFormField(
                labelText: 'Mobile Number:',
                initialValue: _updatedMemberData['phone'],
                onChanged: (value) {
                  _updatedMemberData['phone'] = value;
                },
              ),
              MyTextFormField(
                labelText: 'Aadhaar Number:',
                initialValue: _updatedMemberData['aadhar'],
                onChanged: (value) {
                  _updatedMemberData['aadhar'] = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}




