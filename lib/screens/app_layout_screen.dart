import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:social_media_app/components/shifting_tab.dart';
import 'package:social_media_app/components/toast.dart';
import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';
import 'package:social_media_app/cubit/login_cubit.dart';
import 'package:social_media_app/models/current_user.dart';
import 'package:social_media_app/screens/info_screen.dart';


class AppLayoutScreen extends StatelessWidget
{

  static const routeName = '/app-layout-screen';

  bool isInit = true;
  bool isResendBtnEnabled = true;
  bool isRefreshBtnEnabled = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        final cubit = AppCubit.get(context);
        if (isInit)
        {
          isInit = false;
          cubit.getUserData(context);
          FirebaseFirestore.instance.collection('Users').snapshots()
              .listen((event) => cubit.getUserData(context));
        }

        Widget notVerifiedScreen()
        {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.mark_email_unread_rounded, size: 50),
                    SizedBox(height: 20),
                    Text(
                      'Please Check Your Email For Verification',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '\nyou need to verify your email first',
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50),
                    state is AppAssignUserLoadingState
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                        child: Text('Refresh', style: TextStyle(fontSize: 20),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kBlueColor,),
                          overlayColor: MaterialStateProperty.all(kRedColor,),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12),),
                        ),
                        onPressed: (){
                          if(isRefreshBtnEnabled)
                          {
                            cubit.assignUser(context)
                                .then((value) => toast(context, 'Refreshed', Colors.grey.shade900),);
                            isRefreshBtnEnabled = false;
                            Future.delayed(Duration(minutes: 1)).then((value) => isRefreshBtnEnabled = true);
                          }
                          else
                            {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              toast(context, 'Please check your email for verification.', Colors.grey.shade900);
                            }

                        },
                    ),
                    TextButton(
                      child: Text("resend verification email ",
                          style: TextStyle(color: Colors.redAccent)),
                      onPressed: () {
                        if(isResendBtnEnabled)
                        {
                          FirebaseAuth.instance.currentUser!.sendEmailVerification()
                              .then((value) => toast(context, 'email sent.', Colors.grey.shade900),);
                          isResendBtnEnabled = false;
                          Future.delayed(Duration(minutes: 1)).then((value) => isResendBtnEnabled = true);
                        }
                        else
                        {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          toast(context, 'Please wait of minimum a second between each resend request.', Colors.grey.shade900);
                        }

                      }
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        AppBar homeAppBar(context)
        {
          return !AppCubit.user!.emailVerified
          ? AppBar(
              title: Text('Social Media'),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async =>
                  await LoginCubit.get(context).logout(context),
                ),
              ],
            )
          : AppBar(
                title: Text('Social Media'),
                bottom: PreferredSize(
                    preferredSize: Size.fromHeight(30),
                    child: Column(
                      children: [
                        Divider(color: Colors.white12,thickness: 0.5,height: 0.5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.5),
                          child: ShiftingTabBar(
                            forceUpperCase: false,
                            color: Colors.transparent,
                            labelFlex: 1,
                            labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16, height: 2,),
                            tabs: [
                              shiftingTab(FontAwesomeIcons.home, 'Home',),
                              shiftingTab(FontAwesomeIcons.solidPaperPlane, 'Chats',),
                              shiftingTab(FontAwesomeIcons.solidBell, 'alerts',),
                              shiftingTab(FontAwesomeIcons.userAlt, 'Profile',),
                            ],
                          ),
                        ),
                        Divider(color: Colors.white12,thickness: 0.5,height: 0.5,),
                      ],
                    )
                ),
                actions: [
                  IconButton(
                    icon: Icon(FontAwesomeIcons.infoCircle,size: 21,),
                    onPressed: () => Navigator.of(context).pushNamed(InfoScreen.routeName),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.signOutAlt,size: 21,),
                    onPressed: () async =>
                    await LoginCubit.get(context).logout(context),
                  ),
                ],
              );
        }

        return DefaultTabController(
          length: AppCubit.screensList.length,
          child: Scaffold(
              appBar: homeAppBar(context),
              body: !AppCubit.user!.emailVerified
                    ? notVerifiedScreen()
                    /// "CurrentUser.uid == null" cause assigning of current user takes time
                    /// or the states listening is not good here
                    : CurrentUser.uid == null
                        ? Center(child: CircularProgressIndicator())
                        : TabBarView( children: AppCubit.screensList ),
          ),
        );
      },
    );
  }
}