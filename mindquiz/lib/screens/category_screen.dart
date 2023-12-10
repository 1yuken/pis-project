import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mindquiz/global/global_data.dart';
import 'package:mindquiz/global/gradient_decoration.dart';
import 'package:mindquiz/screens/login_screen.dart';
import 'package:mindquiz/screens/profile_screen.dart';
import 'package:mindquiz/shared/card_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: blueGradient,
          ),
          Positioned(
            left: 20,
            top: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.waving_hand_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    FutureBuilder<String?>(
                      future: getLogin(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Привет, Гость',
                            style: GoogleFonts.quicksand(
                              fontSize: 17.0.sp,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          String? login = snapshot.data;
                          return Text(
                            'Привет, ${login ?? 'Гость'}',
                            style: GoogleFonts.quicksand(
                              fontSize: 17.0.sp,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      width: 155.w, // Здесь установите нужное вам расстояние
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 32,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Text(
                      "Выберите категорию",
                      style: GoogleFonts.quicksand(
                          fontSize: 17.0.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.white,
                      size: 22,
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: Color(0xFFE1F1FF),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CardCategory(
                      images: "assets/images/biology_badge.png",
                      testName: "Логика",
                      brief:
                          "Здесь вы найдете захватывающие задачи, способствующие развитию аналитического мышления, улучшению навыков принятия обоснованных решений и глубокому погружению в мир логических головоломок.",
                      numOfQuestions: biologyTest.length,
                      time: 6,
                    ),
                    CardCategory(
                      images: "assets/images/history_badge.png",
                      testName: "Мышление",
                      brief:
                          "Пройдите через упражнения, которые стимулируют логическое мышление, помогут развивать новые идеи и улучшат общую гибкость вашего умственного подхода.",
                      numOfQuestions: historyTest.length,
                      time: 5,
                    ),
                    CardCategory(
                      images: "assets/images/maths_badge.png",
                      testName: "Математика",
                      brief:
                          "Пройдите через упражнения, спроектированные для улучшения вашей математической гибкости и эффективности в решении различных задач.",
                      numOfQuestions: mathsTest.length,
                      time: 5,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}

Future<String?> getLogin() async {
  String? email = FirebaseAuth.instance.currentUser?.email;

  if (email != null) {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(
            'users') // Замените 'users' на ваш путь к коллекции пользователей
        .doc(email)
        .get();

    // Проверяем, есть ли такой документ в базе данных
    if (snapshot.exists) {
      return snapshot.get('login');
    }
  }

  return null; // Если что-то пошло не так или логин не найден
}
