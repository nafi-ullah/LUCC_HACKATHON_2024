import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lucchack/constants/theming.dart';
import 'package:lucchack/featurepages/today_page.dart';
import 'package:lucchack/providers/calander_time_provider.dart';
import 'package:lucchack/providers/time_provider.dart';
import 'package:lucchack/providers/user_provider.dart';
import 'package:lucchack/screens/auth/SplashScreen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeProvider()),
        ChangeNotifierProvider(create: (_) => SelectedTimeChangeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const TodayPage();
        },
      ),
    );
  }
}