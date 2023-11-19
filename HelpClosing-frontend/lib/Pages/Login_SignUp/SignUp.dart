import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Pages/Login_SignUp/Login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _hidePassword=true;
  bool _rememberMe=false;


  void _togglePassword(){
    setState(() {
      _hidePassword=!_hidePassword;
    });
  }


  @override
  Widget build(BuildContext context) {
    myColor = Theme
        .of(context)
        .primaryColor;
    mediaSize = MediaQuery
        .of(context)
        .size;
    

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
              margin: const EdgeInsets.only(bottom: 450),
              decoration: BoxDecoration(
                color: myColor,
                image: DecorationImage(
                    image: const AssetImage(
                        "assets/images/login_Help_image.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        myColor.withOpacity(0.2), BlendMode.dstATop)
                ),
              )),
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom())
        ],
      ),
    );
  }

  Widget _buildTop(){
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.handshake_outlined, size: 100, color: Colors.white,),
          Text("도움 닿기",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 50,
                letterSpacing: 2
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("안녕하세요!",style: TextStyle(
                  color: myColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold
              ),),
              const SizedBox(height: 30,),
              _buildGreyText("이름"),
              TextField(
                controller: nameController,/////////////////////////////////////
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person)
                ),
              ),
              const SizedBox(height: 30,),
              _buildGreyText("이메일"),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.email_outlined)
                ),
              ),
              const SizedBox(height: 30,),
              _buildGreyText("비밀번호"),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){_togglePassword();},
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                ),
                obscureText: _hidePassword,
              ),
              const SizedBox(height: 30,),
              ElevatedButton(onPressed: (){AuthController.to.register(emailController.text.trim(), passwordController.text.trim());},
                  style: ElevatedButton.styleFrom(
                    shadowColor: myColor,
                    elevation: 20,
                    minimumSize: const Size.fromHeight(60),
                  ),
                  child: const Text("회원가입하기")
              ),
              const SizedBox(height: 20,),
              Center(
                child: TextButton(
                    onPressed: (){
                      Get.to(()=>const LoginPage());
                    },
                    child: const Text(
                      "로그인 페이지로 돌아가기",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    )
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }


}

