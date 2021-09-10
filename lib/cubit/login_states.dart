abstract class LoginStates{}

class LoginInitialState extends LoginStates{}

class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{}
class LoginErrorState extends LoginStates{}

class CreateUserLoadingState extends LoginStates{}
class CreateUserSuccessState extends LoginStates{}
class CreateUserErrorState extends LoginStates{}

class SignUpLoadingState extends LoginStates{}
class SignUpSuccessState extends LoginStates{}
class SignUpErrorState extends LoginStates{}

class LogoutLoadingState extends LoginStates{}
class LogoutSuccessState extends LoginStates{}
class LogoutErrorState extends LoginStates{}
