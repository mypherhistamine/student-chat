// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart';
// import 'package:loading/loading.dart';
// import 'package:provider/provider.dart';
// import 'package:studlife_chat/auth/changeNotifiers/AuthenticatedUser.dart';
// import 'package:studlife_chat/screens/register.dart';
// import 'package:studlife_chat/auth/verifyUser.dart';
// import 'package:studlife_chat/auth/wrapperBloc/AuthBloc.dart';
// import 'package:studlife_chat/constants/themes.dart';
// import 'package:studlife_chat/menu/screens/rooms_page.dart';
// import 'package:dio/dio.dart' as dio;
// import 'changeNotifiers/AuthService.dart';

// class Wrapper extends StatelessWidget {
//   const Wrapper({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);

//     if (user == null) {
//       return RegisterUserPage(title: 'Welcome to the Countdown App');
//     } else if (!user.isEmailVerified) {
//       return VerifyUserPage();
//     } else {
//       return _UserNameCheck2();
//     }
//   }

//   _UserNameCheck() {
//     //TODO: convert to stream rather than this messy setup.
//     return FutureBuilder(
//         future: AuthService.getUserDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (snapshot.data is String) {
//               if (snapshot.data == "PUT_USER") {
//                 return RoomsPage(
//                   askUsername: true,
//                 );
//               }

//               return Center(child: Text(snapshot.data));
//             } else if (snapshot.data is bool) {
//               if (snapshot.data)
//                 return RoomsPage();
//               else
//                 return Scaffold(
//                   backgroundColor: ThemeConstants.BGCOLOR_DARK,
//                   body: Center(
//                     child: Text(
//                       "An error occured. Please delete the app's cache and try again.",
//                       style: TextStyle(color: ThemeConstants.BGCOLOR_DARK_COMP),
//                     ),
//                   ),
//                 );
//             } else {
//               if (snapshot.data is dio.Response) {
//                 return RoomsPage();
//               } else if (snapshot.data is DioError) {
//                 //TODO:
//                 return Container();
//               } else {
//                 //TODO:
//                 return Container();
//               }
//             }
//           } else
//             return Center(child: CircularProgressIndicator());
//         });
//   }

//   _UserNameCheck2() {
//     return BlocProvider(
//       create: (ctx) => AuthBloc(),
//       lazy: false,
//       child: BlocBuilder<AuthBloc, AuthState>(
//         builder: (ctx, state) {
//           if (state is InitialState) {
//             BlocProvider.of<AuthBloc>(ctx).add(CheckUsername());
//             return _ScafIt(child: CircularProgressIndicator());
//           }
//           if (state is ErrorState) {
//             return _tryAgain(onPressed: () {
//               BlocProvider.of<AuthBloc>(ctx).add(NetworkError());
//             });
//           }
//           if (state is UserState) {
//             return RoomsPage();
//           }
//           if (state is GetNameState) {
//             return RoomsPage(
//               askUsername: true,
//             );
//           }
//         },
//       ),
//     );
//   }

//   _tryAgain({onPressed}) {
//     return _ScafIt(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         RawMaterialButton(
//           onPressed: onPressed,
//           child: Icon(Icons.refresh),
//           shape: CircleBorder(),
//           fillColor: Colors.blueAccent,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Text("Error Occured, Try Again.")
//       ],
//     ));
//   }

//   _ScafIt({child}) {
//     return Scaffold(
//       body: Center(child: child),
//       backgroundColor: ThemeConstants.BGCOLOR_DARK,
//     );
//   }
// }
