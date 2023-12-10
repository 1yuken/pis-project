import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindquiz/screens/auth_page.dart';
import 'package:mindquiz/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindquiz/screens/register_screen.dart';
import '../global/gradient_decoration.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
                          "Вход",
                          style: GoogleFonts.quicksand(
                              fontSize: 25.0.sp, fontWeight: FontWeight.bold),
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
                          obscureText: true,
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
                              try {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()
                                ).then((value) => 
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CategoryScreen(),
                                    ),
                                  )
                                );
                              } catch (e) {
                                print("Такого аккаунта нет \n$e");
                                //TODO: Добавь сюда что происходит когда аккаунта для входа нет
                              }
                              
                            }
                          },
                          child: Text(
                            "Войти",
                            style: GoogleFonts.quicksand(
                                fontSize: 18.0.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                )
                              );
                            },
                            child: Text(
                              "Зарегистрироваться",
                              style: GoogleFonts.quicksand(
                                  fontSize: 13.0.sp,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
