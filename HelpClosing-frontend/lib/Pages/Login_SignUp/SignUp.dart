import 'package:help_closing_frontend/Controller/Auth_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_closing_frontend/Pages/Login_SignUp/Login.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  bool _hidePassword=true;
  bool _rememberMe=false;
  bool _flagCheckPass=true;
  bool _checkEmail = false;


  void _togglePassword(){
    setState(() {
      _hidePassword=!_hidePassword;
    });
  }

  void _CheckPassword(){
    setState(() {
      _flagCheckPass=passwordCheckController.text.trim() == passwordController.text.trim() ? true : false;
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
          _buildBottom()
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return ListView(

      children: [
      Card(
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
              const SizedBox(height: 30,),
              Text("회원가입",style: TextStyle(
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
              const SizedBox(height: 20,),
              _buildGreyText("닉네임"),
              TextField(
                controller: nickNameController,/////////////////////////////////////
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.person_add_alt_outlined)
                ),
              ),
              const SizedBox(height: 20,),
              _buildGreyText("이메일"),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(onPressed: ()  async{
                    var flag = await AuthController.to.checkEmail(emailController.text.trim());
                    setState(()  {
                      _checkEmail = flag;
                    });
                  }, icon: const Icon(Icons.email_outlined), color: _checkEmail? Colors.green : Colors.red),
                ),
              ),
              const SizedBox(height: 20,),
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
              const SizedBox(height: 20,),
              _buildGreyText("비밀번호 확인"),
              TextField(
                onChanged: (text){
                  _CheckPassword();
                },
                controller: passwordCheckController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){_CheckPassword();},
                    icon: _flagCheckPass ? const Icon(Icons.check) : const Icon(Icons.do_not_disturb_alt),
                  ),
                ),
                obscureText: _hidePassword,
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: () async {
                if(_flagCheckPass){
                  var email = emailController.text.trim();
                  var password = passwordController.text.trim();
                  var confirmPw = passwordCheckController.text.trim();
                  var nickname = nickNameController.text.trim();
                  var name = nameController.text.trim();
                  if(await AuthController.to.register(email, password, confirmPw, nickname,name)){
                    AuthController.to.registerEmail = email;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PledgeScreen()));
                  }
                }
                else{
                  Get.snackbar("비밀번호 불일치", "비밀번호를 확인해주세요",snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent[100]);
                }
              },
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
              const SizedBox(height: 10,),
            ],
          ),
        ),
      )
      ],
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

class PledgeScreen extends StatefulWidget {
  const PledgeScreen({super.key});

  @override
  State<PledgeScreen> createState() => _PledgeScreenState();
}

class _PledgeScreenState extends State<PledgeScreen> {
  String name = "";
  String date = '';
  var globalKey = new GlobalKey();

