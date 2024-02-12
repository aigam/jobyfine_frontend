import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitState()) {
    on<GetProfileEvent>(_getProfile);
    on<UpdateProfileEvent>(_updateProfile);
    on<UpdateProfileTaskEvent>(_updateProfileTask);
    on<UpdateProfileWithoutUserEvent>(_updateProfileWithoutUser);
    on<UpdateProfilePhotoEvent>(_updateProfilePhoto);
    on<UpdateProfileCvEvent>(_updateProfileCv);
    on<UpdateProfileWithoutLoadingEvent>(_updateWithoutLoadingProfile);
    on<GetCategorieProfileEvent>(_getCategories);
    on<EditPageSearchEvent>(_editPage);
  }

  String? access;
  UserRegModel? user;
  List<TaskCategory> activities = [];

  void logout() async {
    await Storage().clearData();
  }

  void setAccess(String? accessToken) async {
    access = accessToken;
    await Storage().setAccessToken(accessToken);
  }

  void setUser(UserRegModel? user) => this.user = user;

  void _editPage(
    EditPageSearchEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(EditPageState(event.page, event.text));
  }

  void _updateProfileTask(
    UpdateProfileTaskEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(UpdateProfileTaskState());
  }

  void _updateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadProfileState());
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
    print("updateProfile----0");
    if (access != null) {
      print("updateProfile----1");
      UserRegModel? res =
          await Repository().updateUser(access!, event.newUser!);
      if (res != null) {
        print("updateProfile----2");
        user = res;
      }
      emit(UpdateProfileSuccessState());
      print("updateProfile----3");
    }
  }

  void _updateProfileWithoutUser(
    UpdateProfileWithoutUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadProfileState());
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
    if (access != null) {
      UserRegModel? res = await Repository().updateUser(access!, user!);
      if (res != null) {
        user = res;
        emit(UpdateProfileSuccessState());
      }
    }
  }

  void _getCategories(
      GetCategorieProfileEvent event, Emitter<ProfileState> emit) async {
    List<TaskCategory>? res = await Repository().getCategories();
    activities = res;
    emit(GetCategoriesProfileState(activities: res));
  }

  void _updateProfilePhoto(
    UpdateProfilePhotoEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // emit(LoadProfileState());
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
    if (access != null) {
      UserRegModel? res =
          await Repository().updateUserPhoto(access!, event.photo);
      if (res != null) {
        user?.copyWith(photoLink: res.photoLink);
        emit(UpdateProfileSuccessState());
      } else {
        emit(UpdateProfileErrorState());
      }
    }
  }

  void _updateProfileCv(
    UpdateProfileCvEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadProfileState());
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
    if (access != null) {
      UserRegModel? res = await Repository().updateUserCv(
          access!, event.file, event.images.isNotEmpty ? event.images : null);
      if (res != null) {
        user = res;
        emit(UpdateProfileSuccessState());
      } else {
        emit(UpdateProfileErrorState());
      }
    }
  }

  void _updateWithoutLoadingProfile(
    UpdateProfileWithoutLoadingEvent event,
    Emitter<ProfileState> emit,
  ) async {
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
    user = event.newUser;

    if (access != null) {
      UserRegModel? res = await Repository().updateUser(access!, user!);
      if (res != null) {
        user = res;
        emit(UpdateProfileSuccessState());
      }
    }
  }

  void _getProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(LoadProfileState());
    String? accessToken = Storage().getAccessToken();
    access = accessToken;
    if (access != null) {
      UserRegModel? res = await Repository().getProfile(access!);
      if (res != null) {
        user = res;
        emit(LoadProfileSuccessState());
      }
    }
    emit(ProfileInitState());
  }
}
