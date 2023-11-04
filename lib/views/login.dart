import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_wave/views/home.dart';

import 'news_webView.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("This is NewLinks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "We Provide Free 100 new daily without any ad's or interactions in your reading Time. Get your api key now and start reading your news <3",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewsWebView(
                            url: 'https://newsapi.org/register'),
                      ),
                    );
                  },
                  child: const Text('Get You API Key'),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                //style: TextStyle(),
                readOnly: true,
                onTap: () async {
                  ClipboardData? cdata =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  String? copiedtext = cdata?.text;
                  print(copiedtext);

                  if (copiedtext != null) {
                    textController.text = copiedtext;
                  }
                },
                controller: textController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Tap To Paste Your API Key",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                    onPressed: () async {
                      textController.text = '';
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(child: Text('Get API Key First')),
                              //backgroundColor: Colors.teal,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(50),
                              elevation: 30,
                            )
                          );
                          print('object');
                        }
                      },
                      child: const Text('Go'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
