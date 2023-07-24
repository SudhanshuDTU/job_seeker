import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rojgarmela/Services/global_methods.dart';
import 'package:rojgarmela/Services/global_variables.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _fullNameController =
      TextEditingController(text: '');
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  final TextEditingController _locationController =
      TextEditingController(text: '');

  final FocusNode _emailfocusNode = FocusNode();
  final FocusNode _passfocusNode = FocusNode();
  final FocusNode _phoneNumberfocusNode = FocusNode();
  final FocusNode _positionCPfocusNode = FocusNode();
  //final FocusNode _locationfocusNode = FocusNode();

  final _singUpFormKey = GlobalKey<FormState>();
  bool _obscureText = true;
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _phoneNumberController.dispose();
    _emailfocusNode.dispose();
    _passfocusNode.dispose();
    _positionCPfocusNode.dispose();
    _phoneNumberfocusNode.dispose();
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

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    // create get from camera ;...
                    _getFromCamera();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'camera',
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // create get from gallery ;...
                    _getFromGallery();
                  },
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void _getFromCamera() async {
    XFile? picakedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(picakedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? picakedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  void _submitFormOnSignUp() async {
    final isValid = _singUpFormKey.currentState!.validate();
    if (isValid) {
      if (imageFile == null) {
        GlobalMethod.showErrorDialog(
          error: 'Please pick an image',
          ctx: context,
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim().toLowerCase(),
          password: _passTextController.text.trim(),
        );
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance.ref().child('userImages').child(_uid +
            '.jpg'); //here check formate jpg or png image . it mat occurs error.
        //here check formate jpg or png image . it mat occurs error.
        await ref.putFile(imageFile!);
        imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _emailTextController.text,
          'userImage': imageUrl,
          'phoneNumber': _locationController.text,
          'createdAF': Timestamp.now(),
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: SignUpUrlImage,
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
          //  SizedBox(height: 30,),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                children: [
                  Form(
                    key: _singUpFormKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //crate show image dialog method;
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                              8.00,
                            ),
                            child: Container(
                              width: size.width * 0.20,
                              height: size.width * 0.20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.cyanAccent,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: imageFile == null
                                      //if else conditions
                                      ? const Icon(
                                          Icons.camera_enhance_sharp,
                                          color: Colors.cyan,
                                          size: 30,
                                        )
                                      : Image.file(
                                          imageFile!,
                                          fit: BoxFit.fill,
                                        )),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailfocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' please enter a valid Name';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: 'Full name/Comapny name',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )),
                        ),

                        SizedBox(
                          height: 1,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passfocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return ' please enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )),
                        ),

                        SizedBox(
                          height: 1,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_phoneNumberfocusNode),
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          obscureText: !_obscureText,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'password length is less than 7';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionCPfocusNode),
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 10) {
                              return ' please enter a valid Phone Number';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )),
                        ),

                        //textfield for Location
                        SizedBox(
                          height: 1,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_positionCPfocusNode),
                          keyboardType: TextInputType.text,
                          controller: _locationController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ' please enter your location';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: 'Your Location',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              )),
                        ),
                        //signup button

                        const SizedBox(
                          height: 20,
                        ),
                        _isLoading
                            ? // if condition for loading
                            Center(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : //else condition
                            MaterialButton(
                                onPressed: () {
                                  //create   form on signup...
                                  _submitFormOnSignUp();
                                },
                                color: Colors.cyan,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SignUp',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          // fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        const SizedBox(
                          height: 20,
                        ),

                        Center(
                            child: RichText(
                                text: TextSpan(children: [
                          const TextSpan(
                              text: 'Already have an account?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          const TextSpan(
                            text:
                                '     ', // for Space between Login and Already have an account
                          ),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.canPop(context)
                                    ? Navigator.pop(context)
                                    : null,
                              text: 'Login',
                              style: const TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ))
                        ])))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
