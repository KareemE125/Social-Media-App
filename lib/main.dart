import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/bloc_observer.dart';
import 'package:social_media_app/cubit/login_cubit.dart';
import 'package:social_media_app/screens/add_post_screen.dart';
import 'package:social_media_app/screens/app_layout_screen.dart';
import 'package:social_media_app/screens/friends_screen.dart';
import 'package:social_media_app/screens/nav_screens/home_screen.dart';
import 'package:social_media_app/screens/info_screen.dart';
import 'package:social_media_app/screens/auth_screens/login_screen.dart';
import 'package:social_media_app/screens/auth_screens/signup_screen.dart';
import 'package:social_media_app/screens/pick_to_chat_screen.dart';
import 'package:social_media_app/screens/update_profile_screen.dart';

void main() async
{
  runApp(Loading());

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

   await Firebase.initializeApp()
   .then((value) => FirebaseAuth.instance.authStateChanges().listen((user){ AppCubit.user = user; }));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider( create:(_) => LoginCubit() ),
        BlocProvider( create:(_) => AppCubit() ),
      ],
      child: MaterialApp(
        title: 'Social Media',
        debugShowCheckedModeBanner: false,
        theme: kAppTheme,
        home: AppCubit.user != null ? AppLayoutScreen() : LoginScreen(),
        routes: {
          LoginScreen.routeName: (_) => LoginScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
          AppLayoutScreen.routeName: (_) => AppLayoutScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          InfoScreen.routeName: (_) => InfoScreen(),
          UpdateProfileScreen.routeName: (_) => UpdateProfileScreen(),
          AddPostScreen.routeName: (_) => AddPostScreen(),
          PickToChatScreen.routeName: (_) => PickToChatScreen(),
          FriendsScreen.routeName: (_) => FriendsScreen(),
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media',
      debugShowCheckedModeBanner: false,
      theme: kAppTheme,
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      )
    );
  }
}