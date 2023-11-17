import 'package:help_closing_frontend/Pages/Login_SignUp/SignUp.dart';
import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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


    // return Container(
    //   decoration: BoxDecoration(
    //     color: myColor,
    //     image: DecorationImage(
    //         image: const AssetImage("assets/images/login_Help_image.jpg"),
    //       fit: BoxFit.cover,
    //       colorFilter: ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop)
    //     ),
    //   ),
    //   child: Scaffold(
    //     backgroundColor: Colors.transparent,
    //     body: Stack(
    //       children: [
    //         Positioned(top: 80,child: _buildTop()),
    //         Positioned(bottom:0,child: _buildBottom())
    //       ],
    //     ),
    //   ),
    // );

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(value: AuthController.to.rememberUser, onChanged: (val){
                        setState(() {
                          _rememberMe=val!;
                        });
                        AuthController.to.toggleRemember(val!);
                      }),
                      _buildGreyText("입력한 정보를 저장"),
                    ],
                  ),
                  TextButton(onPressed: (){}, child: _buildGreyText("비밀번호 찾기"))
                ],
              ),
              const SizedBox(height: 40,),
              ElevatedButton(onPressed: (){AuthController.to.login(emailController.text.trim(), passwordController.text.trim());},
                  style: ElevatedButton.styleFrom(
                    shadowColor: myColor,
                    elevation: 20,
                    minimumSize: const Size.fromHeight(60),
                  ),
                  child: const Text("로그인하기")
              ),
              const SizedBox(height: 20,),
              Center(
                child: TextButton(
                    onPressed: (){
                      Get.to(()=>const SignUpPage());
                    },
                    child: const Text(
                        "회원가입하기",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: Column(
                  children: [
                    _buildGreyText("다른 방법으로 로그인하기"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){print("구글로 로그인하기");},
                          child: Tab(
                            icon: Image.asset("assets/images/google_logo.png"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
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
