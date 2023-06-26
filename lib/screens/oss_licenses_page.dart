import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snappx_quiz/oss_licenses.dart';
import 'package:snappx_quiz/styling/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OssLicensesPage extends StatelessWidget {
  const OssLicensesPage({super.key});

  static Future<List<Package>> loadLicenses() async {
    // merging non-dart dependency list using LicenseRegistry.
    final lm = <String, List<String>>{};
    await for (var l in LicenseRegistry.licenses) {
      for (var p in l.packages) {
        final lp = lm.putIfAbsent(p, () => []);
        lp.addAll(l.paragraphs.map((p) => p.text));
      }
    }
    final licenses = ossLicenses.toList();
    for (var key in lm.keys) {
      licenses.add(Package(
        name: key,
        description: '',
        authors: [],
        version: '',
        license: lm[key]!.join('\n\n'),
        isMarkdown: false,
        isSdk: false,
        isDirectDependency: false,
      ));
    }
    return licenses..sort((a, b) => a.name.compareTo(b.name));
  }

  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return Container(
      color: FunnyWebAppColors.background,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.02,
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
          ),
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: const Text('Open Source Licenses'),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF36343B).withOpacity(0.5),
                  ),
                  child: IconButton(
                    splashRadius: 24.0,
                    onPressed: () {
                      context.go('/results_direct');
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF78FCB0),
                    ),
                  ),
                ),
              ),
              body: FutureBuilder<List<Package>>(
                  future: _licenses,
                  initialData: const [],
                  builder: (context, snapshot) {
                    return ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final package = snapshot.data![index];
                          return ListTile(
                            title: Text(
                              '${package.name} ${package.version}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: package.description.isNotEmpty
                                ? Text(package.description)
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MiscOssLicenseSingle(package: package),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider());
                  })),
        ),
      ),
    );
  }
}

class MiscOssLicenseSingle extends StatelessWidget {
  final Package package;

  MiscOssLicenseSingle({required this.package});

  String _bodyText() {
    return package.license!.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      line = line.trim();
      return line;
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${package.name} ${package.version}')),
      body: Container(
          color: FunnyWebAppColors.background,
          child: ListView(children: <Widget>[
            if (package.description.isNotEmpty)
              Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: Text(package.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold))),
            if (package.homepage != null)
              Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: InkWell(
                    child: Text(package.homepage!,
                        style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline)),
                    onTap: () {
                      final launchMode = kIsWeb
                          ? LaunchMode.platformDefault
                          : Platform.isAndroid
                              ? LaunchMode.externalApplication
                              : LaunchMode.platformDefault;
                      launchUrl(Uri.parse(package.homepage!), mode: launchMode);
                    },
                  )),
            if (package.description.isNotEmpty || package.homepage != null)
              const Divider(),
            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Text(_bodyText(),
                  style: Theme.of(context).textTheme.bodyText2),
            ),
          ])),
    );
  }
}
