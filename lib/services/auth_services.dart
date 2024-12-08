import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lucchack/constants/error_handling.dart';
import 'package:lucchack/constants/theming.dart';
import 'package:lucchack/models/auth_model.dart';
import 'package:lucchack/providers/user_provider.dart';
import 'package:lucchack/router.dart';

import '../screens/homescreen/homescreen.dart';
// import 'package:lucchack/screens/homescreen/adminHomeScreen.dart';
// import 'package:lucchack/screens/welcome/loginscreen.dart';
// import 'package:lucchack/screens/welcome/otpVerify.dart';
// import 'package:lucchack/widgets/citizenFeatures/issueScreen/issueFeed.dart';

class AuthServices {



  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(Uri.parse('$uri/auth/login'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            // "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Accept': '*/*'
          });

//      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            // log in er por token store kore rakhbo jeno barbar log in krte na hoy

            SharedPreferences prefs = await SharedPreferences.getInstance();
            Map<String, dynamic> json = jsonDecode(res.body as String);
            User loggeduser = User.fromMap(json);

            print(loggeduser.id);
            print(loggeduser.username);
            print(loggeduser.email);
            print(loggeduser.roleName);
            print(loggeduser.token);

            Provider.of<UserProvider>(context, listen: false)
                .setUser(loggeduser);
            await prefs.setString(
                'Authentication', jsonDecode(res.body)['token']);

            final user = Provider.of<UserProvider>(context, listen: false).user;

            print(user.toJson());

            //shared preference a jst token ta thakbe
            Navigator.pushAndRemoveUntil(
                context,
                generateRoute(RouteSettings(name: HomeScreen.routeName)),
                //MaterialPageRoute(builder: (context) => HomeScreen()), same as above
                    (route) => false);
          });
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }


}