  void _capture() async {
    print("START CAPTURE");
    var renderObject = globalKey.currentContext!.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      ui.Image image = await boundary.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      print(pngBytes);
      File imgFile = File('$directory/firstPledge.png');
      imgFile.writeAsBytes(pngBytes);

      AuthController.to.uploadS3("$directory/firstPledge.png","pledgeRequest","request");
      print("FINISH CAPTURE ${imgFile.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pledge Form'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
                children: [
                  RepaintBoundary(
                    key : globalKey,
                    child: Column(
                      children: [
                        const Center(
                          child: Text('도움 요청에 대한 서약서', style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold
                          )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('본인은 아래와 같이 서약합니다.'),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            RichText(
                                text: const TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 15),
                                    children: [
                                      TextSpan(text: '1.본인은 본 서비스를 도움을 요청하는데 사용하며,'
                                          '이 도움은 본인의 안전 및 보호를 위해 필요하였음을 명시합니다.\n'),
                                      TextSpan(text: '2.본인은 도움 제공자가 자신에게 해를 끼치려 한 사실이 없음을 확인하며, '
                                          '그러한 주장을 하지 않겠습니다.\n'),
                                      TextSpan(text: '3.본인은 도움 제공자를 위험 상황의 가해자로 지목하지 않겠으며, 그러한 무고나 위증 등의 행위를 절대로 하지 않겠습니다.\n'),
                                      TextSpan(text: '4.만일 본 서약서에 위반하는 경우, 모든 법적 책임을 질 것임을 이해하고 있습니다.본 서약서는 자발적으로 작성되었으며, 모든 내용이 사실임을 확인합니다.\n'),
                                    ]
                                )
                            ),
                            RichText(
                                textAlign: TextAlign.center,
                                text:  TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 15),
                                    children:[
                                      const TextSpan(text: '날짜:'),
                                      TextSpan(text: date.isNotEmpty ? date+'      ' : '__________     ',
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const TextSpan(text: '성명:'),
                                      TextSpan(text: name.isNotEmpty ? name+'\n' : '__________\n'
                                          ,style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: ElevatedButton(
                          onPressed: (){
                            if(date!="" && name!=""){
                              _capture();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PledgeSecondScreen() ));
                            }else{
                              Get.snackbar("입력하신 이름,날짜를 확인해주세요", "날짜와 성명을 입력해주셔야됩니다!");
                            }
                          },
                          child: const Text('Enter')
                      )
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'EnterYourName'),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      }
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Enter the date'),
                      onChanged: (value) {
                        setState(() {
                          date = value;
                        });
                      }
                  )
                ]
            )
        )
    );
  }
}

class PledgeSecondScreen extends StatefulWidget {
  const PledgeSecondScreen({super.key});

  @override
  State<PledgeSecondScreen> createState() => _PledgeSecondScreenState();
}

class _PledgeSecondScreenState extends State<PledgeSecondScreen> {
  String name = "";
  String date = '';

  var globalKey = new GlobalKey();

  void _capture() async {
    print("START CAPTURE");
    var renderObject = globalKey.currentContext!.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      ui.Image image = await boundary.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      print(pngBytes);
      File imgFile = File('$directory/secondPledge.png');
      imgFile.writeAsBytes(pngBytes);

      AuthController.to.uploadS3("$directory/secondPledge.png","pledgeResponse","response");
      print("FINISH CAPTURE ${imgFile.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pledge Form'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
                children: [
                  RepaintBoundary(
                    key : globalKey,
                    child: Column(
                      children: [
                        const Center(
                          child: Text('도움 제공에 대한 서약서', style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold
                          )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('본인은 아래와 같이 서약합니다.'),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            RichText(
                                text: const TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 15),
                                    children: [
                                      TextSpan(text: '1.본인은 해당 서비스를 도움을 제공하는데 사용하며,'
                                          '이 도움은 도움 제공 이외에는 어떠한 의도도 없음을 명시합니다.\n'),
                                      TextSpan(text: '2.본인은 도움 받는 사람에게 해를 끼치려 한 사실이 없음을 명시합니다.\n'),
                                      TextSpan(text: '3.만일 본 서약서에 위반하는 경우, 모든 법적 책임을 질 것임을 이해하고 있습니다.'
                                          '본 서약서는 자발적으로 작성되었으며, 모든 내용이 사실임을 확인합니다.\n'),
                                    ]
                                )
                            ),
                            RichText(
                                textAlign: TextAlign.center,
                                text:  TextSpan(
                                    style: TextStyle(color: Colors.black, fontSize: 15),
                                    children:[
                                      const TextSpan(text: '날짜:'),
                                      TextSpan(text: date.isNotEmpty ? date+'      ' : '__________     ',
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const TextSpan(text: '성명:'),
                                      TextSpan(text: name.isNotEmpty ? name+'\n' : '__________\n'
                                          ,style: TextStyle(fontWeight: FontWeight.bold)),
                                    ]
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: ElevatedButton(
                          onPressed: (){
                            if(name!="" && date!=""){
                              _capture();
                              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            }
                          },
                          child: Text('Enter')
                      )
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'EnterYourName'),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      }
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Enter the date'),
                      onChanged: (value) {
                        setState(() {
                          date = value;
                        });
                      }
                  )
                ]
            )
        )
    );
  }
}

