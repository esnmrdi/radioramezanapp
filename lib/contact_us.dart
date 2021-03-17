// loading required packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:radioramezan/theme.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUs createState() => _ContactUs();
}

class _ContactUs extends State<ContactUs> {
  Future<String> loadTextAsset(String url) async {
    return await rootBundle.loadString(url);
  }

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
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
                      color: RadioRamezanColors.ramady,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        20, 0, 20, MediaQuery.of(context).viewInsets.bottom),
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
                                  child: Material(
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(225, 48, 108, 1),
                                      radius: 42,
                                      child: FaIcon(
                                        FontAwesomeIcons.phone,
                                        size: 36,
                                        color: Colors.white,
                                      ),
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
                                  child: Material(
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: RadioRamezanColors.goldy,
                                      radius: 42,
                                      child: FaIcon(
                                        FontAwesomeIcons.envelope,
                                        size: 36,
                                        color: Colors.white,
                                      ),
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
                                  child: Material(
                                    shape: CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(0, 136, 204, 1),
                                      radius: 42,
                                      child: FaIcon(
                                        FontAwesomeIcons.telegramPlane,
                                        size: 36,
                                        color: Colors.white,
                                      ),
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
                        TextField(
                          // controller: _recipientController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'نام',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          // controller: _subjectController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ایمیل',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormField(
                          builder: (FormFieldState state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                // labelStyle: textStyle,
                                errorStyle: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                ),
                                hintText: 'موضوع',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              isEmpty: true,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  // value: _currentSelectedValue,
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      // _currentSelectedValue = newValue;
                                      state.didChange(newValue);
                                    });
                                  },
                                  value: null,
                                  items: [
                                    DropdownMenuItem(
                                      // value: value,
                                      child: Text('آمادگی جهت همکاری'),
                                    ),
                                    DropdownMenuItem(
                                      // value: value,
                                      child: Text('حمایت مالی'),
                                    ),
                                    DropdownMenuItem(
                                      // value: value,
                                      child: Text(
                                          'درخواست تبلیغات در رادیو رمضان'),
                                    ),
                                    DropdownMenuItem(
                                      // value: value,
                                      child: Text('پیشنهاد و انتقاد'),
                                    ),
                                    DropdownMenuItem(
                                      // value: value,
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
                        TextField(
                          // controller: _bodyController,
                          maxLines: 8,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'متن پیام',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: MaterialButton(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: RadioRamezanColors.ramady,
                            onPressed: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 10,
                              ),
                              child: Text(
                                'ارسال پیام',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
    );
  }
}
