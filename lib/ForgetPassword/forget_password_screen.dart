import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rojgarmela/LoginPage/login_screen.dart';
import 'package:rojgarmela/Services/global_variables.dart';

class ForgetPassword extends StatefulWidget {
  // const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _forgetPassTextController =
      TextEditingController(text: '');
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    //super.initState();

    super.initState();
  }

  void _forgetPassSubmitForm() async {
    try {
      await _auth.sendPasswordResetEmail(email: _forgetPassTextController.text);
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => Login(),
          ));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: forgetUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.png',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto-Regular',
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Email Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto-Regular',
                    fontSize: 28,
                    // fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _forgetPassTextController,
                  decoration: const InputDecoration(
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.white,
                      ))),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                MaterialButton(
                  onPressed: () {
                    // Create forget password
                    _forgetPassSubmitForm();
                  },
                  child: Text(
                    "Reset Now",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.cyan,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
