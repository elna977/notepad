import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notepad/homeScreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child:MaterialApp(
        home: const WelcomeScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30.h,),
          Center(
            child: Container(
              height: 300.h,
                width: 200.w,
                child: Image(image: AssetImage("images/thinks.jpg")).animate().fade(duration: 700.ms).scale(delay: 500.ms)),
          ),

             Text("NotePad",style: TextStyle(
              fontSize: 30.sp,color: Colors.blue[400],fontWeight: FontWeight.bold
            ),).animate().fade(duration: 700.ms).scale(delay: 500.ms),
          SizedBox(height: 30.h,),
          SizedBox(
            height: 50.h,
            width: 200.w,
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            }, child: Text("Start to write note",style: TextStyle(
              color: Colors.white,fontSize: 20.sp
            ),),style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[400]),),
          )
        ],
      ),
    );
  }
}
