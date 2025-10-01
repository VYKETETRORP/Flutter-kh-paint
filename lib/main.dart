//Simple HelloWorld
import 'package:flutter/material.dart';
import 'home_screen.dart';
// import 'login.dart';
import "form.dart";

void main() {
  runApp(const MyProgram());
}

class MyProgram extends StatelessWidget {

  const MyProgram({super.key});
  @override

  Widget build (BuildContext context){

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Moew Moew Movie",
      // theme:  ThemeData.dark().copyWith(
        // scaffoldBackgroundColor: Colors.black,
      // ),
      // home: const LoginScreen(),
      home: const HomeScreen(),
      // home:  AddIllustrationForm (),
      // routes: {
      //   '/add-illustration': (context) => AddIllustrationForm(),
      // },
    );
  }

}