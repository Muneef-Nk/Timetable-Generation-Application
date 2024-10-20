import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/feature/bottom_navigation/controller/bottom_controller.dart';
import 'package:timetable_generation_application/feature/bottom_navigation/view/bottom_bar_view.dart';
import 'package:timetable_generation_application/feature/course/controller/course_controller.dart';
import 'package:timetable_generation_application/feature/periods/controller/days_periods_controller.dart';
import 'package:timetable_generation_application/feature/splash_screen.dart';
import 'package:timetable_generation_application/feature/staff/controller/staff_controller.dart';
import 'package:timetable_generation_application/feature/subjects/controller/subject_controller.dart';
import 'package:timetable_generation_application/feature/timetable/controller/timetable_controller.dart';
import 'package:timetable_generation_application/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => BottomNavigationController()),
        ChangeNotifierProvider(create: (context) => CourseController()),
        ChangeNotifierProvider(create: (context) => SubjectController()),
        ChangeNotifierProvider(create: (context) => StaffController()),
        ChangeNotifierProvider(create: (context) => PeriodsController()),
        ChangeNotifierProvider(create: (context) => TimetableController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
