import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:open_file/open_file.dart';

class Customer extends StatefulWidget {
  Function(int) stage;

  Customer(this.stage, {super.key});
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  TextEditingController experienceController = TextEditingController();

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
  TextEditingController serialDocController = TextEditingController();
  TextEditingController numberDocController = TextEditingController();
  TextEditingController whoGiveDocController = TextEditingController();
  TextEditingController dateDocController = TextEditingController();
  TextEditingController documentTypeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  String? gender;
  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  List<String> typeDocument = [];
  List<String> typeWork = [];
  TextEditingController aboutMeController = TextEditingController();
  File? image;
  bool confirmTermsPolicy = false;
  final GlobalKey _countryKey = GlobalKey();
  final GlobalKey _regionKey = GlobalKey();
  DateTime? dateTimeStart;
  DateTime? dateTimeEnd;
  UserRegModel user = UserRegModel(isEntity: false);
  List<Activities> listCategories = [];
  bool physics = false;

  FocusNode focusNodeAbout = FocusNode();
  FocusNode focusNodeName = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword1 = FocusNode();
  FocusNode focusNodePassword2 = FocusNode();
  FocusNode focusNodeSerial = FocusNode();
  FocusNode focusNodeNumber = FocusNode();
  FocusNode focusNodeWhoTake = FocusNode();

  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  List<Countries> listCountries = [];
  Countries? selectCountries;

