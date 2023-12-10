import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindquiz/global/global_data.dart';
import 'package:mindquiz/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> categoryList = ['Логика', 'Мышление', 'Математика'];

class CardCategory extends StatelessWidget {
  final String? images;
  final String testName;
  final String? brief;
  final int? numOfQuestions;
  final int time;

  final Map<String, List<dynamic>> qlist = {
    categoryList[0]: biologyTest,
    categoryList[1]: historyTest,
    categoryList[2]: mathsTest
  };

  CardCategory(
      {super.key,
      this.images,
      required this.testName,
      this.brief,
      this.numOfQuestions,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: InkWell(
        onTap: () async {
          String docName = switch (testName) {
            'Логика' => 'logic',
            'Мышление' => 'mind',
            'Математика' => 'math',
            _ => '',
          };
          //Map<String, dynamic> data;
          List qList = await FirebaseFirestore.instance.collection('questions').doc(docName).get().then(
            (value) async {
              Map<String, dynamic> data = value.data() as Map<String, dynamic>;
              Map<String, dynamic> answersData = data["questions"];
              List answersList = [];
              answersData.forEach((key, value) {
                answersList.add({key: value});
              });
              return answersList;
            }
          );
           
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuizScreen(
                      test: testName,
                      questionsList: qList,
                      time: time,
                    )),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    images!,
                    width: ScreenUtil().orientation == Orientation.portrait
                        ? 80.w
                        : 40.w,
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          testName,
                          style: GoogleFonts.quicksand(
                            fontSize: 18.sp,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          brief!,
                          style: GoogleFonts.quicksand(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        color: Theme.of(context).primaryColor, size: 20.0),
                    SizedBox(width: 10.w),
                    Text(
                      "${numOfQuestions!} вопросов",
                      style: GoogleFonts.quicksand(fontSize: 13.sp),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.timer_outlined,
                        color: Theme.of(context).primaryColor, size: 20.0),
                    SizedBox(width: 10.w),
                    Text(
                      "$time минут",
                      style: GoogleFonts.quicksand(fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
