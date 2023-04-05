import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditBasicInfo extends StatefulWidget {
  const EditBasicInfo({Key? key}) : super(key: key);

  @override
  State<EditBasicInfo> createState() => _EditBasicInfoState();
}

class _EditBasicInfoState extends State<EditBasicInfo> {
  bool physics = false;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController(text: '+');
  TextEditingController emailController = TextEditingController();

  // FocusNode focusNodeAbout = FocusNode();
  // FocusNode focusNodeName = FocusNode();
  // FocusNode focusNodeLastName = FocusNode();
  // FocusNode focusNodePhone = FocusNode();
  // FocusNode focusNodeEmail = FocusNode();

  ScrollController scrollController1 = ScrollController();
  late UserRegModel? user;
  @override
  void initState() {
    user = BlocProvider.of<ProfileBloc>(context).user;
    fillData(user);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: ColorStyles.whiteFFFFFF,
            body: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, snapshot) {
              if (snapshot is LoadProfileState) {
                return const CupertinoActivityIndicator();
              }
              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Transform.rotate(
                              angle: pi,
                              child: SvgPicture.asset(
                                'assets/icons/arrow_right.svg',
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Основная информация',
                            style: CustomTextStyle.black_21_w700,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                    ListView(
                      addAutomaticKeepAlives: false,
                      padding: EdgeInsets.zero,
                      controller: scrollController1,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CustomTextField(
                            // focusNode: focusNodeName,
                            hintText: 'Ваше имя',
                            height: 50,
                            textEditingController: firstnameController,
                            hintStyle: CustomTextStyle.grey_13_w400,
                            formatters: [UpperTextInputFormatter()],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 18.h),
                            onChanged: (value) {
                              user?.copyWith(firstname: value);
                            },
                            onFieldSubmitted: (value) {
                              requestNextEmptyFocusStage1();
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CustomTextField(
                            // focusNode: focusNodeLastName,
                            hintText: 'Ваша фамилия',
                            height: 50.h,
                            textEditingController: lastnameController,
                            hintStyle: CustomTextStyle.grey_13_w400,
                            formatters: [UpperTextInputFormatter()],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 18.h),
                            onChanged: (value) {
                              user?.copyWith(lastname: value);
                            },
                            onFieldSubmitted: (value) {
                              requestNextEmptyFocusStage1();
                            },
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            'Изменить E-mail или Телефон',
                            style: CustomTextStyle.grey_12_w400,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CustomTextField(
                            readOnly: true,
                            // focusNode: focusNodePhone,
                            hintText: 'Номер телефона',
                            height: 50.h,
                            textInputType: TextInputType.phone,
                            textEditingController: phoneController,
                            hintStyle: CustomTextStyle.grey_13_w400,
                            formatters: [
                              MaskTextInputFormatter(
                                initialText: '+ ',
                                mask: '+############',
                                filter: {"#": RegExp(r'[0-9]')},
                              ),
                              LengthLimitingTextInputFormatter(13),
                            ],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 18.h),
                            onChanged: (value) {
                              user?.copyWith(phoneNumber: value);
                            },
                            onFieldSubmitted: (value) {
                              requestNextEmptyFocusStage1();
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: CustomTextField(
                            // focusNode: focusNodeEmail,
                            hintText: 'E-mail',
                            height: 50.h,
                            textEditingController: emailController,
                            hintStyle: CustomTextStyle.grey_13_w400,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 18.w, vertical: 18.h),
                            onChanged: (value) {
                              user?.copyWith(email: value);
                            },
                            onFieldSubmitted: (value) {
                              requestNextEmptyFocusStage1();
                            },
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 250),
                                  () {
                                scrollController1.animateTo(500.h,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.linear);
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.r)),
                                value: physics,
                                onChanged: (value) {
                                  setState(() {
                                    physics = !physics;
                                  });
                                },
                                checkColor: Colors.black,
                                activeColor: ColorStyles.yellowFFD70A,
                              ),
                              Flexible(
                                child: Text(
                                  'Юридическое лицо',
                                  textAlign: TextAlign.justify,
                                  style: CustomTextStyle.black_13_w400_515150,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomButton(
                        onTap: () {
                          user!.copyWith(isEntity: physics);
                          BlocProvider.of<ProfileBloc>(context)
                              .add(UpdateProfileEvent(user));
                          Navigator.of(context).pop();
                        },
                        btnColor: ColorStyles.yellowFFD70B,
                        textLabel: Text(
                          'Сохранить',
                          style: CustomTextStyle.black_14_w600_171716,
                        ),
                      ),
                    ),
                    SizedBox(height: 52.h),
                  ],
                ),
              );
            }),
          ),
          if (MediaQuery.of(context).viewInsets.bottom > 0)
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Spacer(),
                    CupertinoButton(
                        child: Text(
                          'Готово',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                        })
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void requestNextEmptyFocusStage1() {
    // if (firstnameController.text.isEmpty) {
    //   focusNodeName.requestFocus();
    //   scrollController1.animateTo(0,
    //       duration: const Duration(milliseconds: 100), curve: Curves.linear);
    // } else if (lastnameController.text.isEmpty) {
    //   focusNodeLastName.requestFocus();
    //   scrollController1.animateTo(50.h,
    //       duration: const Duration(milliseconds: 100), curve: Curves.linear);
    // } else if (phoneController.text.isEmpty) {
    //   focusNodePhone.requestFocus();
    //   scrollController1.animateTo(100.h,
    //       duration: const Duration(milliseconds: 100), curve: Curves.linear);
    // } else if (emailController.text.isEmpty) {
    //   focusNodeEmail.requestFocus();
    //   scrollController1.animateTo(150.h,
    //       duration: const Duration(milliseconds: 100), curve: Curves.linear);
    // }
  }

  fillData(UserRegModel? userRegModel) {
    if (userRegModel == null) return;
    physics = userRegModel.isEntity!;
    firstnameController.text = userRegModel.firstname!;
    lastnameController.text = userRegModel.lastname!;
    phoneController.text = userRegModel.phoneNumber!;
    emailController.text = userRegModel.email!;
  }
}