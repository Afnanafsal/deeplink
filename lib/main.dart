import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Link Handler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Uri> _deepLinks = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // First, check if the app was started via a deep link
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      handleDeepLink(Uri.parse(initialLink));
    }

    // Listen for deep links while the app is running
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      // Handle errors
    });
  }

  void handleDeepLink(Uri uri) {
    setState(() {
      _deepLinks.add(uri);
    });
  }

  Future<void> launchUrl(Uri uri) async {
    final url = uri.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deep Link Handler'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: _deepLinks.isEmpty
              ? Text(
                  'No deep links received',
                  style: TextStyle(color: Colors.black),
                )
              : ListView.builder(
                  itemCount: _deepLinks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Center(
                            child: Text(
                              _deepLinks[index].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          onTap: () {
                            launchUrl(_deepLinks[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example deep link to launch
          String exampleDeepLink = 'example://open?param=value';
          await launchUrl(Uri.parse(exampleDeepLink));
        },
        tooltip: 'Launch Example Deep Link',
        child: Icon(Icons.open_in_browser),
      ),
    );
  }
}
