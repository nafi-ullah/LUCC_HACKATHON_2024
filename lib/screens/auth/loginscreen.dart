
import 'package:flutter/material.dart';
import 'package:lucchack/constants/theming.dart';
import 'package:lucchack/router.dart';
import 'package:lucchack/screens/homescreen/homescreen.dart';
import 'package:lucchack/services/auth_services.dart';
import 'package:lucchack/widgets/authwidgets/button_widget.dart';
import 'package:lucchack/widgets/authwidgets/textField.dart';
import 'package:lucchack/widgets/authwidgets/text_widget.dart';
// import 'package:lucchack/screens/homescreen/adminHomeScreen.dart';
// import 'package:lucchack/screens/homescreen/employeeDashboard.dart';
// import 'package:lucchack/services/auth_service.dart';
// import 'package:lucchack/widgets/authWidgets/button_widget.dart';
// import 'package:lucchack/widgets/authWidgets/textField.dart';
// import 'package:lucchack/widgets/authWidgets/text_widget.dart';



class LoginScreen extends StatefulWidget {

  static const String routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthServices authService = AuthServices();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    // authService.signInUser(
    //     context: context,
    //     email: emailController.text,
    //     password: passwordController.text
    // );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void loginEmployee() {
    // authService.signInUser(
    //     context: context,
    //     email: emailController.text,
    //     password: passwordController.text
    // );

    // Navigator.push(
    //   context,
    //   // generateRoute(
    //   //     RouteSettings(name: HomeScreen.routeName)
    //   // ),
    //  // MaterialPageRoute(builder: (context) => EmployeeDashboard()), // same as above
    //   //(route) => false
    // );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              height: 50,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 3.5,
                child: Image.asset("assets/images/img.png"),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 21.0),
              height: MediaQuery.of(context).size.height / 1.67,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        title: "Log-in",
                        txtSize: 30,
                        txtColor: Theme.of(context).primaryColor,
                      ),
                    ],),

                  TextWidget(
                    title: "Email",
                    txtSize: 22,
                    txtColor: kPrimaryColor,
                  ),
                  InputTxtField(
                    hintText: "Your Email Address",
                    controller: emailController,
                    validator: null,
                    obscureText: false,
                  ),
                  TextWidget(
                    title: "Password",
                    txtSize: 22,
                    txtColor: kPrimaryColor,
                  ),
                  InputTxtField(
                    hintText: "Password",
                    controller: passwordController,
                    validator: null,
                    obscureText: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>  MyPhone()
                          //     )
                          // );
                        },
                        child: TextWidget(
                          title: "Forget password?",
                          txtSize: 18,
                          txtColor: const Color(0xff999a9e),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ButtonWidget(
                      textSize: 20,
                      btnText: "Login as Citizen",
                      onPress: login,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ButtonWidget(
                      textSize: 20,
                      btnText: "Login ",
                      onPress: loginEmployee,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}