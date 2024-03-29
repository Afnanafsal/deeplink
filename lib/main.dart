import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _latestLink = 'Unknown';

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initUniLinks() async {
    try {
      // Listen for deep links
      getLinksStream().listen((String? link) {
        if (!mounted) return;
        setState(() {
          _latestLink = link ?? 'Unknown';
          // Handle the deep link here
          handleDeepLink(link);
        });
      }, onError: (err) {
        setState(() {
          _latestLink = 'Failed to get latest link: $err.';
        });
      });

      // Get initial deep link when the app is launched
      final initialLink = await getInitialLink();
      setState(() {
        _latestLink = initialLink ?? 'Unknown';
        // Handle the initial deep link here
        handleDeepLink(initialLink);
      });
    } catch (err) {
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
      });
    }
  }

  void handleDeepLink(String? link) {
    // Handle the received deep link
    if (link != null) {
      // For example, you can parse the deep link and perform actions based on it
      print('Received deep link: $link');
      // You can also launch other apps using the url_launcher package if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Deep Link Handler'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Latest deep link:'),
              Text(
                _latestLink,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
