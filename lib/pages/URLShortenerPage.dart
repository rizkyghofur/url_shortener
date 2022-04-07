import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class URLShortenerPage extends StatefulWidget {
  URLShortenerPage({Key key}) : super(key: key);

  @override
  State<URLShortenerPage> createState() => _URLShortenerPageState();
}

class _URLShortenerPageState extends State<URLShortenerPage> {
  TextEditingController linkController =
      TextEditingController(text: "https://");
  String link;
  String linkShorten = "";
  String _copy;
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL Shortener'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextField(
                decoration: new InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 20, top: 20, right: 15),
                    hintText: "Type your link here..."),
                textInputAction: TextInputAction.done,
                cursorColor: Colors.black,
                autofocus: true,
                controller: linkController,
                style: TextStyle(
                  fontSize: 20,
                ),
                onSubmitted: (_link) {
                  setState(() {
                    link = _link;
                  });
                  requestShorten(link);
                },
                onChanged: (_link) {
                  setState(() {
                    link = _link;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 125,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoaded
                    ? null
                    : () {
                        setState(() {
                          isLoaded = true;
                          linkShorten = "Please wait...";
                        });
                        requestShorten(link);
                      },
                child: isLoaded
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        'Shorten',
                        style: TextStyle(fontSize: 20),
                      ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            linkShorten.contains('Failed')
                ? Text(
                    linkShorten,
                    style: TextStyle(fontSize: 20),
                  )
                : SelectableText(
                    linkShorten,
                    style: TextStyle(fontSize: 20),
                    onTap: () {
                      Clipboard.setData(
                        new ClipboardData(text: _copy),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Shorten link copied!"),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }

  void requestShorten(String link) async {
    var map = new Map<String, dynamic>();
    map['url'] = link;

    final response = await http.post(
      Uri.parse('https://goolnk.com/api/v1/shorten'),
      body: map,
    );

    print(response.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    setState(() {
      isLoaded = false;
      linkShorten = data["result_url"] == null
          ? "Failed, please check your link"
          : data["result_url"];
    });
  }
}
