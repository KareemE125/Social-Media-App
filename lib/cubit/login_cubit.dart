import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restart/flutter_restart.dart';


import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/login_states.dart';
import 'package:social_media_app/main.dart';
import 'package:social_media_app/models/current_user.dart';
import 'package:social_media_app/screens/app_layout_screen.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> _createUser(String uid, String email, String name, BuildContext context) async
  {
    emit(CreateUserLoadingState());
    try
    {
      CurrentUser(uid,email,name);
      await FirebaseFirestore.instance.collection('Users')
          .doc(uid).set(CurrentUser.toMap());
      emit(CreateUserSuccessState());
    }
    catch(error)
    {
      emit(CreateUserErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> login(String email, String password, BuildContext context) async
  {
    emit(LoginLoadingState());
    try
    {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacementNamed(AppLayoutScreen.routeName);
      emit(LoginSuccessState());
    }
    catch(error)
    {
      emit(LoginErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> signUp(String name, String email, String password, BuildContext context) async
  {
    emit(SignUpLoadingState());
    try
    {
      UserCredential userCredential = await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      await _createUser(userCredential.user!.uid, email, name, context);

      Navigator.of(context).pushReplacementNamed(AppLayoutScreen.routeName);
      emit(SignUpSuccessState());
    }
    catch(error)
    {
      emit(SignUpErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

  Future<void> logout(BuildContext context) async
  {
    emit(LogoutLoadingState());
    try
    {
     // LoadingSpinner(context);
      //CurrentUser.uid = null;
      //AppCubit.user = null;
      //emit(LogoutSuccessState());
      await FirebaseAuth.instance.signOut();
      // Navigator.of(context).pop();
      //main();
      await FlutterRestart.restartApp();
      emit(LogoutSuccessState());
      //runApp(MyApp());
      //await Restart.restartApp();
    }
    catch(error)
    {
      emit(LogoutErrorState());
      String message = error.toString().substring(error.toString().indexOf("]")+1).trim();
      toast(context,message);
    }
  }

}


