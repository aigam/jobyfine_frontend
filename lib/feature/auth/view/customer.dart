import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/drop_down.dart';
import 'package:just_do_it/feature/auth/widget/radio.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/user_reg.dart';

class Customer extends StatefulWidget {
  Function(int) stage;

  Customer(this.stage);
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  GlobalKey iconBtn = GlobalKey();

  int groupValue = 0;
  int page = 0;
  bool visiblePassword = false;
  bool visiblePasswordRepeat = false;
  bool additionalInfo = false;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  String? gender;

  TextEditingController regionController = TextEditingController();

  List<String> typeDocument = [];

  List<String> typeWork = [];

  TextEditingController aboutMeController = TextEditingController();

  Uint8List? image;

  List<Uint8List> photos = [];

  Uint8List? cv;

  bool confirmTermsPolicy = false;

  UserRegModel user = UserRegModel();

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      Uint8List? file = await File(getMedia.path).readAsBytes();
      image = file;
      user.copyWith(image: image);
    }
  }

  _selectImages() async {
    final getMedia = await ImagePicker().getMultiImage(imageQuality: 70);
    if (getMedia != null) {
      List<Uint8List> files = [];
      for (var pickedFile in getMedia) {
        Uint8List? file = await File(pickedFile.path).readAsBytes();
        files.add(file);
      }
      setState(() {
        photos = files;
      });
    }
  }

  _selectCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      cv = result.files.first.bytes;
      user.copyWith(cv: cv);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Column(
        children: [
          Expanded(
            child: page == 0 ? firstStage() : secondStage(),
          ),
          SizedBox(height: 10.h),
          CustomButton(
            onTap: () {
              if (page == 0) {
                page = 1;
                widget.stage(2);
              } else {
                BlocProvider.of<AuthBloc>(context).add(SendProfileEvent(user));
                Navigator.of(context).pushNamed(AppRoute.confirmCode);
              }
            },
            btnColor: yellow,
            textLabel: Text(
              page == 0 ? 'Далее' : 'Зарегистрироваться',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF171716),
                fontFamily: 'SFPro',
              ),
            ),
          ),
          SizedBox(height: 18.h),
          CustomButton(
            onTap: () {
              if (page == 1) {
                page = 0;
                widget.stage(1);
              } else {
                Navigator.of(context).pop();
              }
            },
            btnColor: const Color(0xFFE0E6EE),
            textLabel: Text(
              'Назад',
              style: TextStyle(
                color: const Color(0xFF515150),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'SFPro',
              ),
            ),
          ),
          SizedBox(height: 34.h),
        ],
      ),
    );
  }

  Widget firstStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: '   Ваше имя',
          height: 50.h,
          textEditingController: firstnameController,
          onChanged: (value) {
            user.copyWith(firstname: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Ваша фамилия',
          height: 50.h,
          textEditingController: lastnameController,
          onChanged: (value) {
            user.copyWith(lastname: value);
          },
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Text(
              'Ваш пол',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'SFPro',
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = 0;
                  gender = 'Мужчина';
                  user.copyWith(sex: gender);
                });
              },
              child: CustomCircleRadioButtonItem(
                label: 'Муж.',
                value: 0,
                groupValue: groupValue,
              ),
            ),
            SizedBox(width: 15.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = 1;
                  gender = 'Женщина';
                  user.copyWith(sex: gender);
                });
              },
              child: CustomCircleRadioButtonItem(
                label: 'Жен.',
                value: 1,
                groupValue: groupValue,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        CustomTextField(
          hintText: '   Номер телефона',
          height: 50.h,
          textEditingController: phoneController,
          onChanged: (value) {
            print('object ${value}');
            user.copyWith(phoneNumber: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   E-mail',
          height: 50.h,
          textEditingController: emailController,
          onChanged: (value) {
            user.copyWith(email: value);
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: _selectImage,
          child: CustomTextField(
            hintText: '   Добавить фото',
            height: 50.h,
            enabled: false,
            suffixIcon: Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.h),
                  child: SvgPicture.asset(
                    SvgImg.gallery,
                    height: 15.h,
                    width: 15.h,
                  ),
                ),
              ],
            ),
            textEditingController: TextEditingController(),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: confirmTermsPolicy,
              onChanged: (value) {
                setState(() {
                  confirmTermsPolicy = !confirmTermsPolicy;
                });
              },
              checkColor: Colors.black,
              activeColor: yellow,
            ),
            Flexible(
              child: Text(
                'Согласен на обработку персональных данных и с пользовательским соглашением',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 23.h),
      ],
    );
  }

  Widget secondStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: '   Пароль',
          height: 50.h,
          suffixIcon: GestureDetector(
              onTap: () {
                visiblePassword = !visiblePassword;
                setState(() {});
              },
              child: visiblePassword
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : const Icon(Icons.remove_red_eye)),
          textEditingController: passwordController,
          onChanged: (value) {
            user.copyWith(password: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Повторите пароль',
          height: 50.h,
          suffixIcon: GestureDetector(
              onTap: () {
                visiblePasswordRepeat = !visiblePasswordRepeat;
                setState(() {});
              },
              child: visiblePasswordRepeat
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : const Icon(Icons.remove_red_eye)),
          textEditingController: repeatPasswordController,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Регион',
          height: 50.h,
          textEditingController: regionController,
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () => showIconModal(
            context,
            iconBtn,
            (value) {
              additionalInfo = true;
              setState(() {});
            },
            ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
            'Тип документа',
          ),
          child: Stack(
            key: iconBtn,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: '   Тип документа',
                height: 50.h,
                enabled: false,
                onTap: () {},
                fillColor: Colors.grey[200],
                textEditingController:
                    TextEditingController(text: '   Тип документа'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      SvgImg.arrowBottom,
                      width: 16.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (additionalInfo) additionalInfoWidget(),
        SizedBox(height: 16.h),
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: true,
              onChanged: (value) {},
              checkColor: Colors.black,
              activeColor: Colors.yellow[600]!,
            ),
            Flexible(
              child: Text(
                'Юридическое лицо',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SFPro',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget additionalInfoWidget() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              hintText: '   Серия',
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 - 6.w,
              textEditingController: TextEditingController(),
            ),
            SizedBox(width: 12.w),
            CustomTextField(
              hintText: '   Номер',
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 - 6.w,
              textEditingController: TextEditingController(),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Кем выдан',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Дата выдачи',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
      ],
    );
  }
}
