// loading required packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';

class ContactUs extends StatefulWidget {
  @override
  ContactUsState createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {
  GlobalKey<ScaffoldState> contactUsScaffoldKey;
  ScrollController scrollController;
  GlobalKey<FormState> messageFormKey;
  TextEditingController senderController, emailController, messageController;
  String subjectValue;
  bool messageIsSending;

  Future<String> loadTextAsset(String url) async {
    return await rootBundle.loadString(url);
  }

  Future<Null> sendMail() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'امکان ارسال ایمیل در نسخه وب وجود ندارد.',
            style: TextStyle(fontFamily: 'Sans'),
          ),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            textColor: RadioRamezanColors.goldy,
            label: 'ای بابا!',
            onPressed: () {},
          ),
        ),
      );
      return null;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (messageFormKey.currentState.validate()) {
      setState(() {
        messageIsSending = true;
      });
      final smtpServer = SmtpServer(
        'smtp.ionos.com',
        port: 465,
        ssl: true,
        username: globals.smtpUsername,
        password: globals.smtpPassword,
      );
      final message = Message()
        ..from = Address(emailController.text)
        ..recipients.add('esn.mrd@gmail.com')
        ..ccRecipients.add('abbas.soltanian@gmail.com')
        ..subject = subjectValue
        ..text = senderController.text + '\n' + messageController.text;

      try {
        await send(message, smtpServer);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'پیام با موفقیت ارسال شد.',
              style: TextStyle(fontFamily: 'Sans'),
            ),
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              textColor: RadioRamezanColors.goldy,
              label: 'مرسی!',
              onPressed: () {},
            ),
          ),
        );
        setState(() {
          messageIsSending = false;
        });
        messageFormKey.currentState.reset();
        subjectValue = null;
        senderController.text = '';
        emailController.text = '';
        messageController.text = '';
      } on MailerException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ارسال پیام ناموفق بود. دوباره تلاش کنید.',
              style: TextStyle(fontFamily: 'Sans'),
            ),
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              textColor: RadioRamezanColors.goldy,
              label: 'ای بابا!',
              onPressed: () {},
            ),
          ),
        );
        setState(() {
          messageIsSending = false;
        });
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }
  }

  @override
  void initState() {
    contactUsScaffoldKey = GlobalKey<ScaffoldState>();
    scrollController = ScrollController();
    messageFormKey = GlobalKey<FormState>();
    senderController = TextEditingController();
    emailController = TextEditingController();
    messageController = TextEditingController();
    messageIsSending = false;
    super.initState();
  }

  void dispose() {
    scrollController.dispose();
    senderController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kIsWeb && MediaQuery.of(context).size.width > MediaQuery.of(context).size.height / globals.webAspectRatio
          ? EdgeInsets.symmetric(
              horizontal:
                  (MediaQuery.of(context).size.width - MediaQuery.of(context).size.height / globals.webAspectRatio) / 2)
          : null,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ClipRRect(
        child: Scaffold(
          key: contactUsScaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('images/golden_mosque_20percent.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: FutureBuilder(
              future: loadTextAsset('texts/contact_us.txt'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          WaveWidget(
                            config: CustomConfig(
                              colors: [Colors.white70, Colors.white54, Colors.white30, Colors.white],
                              durations: [32000, 16000, 8000, 4000],
                              heightPercentages: [.65, .68, .75, .8],
                            ),
                            waveAmplitude: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                            size: Size(
                              MediaQuery.of(context).size.width,
                              100,
                            ),
                          ),
                          Container(
                            height: 100,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'ارتباط با ما',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                FloatingActionButton(
                                  elevation: 2,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: DraggableScrollbar.semicircle(
                          controller: scrollController,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.all(20),
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text(snapshot.data),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          InkWell(
                                            customBorder: CircleBorder(),
                                            child: CircleAvatar(
                                              backgroundColor: Color.fromRGBO(225, 48, 108, 1),
                                              radius: 42,
                                              child: Icon(
                                                CupertinoIcons.phone,
                                                size: 36,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              launch("tel://+14388137453");
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Text('تماس مستقیم'),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            customBorder: CircleBorder(),
                                            child: CircleAvatar(
                                              backgroundColor: RadioRamezanColors.goldy,
                                              radius: 42,
                                              child: Icon(
                                                CupertinoIcons.mail,
                                                size: 36,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              launch('mailto:abbas.soltanian@gmail.com');
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Text('ارسال ایمیل'),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            customBorder: CircleBorder(),
                                            child: CircleAvatar(
                                              backgroundColor: Color.fromRGBO(0, 136, 204, 1),
                                              radius: 42,
                                              child: Icon(
                                                CupertinoIcons.paperplane,
                                                size: 36,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              launch('https://t.me/RadioRamezan2');
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          Text('چت تلگرام'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Form(
                                    key: messageFormKey,
                                    child: Column(
                                      children: [
                                        FormField(
                                          builder: (FormFieldState state) {
                                            return InputDecorator(
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                              isEmpty: true,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  icon: Icon(CupertinoIcons.chevron_down),
                                                  hint: Text('موضوع'),
                                                  value: subjectValue,
                                                  isDense: true,
                                                  onChanged: (String newValue) {
                                                    setState(() {
                                                      subjectValue = newValue;
                                                      state.didChange(newValue);
                                                    });
                                                  },
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'آمادگی جهت همکاری',
                                                      child: Text('آمادگی جهت همکاری'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'حمایت مالی',
                                                      child: Text('حمایت مالی'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'درخواست تبلیغات در رادیو رمضان',
                                                      child: Text('درخواست تبلیغات در رادیو رمضان'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'پیشنهاد و انتقاد',
                                                      child: Text('پیشنهاد و انتقاد'),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'گزارش مشکلات اپلیکیشن',
                                                      child: Text('گزارش مشکلات اپلیکیشن'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: senderController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'نام کامل',
                                            errorStyle: TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value.isEmpty) return 'فیلد نام خالی است!';
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'ایمیل',
                                            errorStyle: TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          textDirection: TextDirection.ltr,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value.isEmpty) return 'فیلد ایمیل خالی است!';
                                            Pattern pattern = '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}';
                                            RegExp regex = RegExp(pattern);
                                            if (!regex.hasMatch(value)) return 'ایمیل را در قالب صحیح وارد کنید!';
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: messageController,
                                          maxLines: 8,
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            border: OutlineInputBorder(),
                                            labelText: 'متن پیام',
                                            errorStyle: TextStyle(
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          textInputAction: TextInputAction.done,
                                          validator: (value) {
                                            if (value.isEmpty) return 'متن پیام خالی است!';
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          width: MediaQuery.of(context).size.width,
                                          child: RawMaterialButton(
                                            elevation: messageIsSending ? 0 : 2,
                                            fillColor: messageIsSending
                                                ? Theme.of(context).disabledColor
                                                : Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            onPressed: !messageIsSending
                                                ? () {
                                                    sendMail();
                                                  }
                                                : null,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 10,
                                              ),
                                              child: !messageIsSending
                                                  ? Text(
                                                      'ارسال پیام',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 24,
                                                      width: 24,
                                                      child: CircularProgressIndicator(
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
