// loading required packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:radioramezan/globals.dart';
import 'package:radioramezan/theme.dart';

class ContactUsModal extends StatefulWidget {
  @override
  ContactUsModalState createState() => ContactUsModalState();
}

class ContactUsModalState extends State<ContactUsModal> {
  GlobalKey<ScaffoldState> contactUsModalScaffoldState;
  GlobalKey<FormState> messageFormKey;
  TextEditingController senderController, emailController, messageController;
  String subjectValue;
  bool messageIsSent;

  Future<String> loadTextAsset(String url) async {
    return await rootBundle.loadString(url);
  }

  Future<Null> sendMail() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (messageFormKey.currentState.validate()) {
      setState(() {
        messageIsSent = false;
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
          messageIsSent = true;
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
              'مشکلی در ارسال پیام ایجاد شد.',
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
          messageIsSent = true;
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
    contactUsModalScaffoldState = GlobalKey<ScaffoldState>();
    messageFormKey = GlobalKey<FormState>();
    senderController = TextEditingController();
    emailController = TextEditingController();
    messageController = TextEditingController();
    messageIsSent = true;
    super.initState();
  }

  void dispose() {
    senderController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
      child: Scaffold(
        key: contactUsModalScaffoldState,
        // resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/golden_mosque_20percent.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/modal_top.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: FutureBuilder(
            future: loadTextAsset('assets/texts/contact_us.txt'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 90),
                    Container(
                      child: Text(
                        'ارتباط با ما',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          children: <Widget>[
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
                                        backgroundColor:
                                            Color.fromRGBO(225, 48, 108, 1),
                                        radius: 42,
                                        child: Icon(
                                          CupertinoIcons.phone,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        launch("tel://+15145839110");
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
                                        backgroundColor:
                                            RadioRamezanColors.goldy,
                                        radius: 42,
                                        child: Icon(
                                          CupertinoIcons.mail,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        launch(
                                            'mailto:abbas.soltanian@gmail.com');
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
                                        backgroundColor:
                                            Color.fromRGBO(0, 136, 204, 1),
                                        radius: 42,
                                        child: Icon(
                                          CupertinoIcons.paperplane,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        launch('https://t.me/a_soltanian');
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
                                children: <Widget>[
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
                                            icon: Icon(
                                                CupertinoIcons.chevron_down),
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
                                                child:
                                                    Text('آمادگی جهت همکاری'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'حمایت مالی',
                                                child: Text('حمایت مالی'),
                                              ),
                                              DropdownMenuItem(
                                                value:
                                                    'درخواست تبلیغات در رادیو رمضان',
                                                child: Text(
                                                    'درخواست تبلیغات در رادیو رمضان'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'پیشنهاد و انتقاد',
                                                child: Text('پیشنهاد و انتقاد'),
                                              ),
                                              DropdownMenuItem(
                                                value: 'گزارش مشکلات اپلیکیشن',
                                                child: Text(
                                                    'گزارش مشکلات اپلیکیشن'),
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
                                      if (value.isEmpty)
                                        return 'فیلد نام خالی است!';
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
                                      if (value.isEmpty)
                                        return 'فیلد ایمیل خالی است!';
                                      Pattern pattern =
                                          '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}';
                                      RegExp regex = RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'ایمیل را در قالب صحیح وارد کنید!';
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
                                      if (value.isEmpty)
                                        return 'متن پیام خالی است!';
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
                                      elevation: messageIsSent ? 2 : 0,
                                      fillColor: messageIsSent
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).disabledColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onPressed: messageIsSent
                                          ? () {
                                              sendMail();
                                            }
                                          : null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 10,
                                        ),
                                        child: messageIsSent
                                            ? Text(
                                                'ارسال پیام',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Container(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
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
    );
  }
}
