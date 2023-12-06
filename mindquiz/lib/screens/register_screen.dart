import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindquiz/screens/auth_page.dart';
import 'package:mindquiz/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global/gradient_decoration.dart';


final loginController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool userIsAuth = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DecoratedBox(
          decoration: blueGradient,
          child: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: .15.sw,
                          height: .15.sh,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  height: (2 / 3).sh,
                  decoration: const BoxDecoration(
                    color: Color(0xEEF7FFFF),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Регистрация",
                          style: GoogleFonts.quicksand(
                              fontSize: 25.0.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: loginController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Логин не может быть пустым';
                            } else if (value.length < 4) {
                              return "Логин должен содержать не менее 4 символов";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.person),
                            hintText: "Логин",
                            hintStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.w500),
                            ),
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Почта не может быть пустой';
                            } else if (!value.contains("@")) {
                              return "Почта должна содержать @";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.email),
                            hintText: "Почта",
                            hintStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.w500),
                            ),
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Пароль не может быть пустым';
                            } else if (value.length < 6) {
                              return "Пароль должен содержать не менее 6 символов";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: const Icon(Icons.security),
                            hintText: "Пароль",
                            hintStyle: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                  fontSize: 12.sp, fontWeight: FontWeight.w500),
                            ),
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                Map<String, dynamic> data = {
                                  "login": loginController.text.trim(),
                                  "email": emailController.text.trim(),
                                  "password": passwordController.text.trim()
                                };
                                await FirebaseFirestore.instance.collection("users").doc(emailController.text).set(data);
                                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ).then((value) => 
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CategoryScreen(),
                                    ),
                                  )
                                );
                              } catch(e) {
                                print("Такой аккаунт уже есть $e");
                                //TODO: Добавь сюда то что происходит если юзер уже зареган
                              }
                              
                            }
                          },
                          child: Text(
                            "Зарегистрироваться",
                            style: GoogleFonts.quicksand(
                                fontSize: 18.0.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    }, 
                    icon: const Icon(Icons.arrow_back_ios),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> checkIfEmailInUse(String emailAddress) async {
  //   try {
  //     final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

  //     if (list.isNotEmpty) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (error) {
  //     return true;
  //   }
  // }
}