  List<Regions> listRegions = [];

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      File? file = File(getMedia.path);
      image = file;
      user.copyWith(photo: image?.readAsBytesSync());
    }
    setState(() {});
  }

  void requestNextEmptyFocusStage1() {
    if (firstnameController.text.isEmpty) {
      focusNodeName.requestFocus();
      scrollController1.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (lastnameController.text.isEmpty) {
      focusNodeLastName.requestFocus();
      scrollController1.animateTo(50.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (phoneController.text.isEmpty) {
      focusNodePhone.requestFocus();
      scrollController1.animateTo(100.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (emailController.text.isEmpty) {
      focusNodeEmail.requestFocus();
      scrollController1.animateTo(150.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  void requestNextEmptyFocusStage2() {
    if (passwordController.text.isEmpty) {
      focusNodePassword1.requestFocus();
      scrollController2.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (repeatPasswordController.text.isEmpty) {
      focusNodePassword2.requestFocus();
      scrollController2.animateTo(50.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (additionalInfo) {
      if (serialDocController.text.isEmpty) {
        focusNodeSerial.requestFocus();
        scrollController2.animateTo(150.h,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else if (numberDocController.text.isEmpty) {
        focusNodeNumber.requestFocus();
        scrollController2.animateTo(150.h,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else if (whoGiveDocController.text.isEmpty) {
        focusNodeWhoTake.requestFocus();
        scrollController2.animateTo(150.h,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, snapshot) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
          Loader.hide();
          if (current is CheckUserState) {
            if (current.error != null) {
              showAlertToast(
                  'Пользователь с такой почтой или номером телефона уже зарегистрирован');
            } else {
              page = 1;
              widget.stage(2);
            }
          } else if (current is SendProfileSuccessState) {
            Navigator.of(context).pushNamed(AppRoute.confirmCodeRegister,
                arguments: [phoneController.text]);
          } else if (current is GetCategoriesState) {
            listCategories.clear();
            listCategories.addAll(current.res);
          } else if (current is SendProfileErrorState) {
            String messageError = 'Ошибка\n';
            if (current.error!['email'] != null &&
                current.error!['email'][0] != null) {
              String email = current.error!['email'][0];
              if (email
                  .contains('custom user with this Email already exists.')) {
                messageError =
                    'Пользователь с такой почтой уже зарегистрирован';
              } else if (email.contains('Enter a valid email address.')) {
                messageError = 'Введите корректный адрес почты';
              }
            } else if (current.error!['phone_number'] != null &&
                current.error!['phone_number'][0] != null) {
              String phoneNumber = current.error!['phone_number'][0];
              if (phoneNumber
                  .contains('custom user with this Телефон already exists.')) {
                messageError =
                    'Пользователь с таким телефоном уже зарегистрирован';
              } else if (phoneNumber
                  .contains('The phone number entered is not valid.')) {
                messageError = 'Введите корректный номер телефона';
              }
            }
            showAlertToast(messageError);
          }
          return false;
        }, builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                  child: page == 0
                      ? firstStage(heightKeyBoard)
                      : secondStage(heightKeyBoard)),
              SizedBox(height: 10.h),
              CustomButton(
                onTap: () {
                  if (page == 0) {
                    requestNextEmptyFocusStage1();
                    String error = 'Укажите:';
                    bool errorsFlag = false;
                    if (firstnameController.text.isEmpty) {
                      error += '\n- имя';
                      errorsFlag = true;
                    }
                    if (lastnameController.text.isEmpty) {
                      error += '\n- фамилию';
                      errorsFlag = true;
                    }
                    if (phoneController.text.isEmpty) {
                      error += '\n- мобильный номер';
                      errorsFlag = true;
                    }
                    if (emailController.text.isEmpty) {
                      error += '\n- почту';
                      errorsFlag = true;
                    }

                    String email = emailController.text;

                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email);

                    if (errorsFlag) {
                      showAlertToast(error);
                    } else if (!emailValid) {
                      showAlertToast('Введите корректный адрес почты');
                    } else if (emailController.text
                            .split('@')
                            .last
                            .split('.')
                            .last
                            .length <
                        2) {
                      showAlertToast('- Введите корректный адрес почты');
                    } else if (phoneController.text.length < 12) {
                      showAlertToast('- Некорректный номер телефона.');
                    } else if (!confirmTermsPolicy) {
                      showAlertToast(
                          'Необходимо дать согласие на обработку персональных данных и пользовательское соглашение');
                    } else {
                      showLoaderWrapper(context);
                      BlocProvider.of<AuthBloc>(context).add(
                          CheckUserExistEvent(
                              phoneController.text, emailController.text));
                    }
                  } else {
                    requestNextEmptyFocusStage2();
                    user.copyWith(groups: [3]);
                    String error = 'Укажите:';
                    bool errorsFlag = false;

                    if (passwordController.text.isEmpty ||
                        repeatPasswordController.text.isEmpty) {
                      error += '\n- пароль';
                      errorsFlag = true;
                    }

                    if (countryController.text.isEmpty) {
                      error += '\n- страну';
                      errorsFlag = true;
                    }
                    if (regionController.text.isEmpty) {
                      error += '\n- регион';
                      errorsFlag = true;
                    }

                    if (additionalInfo) {
                      if (serialDocController.text.isEmpty &&
                          user.docType != 'Resident_ID') {
                        error += '\n- серию документа';
                        errorsFlag = true;
                      }
                      if (numberDocController.text.isEmpty) {
                        error += '\n- номер документа';
                        errorsFlag = true;
                      }
                      if (whoGiveDocController.text.isEmpty) {
                        error += '\n- кем был выдан документ';
                        errorsFlag = true;
                      }
                      if (dateDocController.text.isEmpty) {
                        error += '\n- дату выдачи документа';
                        errorsFlag = true;
                      }
                    }

                    if (errorsFlag) {
                      if ((passwordController.text.isNotEmpty &&
                              repeatPasswordController.text.isNotEmpty) &&
                          (passwordController.text !=
                              repeatPasswordController.text)) {
                        error += '\n\nПароли не совпадают';
                      }
                      showAlertToast(error);
                    } else if (passwordController.text.length < 6) {
                      showAlertToast('- минимальная длина пароля 6 символов');
                    } else if ((passwordController.text.isNotEmpty &&
                            repeatPasswordController.text.isNotEmpty) &&
                        (passwordController.text !=
                            repeatPasswordController.text)) {
                      showAlertToast('Пароли не совпадают');
                    } else if (dateTimeEnd != null &&
                        DateTime.now().isAfter(dateTimeEnd!)) {
                      showAlertToast('Ваш паспорт просрочен');
                    } else if (checkExpireDate(dateTimeEnd) != null) {
                      showAlertToast(checkExpireDate(dateTimeEnd)!);
                    } else {
                      showLoaderWrapper(context);
                      documentEdit();
                      BlocProvider.of<AuthBloc>(context)
                          .add(SendProfileEvent(user));
                    }
                  }
                },
                btnColor: page == 0
                    ? confirmTermsPolicy
                        ? ColorStyles.yellowFFD70A
                        : ColorStyles.greyE0E6EE
                    : passwordController.text.isNotEmpty &&
                            repeatPasswordController.text.isNotEmpty &&
                            regionController.text.isNotEmpty &&
                            countryController.text.isNotEmpty
                        ? ColorStyles.yellowFFD70A
                        : ColorStyles.greyE0E6EE,
                textLabel: Text(
                  page == 0 ? 'Далее' : 'Зарегистрироваться',
                  style: CustomTextStyle.black_16_w600_171716,
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
                btnColor: ColorStyles.greyE0E6EE,
                textLabel: Text(
                  'Назад',
                  style: CustomTextStyle.black_16_w600_515150,
                ),
              ),
              SizedBox(height: 34.h),
            ],
          );
        }),
      );
    });
  }

  Widget firstStage(double heightKeyBoard) {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      controller: scrollController1,
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: 'Ваше имя*',
          focusNode: focusNodeName,
          hintStyle: CustomTextStyle.grey_14_w400,
          height: 50.h,
          textEditingController: firstnameController,
          formatters: [
            UpperTextInputFormatter(),
            FilteringTextInputFormatter.allow(RegExp("[а-яА-Яa-zA-Z- -]")),
          ],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(firstname: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Ваша фамилия*',
          focusNode: focusNodeLastName,
          hintStyle: CustomTextStyle.grey_14_w400,
          height: 50.h,
          textEditingController: lastnameController,
          formatters: [
            UpperTextInputFormatter(),
            FilteringTextInputFormatter.allow(RegExp("[а-яА-Яa-zA-Z- -]")),
          ],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(lastname: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Text(
              'Ваш пол',
              style: CustomTextStyle.black_14_w400_171716,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = 0;
                  gender = 'Мужчина';
                  user.copyWith(sex: groupValue == 0 ? true : false);
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
                  user.copyWith(sex: groupValue == 0 ? true : false);
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
          hintText: 'Номер телефона*',
          hintStyle: CustomTextStyle.grey_14_w400,
          height: 50.h,
          focusNode: focusNodePhone,
          textInputType: TextInputType.phone,
          textEditingController: phoneController,
          formatters: [
            MaskTextInputFormatter(
              mask: '+############',
              filter: {"#": RegExp(r'[0-9]')},
              type: MaskAutoCompletionType.eager,
            ),
          ],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(phoneNumber: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
          onTap: () {
            if (phoneController.text.isEmpty) phoneController.text = '+';
            Future.delayed(const Duration(milliseconds: 350), () {
              scrollController1.animateTo(200.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'E-mail*',
          hintStyle: CustomTextStyle.grey_14_w400,
          height: 50.h,
          focusNode: focusNodeEmail,
          textEditingController: emailController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(email: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
          onTap: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              scrollController1.animateTo(250.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: _selectImage,
          child: CustomTextField(
            hintText: 'Добавить фото',
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            enabled: false,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            suffixIcon: Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        SvgImg.gallery,
                        height: 15.h,
                        width: 15.h,
                      ),
                      if (user.photo != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 5.w),
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
            textEditingController: TextEditingController(),
          ),
        ),
        if (image != null) SizedBox(height: 6.h),
        if (image != null)
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  OpenFile.open(image?.path);
                },
                child: SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: 50.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.memory(
                            image!.readAsBytesSync(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            image = null;
                            user.photo = null;
                            setState(() {});
                          },
                          child: Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(color: Colors.black)
                                ],
                                borderRadius: BorderRadius.circular(40.r)),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 10.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 10.h),
        Text(
          '* - обязательные поля для заполнения',
          textAlign: TextAlign.start,
          style: CustomTextStyle.black_14_w400_515150,
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
              activeColor: ColorStyles.yellowFFD70A,
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  'Согласен на обработку персональных данных и с пользовательским соглашением',
                  style: CustomTextStyle.black_14_w400_515150
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        SizedBox(height: heightKeyBoard / 2),
      ],
    );
  }

  Widget secondStage(double heightKeyBoard) {
    listCountries.clear();
    listCountries.addAll(BlocProvider.of<CountriesBloc>(context).country);
    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      controller: scrollController2,
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: 'Пароль*',
          hintStyle: CustomTextStyle.grey_14_w400,
          height: 50.h,
          focusNode: focusNodePassword1,
          obscureText: !visiblePassword,
          suffixIcon: GestureDetector(
            onTap: () {
              visiblePassword = !visiblePassword;
              setState(() {});
            },
            child: visiblePassword
                ? const Icon(Icons.remove_red_eye_outlined)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye_close.svg',
                        height: 18.h,
                      ),
                    ],
                  ),
          ),
          textEditingController: passwordController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(password: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage2();
          },
          onTap: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              scrollController2.animateTo(0.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Повторите пароль*',
          hintStyle: CustomTextStyle.grey_14_w400,
          height: 50.h,
          focusNode: focusNodePassword2,
          obscureText: !visiblePasswordRepeat,
          suffixIcon: GestureDetector(
            onTap: () {
              visiblePasswordRepeat = !visiblePasswordRepeat;
              setState(() {});
            },
            child: visiblePasswordRepeat
                ? const Icon(Icons.remove_red_eye_outlined)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye_close.svg',
                        height: 18.h,
                      ),
                    ],
                  ),
          ),
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage2();
          },
          textEditingController: repeatPasswordController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onTap: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              scrollController2.animateTo(50.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          key: _countryKey,
          onTap: () => showCountry(
            context,
            _countryKey,
            (value) {
              countryController.text = value.name ?? '-';
              selectCountries = value;
              regionController.text = '';
              BlocProvider.of<CountriesBloc>(context)
                  .add(GetRegionEvent(selectCountries!));
              user.copyWith(country: countryController.text);
              setState(() {});
            },
            listCountries,
            'Выберите страну',
          ),
          child: CustomTextField(
            hintText: 'Страна*',
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            enabled: false,
            textEditingController: countryController,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) {},
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          key: _regionKey,
          onTap: () {
            if (countryController.text.isNotEmpty) {
              listRegions = selectCountries!.region;
              showRegion(
                context,
                _regionKey,
                (value) {
                  regionController.text = value.name ?? '-';
                  user.copyWith(region: regionController.text);
                  setState(() {});
                },
                listRegions,
                'Выберите регион',
              );
            } else {
              showAlertToast('Чтобы выбрать регион, сначала укажите страну');
            }
          },
          child: CustomTextField(
            hintText: 'Регион*',
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            enabled: false,
            textEditingController: regionController,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) {},
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () => showIconModal(
            context,
            GlobalKeys.keyIconBtn2,
            (value) {
              documentTypeController.text = value;
              additionalInfo = true;
              user.copyWith(
                docType: value == 'Паспорт РФ'
                    ? 'Passport'
                    : value == 'Резидент ID'
                        ? 'Resident_ID'
                        : 'International Passport',
              );
              setState(() {});
            },
            ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
            'Документ',
          ),
          child: Stack(
            key: GlobalKeys.keyIconBtn2,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: 'Документ',
                hintStyle: CustomTextStyle.grey_14_w400,
                height: 50.h,
                enabled: false,
                onTap: () {},
                fillColor: Colors.grey[200],
                textEditingController: documentTypeController,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    documentTypeController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              additionalInfo = false;
                              documentTypeController.text = '';
                              serialDocController.text = '';
                              numberDocController.text = '';
                              whoGiveDocController.text = '';
                              dateDocController.text = '';
                              dateTimeEnd = null;
                              dateTimeStart = null;
                              setState(() {});
                            },
                            child: const Icon(Icons.close),
                          )
                        : SvgPicture.asset(
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
        SizedBox(height: 10.h),
        Text(
          '* - обязательные поля для заполнения',
          textAlign: TextAlign.start,
          style: CustomTextStyle.black_14_w400_515150,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: physics,
              onChanged: (value) {
                setState(() {
                  user.copyWith(isEntity: value);
                  physics = !physics;
                });
              },
              checkColor: Colors.black,
              activeColor: ColorStyles.yellowFFD70A,
            ),
            Flexible(
              child: Text(
                'Представитель юридического лица',
                textAlign: TextAlign.justify,
                style: CustomTextStyle.black_14_w400_515150,
              ),
            ),
          ],
        ),
        SizedBox(height: heightKeyBoard / 2),
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
          children: [
            if (user.docType != 'Resident_ID')
              CustomTextField(
                hintText: 'Серия',
                hintStyle: CustomTextStyle.grey_14_w400,
                height: 50.h,
                focusNode: focusNodeSerial,
                onFieldSubmitted: (value) {
                  requestNextEmptyFocusStage2();
                },
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    scrollController2.animateTo(200.h,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.linear);
                  });
                },
                formatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                textInputType: TextInputType.number,
                width: ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 -
                    6.w,
                textEditingController: serialDocController,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                onChanged: (value) => documentEdit(),
              ),
            if (user.docType != 'Resident_ID') SizedBox(width: 12.w),
            CustomTextField(
              hintText: user.docType != 'Resident_ID' ? 'Номер' : 'Номер ID',
              focusNode: focusNodeNumber,
              hintStyle: CustomTextStyle.grey_14_w400,
              onFieldSubmitted: (value) {
                requestNextEmptyFocusStage2();
              },
              height: 50.h,
              textInputType: TextInputType.number,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  scrollController2.animateTo(200.h,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear);
                });
              },
              formatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              width: user.docType == 'Resident_ID'
                  ? MediaQuery.of(context).size.width - 30.w - 18.w
                  : ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 -
                      6.w,
              textEditingController: numberDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ],
        ),
        if (user.docType == 'Passport') SizedBox(height: 16.h),
        if (user.docType == 'Passport')
          CustomTextField(
            hintText: 'Кем выдан',
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear);
              });
            },
            focusNode: focusNodeWhoTake,
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            textEditingController: whoGiveDocController,
            onFieldSubmitted: (value) {
              requestNextEmptyFocusStage2();
            },
            formatters: [
              LengthLimitingTextInputFormatter(35),
            ],
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) => documentEdit(),
          ),
        if (user.docType != 'Resident_ID') SizedBox(height: 16.h),
        if (user.docType != 'Resident_ID')
          GestureDetector(
            onTap: () async {
              _showDatePicker(context, 0, true);
            },
            child: CustomTextField(
              hintText: 'Дата выдачи',
              enabled: false,
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 50.h,
              textEditingController: dateDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ),
        if (user.docType != 'Passport') SizedBox(height: 16.h),
        if (user.docType != 'Passport')
          GestureDetector(
            onTap: () async {
              _showDatePicker(context, 1, false);
            },
            child: CustomTextField(
              hintText: 'Срок действия',
              enabled: false,
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 50.h,
              textEditingController: whoGiveDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ),
        Text(
          checkExpireDate(dateTimeEnd) ?? '',
          style: CustomTextStyle.red_11_w400_171716,
        ),
        if (user.docType == 'Resident_ID') SizedBox(height: 16.h),
        if (user.docType == 'Resident_ID')
          CustomTextField(
            hintText: 'Место выдачи',
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear);
              });
            },
            focusNode: focusNodeWhoTake,
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            formatters: [
              LengthLimitingTextInputFormatter(35),
            ],
            textEditingController: dateDocController,
            onFieldSubmitted: (value) {
              requestNextEmptyFocusStage2();
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) => documentEdit(),
          ),
      ],
    );
  }

  void _showDatePicker(ctx, int index, bool isInternational) {
    DateTime initialDateTime = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month,
                dateTimeStart!.day + 2)
            : DateTime(DateTime.now().year - 15, DateTime.now().month,
                DateTime.now().day + 2)
        : dateTimeStart ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1);

    DateTime maximumDate = index == 1
        ? DateTime(
            DateTime.now().year + 15, DateTime.now().month, DateTime.now().day)
        : dateTimeEnd != null
            ? DateTime(
                dateTimeEnd!.year, dateTimeEnd!.month, dateTimeEnd!.day - 1)
            : DateTime(DateTime.now().year + 15, DateTime.now().month,
                DateTime.now().day);

    DateTime minimumDate = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month,
                dateTimeStart!.day + 1)
            : DateTime(DateTime.now().year - 15, DateTime.now().month,
                DateTime.now().day + 1)
        : DateTime(
            DateTime.now().year - 15, DateTime.now().month, DateTime.now().day);

    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.h,
                          color: Colors.white,
                          child: Row(
                            children: [
                              const Spacer(),
                              CupertinoButton(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                borderRadius: BorderRadius.zero,
                                child: Text(
                                  'Готово',
                                  style: TextStyle(
                                      fontSize: 15.sp, color: Colors.black),
                                ),
                                onPressed: () {
                                  if (index == 0) {
                                    if (dateTimeStart == null) {
                                      dateTimeStart = DateTime.now();
                                      if (isInternational) {
                                        dateDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      } else {
                                        whoGiveDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      }
                                    }
                                  } else {
                                    if (dateTimeEnd == null) {
                                      dateTimeEnd = DateTime.now();
                                      if (isInternational) {
                                        dateDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      } else {
                                        whoGiveDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      }
                                    }
                                  }

                                  Navigator.of(ctx).pop();
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 5.w),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 200.h,
                    color: Colors.white,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: initialDateTime,
                        minimumDate: minimumDate,
                        maximumDate: maximumDate,
                        onDateTimeChanged: (val) {
                          if (index == 0) {
                            dateTimeStart = val;
                            if (isInternational) {
                              dateDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            } else {
                              whoGiveDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            }
                            user.copyWith(
                                docInfo:
                                    'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          } else {
                            dateTimeEnd = val;
                            if (isInternational) {
                              dateDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            } else {
                              whoGiveDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            }
                            user.copyWith(
                                docInfo:
                                    'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          }
                        }),
                  ),
                ],
              ),
            ));
  }

  String? checkExpireDate(DateTime? value) {
    if (value != null) {
      if (value.difference(DateTime.now()).inDays < 30) {
        return 'Срок действия документа составляет менее 30 дней';
      }
    }
    return null;
  }

  void documentEdit() {
    user.copyWith(
      docInfo:
          'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}',
    );
  }
}
