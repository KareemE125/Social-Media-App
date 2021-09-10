import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/components/app_text_form_field.dart';
import 'package:social_media_app/constants.dart';
import 'package:social_media_app/cubit/login_cubit.dart';
import 'package:social_media_app/cubit/login_states.dart';
import 'package:social_media_app/screens/auth_screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _userEmail, _userPassword;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      ' Login',
                      style: TextStyle(
                          fontSize: 35, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 50),
                    AppTextFormField(
                      prefixIcon: Icons.email,
                      label: 'Email',
                      textInputType: TextInputType.emailAddress,
                      onSaved: (value) { _userEmail = value!; },
                      onValidate: (value)
                      {
                        if (value!.trim().isEmpty) { return 'please enter an email.'; }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    AppTextFormField(
                      prefixIcon: Icons.lock,
                      label: 'Password',
                      textInputType: TextInputType.visiblePassword,
                      isHidden: true,
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                      onValidate: (value) {
                        if (value!.trim().isEmpty) {
                          return 'please enter a password.';
                        } else if (value.length < 8) {
                          return 'password must be at least 8 characters.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    state is LoginLoadingState
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kBlueColor),
                                overlayColor:
                                    MaterialStateProperty.all(kRedColor),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: 12))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await LoginCubit.get(context).login(_userEmail, _userPassword, context);
                              }
                            },
                          ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?'),
                        TextButton(
                          child: Text("SignUp ", style: TextStyle(color: Colors.blue[600])),
                          onPressed: () => Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
