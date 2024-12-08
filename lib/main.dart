import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lucchack/constants/theming.dart';
import 'package:lucchack/featurepages/today_page.dart';
import 'package:lucchack/providers/calander_time_provider.dart';
import 'package:lucchack/providers/time_provider.dart';
import 'package:lucchack/providers/user_provider.dart';
import 'package:lucchack/screens/auth/SplashScreen.dart';


import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp()));
}

MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  //final AuthServices authService = AuthServices();

  @override
  void initState() {
    super.initState();
    // authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_) => TimeProvider()),
        ChangeNotifierProvider(create: (_) => SelectedTimeChangeProvider())
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context , child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primarySwatch: Colors.grey),
              home: const TodayPage(),
            );
          }
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Auth Screen',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           brightness: Brightness.light,
//           primaryColor: kPrimaryColor,
//           scaffoldBackgroundColor: kBackgroundColor,
//           secondaryHeaderColor: ksecondaryHeaderColor,
//           inputDecorationTheme: InputDecorationTheme(
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.white.withOpacity(.2),
//               ),
//             ),
//           ),
//         ),
//         home: const SplashScreen() //ForumDashboard()//TaskListView()//CheckOut()//IssuePage()//
//     );
//
//   }
// }
