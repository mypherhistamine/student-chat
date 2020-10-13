import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:studlife_chat/auth/changeNotifiers/AuthService.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc() : super(InitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    final currentState = state;

    if(currentState is UserState)
    {
      //do nothing.
      return;
    }

    if(event is NetworkError)
    {
      yield InitialState();
      return;
    }

    if(event is CheckUsername)
    {
      try{
       dynamic result = await AuthService.getUserDetails();
       if(result is bool)
       {
         yield GetNameState();
         return;
       }
         //user object
         yield UserState(username: result.data["username"],userObject: result.data);
       
      }catch(e)
      {
        print("auth bloc error $e");
        if(e is Map && e.containsKey("error"))
        yield ErrorState(error: e["error"],errorName: e["errorName"]);
        else yield ErrorState();
      }
    }
  }

}

class AuthState {
}

class InitialState extends AuthState {

}


class ErrorState extends AuthState {
  final dynamic error;
  final String errorName;
  ErrorState({this.error,this.errorName});
}

class UserState extends AuthState {
  final String username;
  final dynamic userObject;

  UserState({@required this.username,this.userObject, });
  
}

class GetNameState extends AuthState {

}

class AuthEvent {

}

class CheckUsername extends AuthEvent {

}

class RegisterUsername extends AuthEvent {

}

class NetworkError extends AuthEvent {

}

class UserError extends AuthEvent {

}