import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/question.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:open_file/open_file.dart';

class AboutProject extends StatefulWidget {
  const AboutProject({super.key});

  @override
  State<AboutProject> createState() => _AboutProjectState();
}

class _AboutProjectState extends State<AboutProject> {
  About? about;
  int? selectIndex;
  late UserRegModel? user;
  @override
  void initState() {
    super.initState();
       user = BlocProvider.of<ProfileBloc>(context).user;
    getQuestions();
  }

  void getQuestions() async {
    about = await Repository().aboutList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: 80.h),
                    Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 28.w),
                      child: SizedBox(
                        height: 35.h,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            CustomIconButton(
                              onBackPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: SvgImg.arrowRight,
                              color: ColorStyles.greyBDBDBD,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'about_the_project'.tr(),
                                  style: CustomTextStyle.black_22_w700,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h)
                  ],
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        color: ColorStyles.yellowFFD70A,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.h),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.w),
                                  child: Center(
                                    child: Text(
                                      'jobyfine'.toUpperCase(),
                                      style: CustomTextStyle
                                          .black_39_w900_171716
                                          .copyWith(color: ColorStyles.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Text( 
                                  user?.rus ?? true &&  context.locale.languageCode == 'ru' ? about?.about ?? '': about?.aboutEng ?? '',
                                style: CustomTextStyle.black_14_w400_515150,
                              ),
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          'question_and_answer'.tr(),
                          style: CustomTextStyle.black_22_w700_171716,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      if (about != null)
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: about!.question.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: itemQuestion(
                                index,
                                   user?.rus ?? true &&  context.locale.languageCode == 'ru' ? about!.question[index].question : about!.question[index].questionEng,
                                 user?.rus ?? true &&  context.locale.languageCode == 'ru' ?  about!.question[index].answer: about!.question[index].answerEng,
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: GestureDetector(
                          onTap: () async {
                            final res = await Repository()
                                .getFile(about?.confidence ?? '');
                            if (res != null) await OpenFile.open(res);
                          },
                          child: Text(
                            "user_agreement".tr(),
                            style: CustomTextStyle.blue_16_w400_336FEE
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: GestureDetector(
                          onTap: () async {
                            final res = await Repository()
                                .getFile(about?.agreement ?? '');
                            if (res != null) await OpenFile.open(res);
                          },
                          child: Text(
                            "consent_to_the_processing_of_personal_data".tr(),
                            style: CustomTextStyle.blue_16_w400_336FEE
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 175.h),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> itemQuestion(int index, String question, String answer) {
    log(question);
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: GestureDetector(
          onTap: () {
            if (selectIndex == index) {
              selectIndex = null;
            } else {
              selectIndex = index;
            }
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question,
                  textAlign: TextAlign.start,
                  style: CustomTextStyle.black_16_w600_171716,
                ),
              ),
              selectIndex == index
                  ? const Icon(
                      Icons.keyboard_arrow_up,
                      color: ColorStyles.blue336FEE,
                    )
                  : const Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorStyles.greyD9D9D9,
                    ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10.h),
      AnimatedContainer(
        height: selectIndex != null
            ? selectIndex == index
                ? answer.length > 200
                    ? question != 'Для кого это приложение?'
                        ? 187.h
                        : 160.h
                    : 120.h
                : 0
            : 0,
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        duration: const Duration(milliseconds: 300),
        child: Text(
          answer,
          style: CustomTextStyle.black_14_w400_515150,
        ),
      ),
      SizedBox(height: 10.h),
    ];
  }
}
