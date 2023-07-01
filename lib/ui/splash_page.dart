import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/ui/home_page.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 10),(){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/json/lottie.json",height: 200 , width: 200,repeat: true,reverse: false),
      ),
    );
  }
}
