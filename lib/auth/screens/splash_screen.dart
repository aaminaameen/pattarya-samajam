import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pattarya_samajam/config/routes_name.dart';
import 'package:pattarya_samajam/utils/constants.dart';
import '../../home/screen/home_screen.dart';
import '../../utils/colors.dart';
import '../service/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 // User? user;
  String? uid;

  // @override
  // void initState() {
  //   super.initState();
  //   user = FirebaseAuth.instance.currentUser;
  //   uid = user?.uid;
  // }

  @override
  void initState() {
    super.initState();
    uid = AuthService.getCurrentUser()?.uid;
  }



  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      backgroundColor: kBlackColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(addPadding / 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('images/godnew.jpeg'),
              SizedBox(
                height: height * 0.03,
              ),
              RichText(
                text: TextSpan(
                  text: 'PALLIPURAM\n',
                  style: Theme.of(context).textTheme.displayLarge,
                  children: [
                    TextSpan(
                      text: 'PATTARYA SAMAJAM - S20/69',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              RichText(
                text: TextSpan(
                  text: 'Online',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 24, color: kGreyColor),
                  children: [
                    TextSpan(
                      text: ' Portal ',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 24, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              GestureDetector(
                onTap: () {

                  final user = AuthService.getCurrentUser();
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          phoneNumber: '',
                          uid: user.uid,
                        ),
                      ),
                    );
                  } else {

                    Navigator.of(context).pushNamed(loginScreen);
                  }
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: width * .5,
                    height: height * .07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomLeft,
                          colors: [
                            kPrimaryColor,
                            Color.fromRGBO(240, 200, 1, 0),
                          ],
                          stops: [0.381, 8],
                        )),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Get',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 20, color: kWhitColor),
                          children: [
                            TextSpan(
                              text: ' Started ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontSize: 20,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
