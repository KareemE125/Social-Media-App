import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:social_media_app/cubit/app_cubit.dart';
import 'package:social_media_app/cubit/app_states.dart';

class AlertsScreen extends StatelessWidget {
  static const routeName = '/alerts-screen';

  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        //final user = AppCubit.user;
        final cubit = AppCubit.get(context);
        if (isInit) {
          isInit = false;
          cubit.getUserData(context);
        }

        Widget noAlertsScreen()
        {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.solidBell, size: 50),
                SizedBox(height: 20),
                Text(
                  'There is no notifications',
                  style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return true
        ? noAlertsScreen()
        :Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Alerts'),
              ],
            ),
          ),
        );
      },
    );
  }
}