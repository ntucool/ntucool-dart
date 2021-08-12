library ntucool;

import 'dart:collection' show LinkedHashMap;
import 'dart:convert';
import 'dart:io' show File, HttpHeaders;

import 'package:html/parser.dart' show parse;

import 'src/api/api.dart' show Api;
import 'src/exceptions.dart' show RuntimeException;
import 'src/http/cookies.dart' show SimpleCookie;
import 'src/http/http.dart' show Session;
import 'src/lock.dart';
import 'src/objects.dart' show Interface;
import 'src/utils.dart' show addParameterBySelectors;

export 'src/api/dashboards.dart' show DashboardCard;
export 'src/api/courses.dart' show Course, Term;
export 'src/api/paginations.dart' show Pagination;
export 'src/objects.dart' show sentinel;

class Client with Interface {
  static final defaultBaseUrl = Uri.parse('https://cool.ntu.edu.tw/');

  late Session _session;
  late Uri _baseUrl;

  @override
  Session get session => _session;
  @override
  set session(covariant Session value) {
    _session = value;
    for (var interface in subInterfaces) {
      interface.session = value;
    }
  }

  @override
  Uri get baseUrl => _baseUrl;
  @override
  set baseUrl(covariant Uri value) {
    _baseUrl = value;
    for (var interface in subInterfaces) {
      interface.baseUrl = value;
    }
  }

  late Api api;

  Client({Session? session, Uri? baseUrl}) {
    api = Api();
    this.subInterfaces.addAll([api]);
    this.session = session ?? Session();
    this.baseUrl = baseUrl ?? defaultBaseUrl;
  }

  final samlLock = FutureChainLock();

  Future<bool> saml(username, password) {
    return samlLock.acquire(() => _saml(username, password));
  }

  Future<bool> _saml(username, password) async {
    var url = baseUrl.resolve('/login/saml');

    var response = await session.openUrl('GET', url);
    var text = await response.text();
    var document = parse(text);

    // TODO: follow form submission algorithm
    // https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#form-submission-algorithm
    var form = document.getElementById('MainForm');
    if (form == null) {
      return Future.error(RuntimeException());
    }
    var method = form.attributes['method'];
    if (method == 'post') {
      method = 'POST';
    } else {
      return Future.error(RuntimeException());
    }
    var action = form.attributes['action'];
    if (action == null) {
      return Future.error(RuntimeException());
    }
    url = response.uri.resolve(action);

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
    };
    var map = LinkedHashMap<String, String>();
    addParameterBySelectors(
        document,
        map,
        LinkedHashMap.fromIterables([
          '#__VIEWSTATE',
          '#__VIEWSTATEGENERATOR',
          '#__EVENTVALIDATION',
          '#MainForm > input[name=__db]',
          '#ContentPlaceHolder1_UsernameTextBox',
          '#ContentPlaceHolder1_PasswordTextBox',
          '#ContentPlaceHolder1_SubmitButton'
        ], [
          null,
          null,
          null,
          null,
          username,
          password,
          'Sign In'
        ]));
    headers = {};

    response = await session.openUrl('POST', url, data: map, headers: headers);
    text = await response.text();
    document = parse(text);
    form = document.querySelector('html > body > form[name="hiddenform"]');
    if (form == null) {
      return Future.error(RuntimeException());
    }
    method = form.attributes['method'];
    if (method == 'POST') {
      method = 'POST';
    } else {
      return Future.error(RuntimeException());
    }
    action = form.attributes['action'];
    if (action == null) {
      return Future.error(RuntimeException());
    }
    url = response.uri.resolve(action);

    map = LinkedHashMap<String, String>();
    addParameterBySelectors(
        document,
        map,
        LinkedHashMap.fromIterables(
            ['body > form > input[type=hidden][name="SAMLResponse"]'], [null]));

    response = await session.openUrl('POST', url, data: map, headers: headers);
    await response.drain();

    return response.statusCode == 200;
  }

  void close({bool force = false}) => session.close();
}

main(List<String> args) async {
  var client = Client();

  if (args.isNotEmpty) {
    var file = File(args.first);
    var data = jsonDecode(file.readAsStringSync());
    if (data is Map<String, dynamic>) {
      if (data.containsKey('username') && data.containsKey('password')) {
        var username = data['username'];
        var password = data['password'];
        var ok = await client.saml(username, password);
        assert(ok == true);
      } else {
        var cookies = SimpleCookie.fromJson(data);
        client.session.cookieJar.updateCookies(cookies);
      }
    }
  }

  var courses = client.api.courses.getCourses(include: ['term']);
  // courses.listen((event) {
  //   print([0, event]);
  // });
  // courses.stream.length
  //     .then((value) => print(['courses.stream.length', value]));
  // var a = courses.stream;
  // var b = courses.stream;
  // a.first.then((value) => print(['first', value]));
  // b.first.then((value) => print(['first', value]));
  // courses.listen((event) {
  //   print([1, event]);
  // });
  // print(courses[0]);
  // print(await courses.length);
  // print(await courses.length);
  // courses.length.then((value) => print(value));
  // courses.last.then((value) {
  //   print(value);
  // }).catchError((e) {
  //   print(['error', e]);
  // }, test: (e) => e is StateError && e.message == 'Client is closed');
  // courses.elementAt(10).then((value) => print(value));
  // print(await courses.elementAt(0));
  // courses.elementAt(0).then((value) => print(value));
  // courses.length.then((value) => print(value));
  // print(await courses.elementAt(0));
  // courses.first.then((value) => print(value));
  // courses.first.then((value) => print(value));
  // courses.elementAt(10).then((value) => print(value), onError: (e) {
  //   print(e);
  // });
  try {
    courses.elementAt(10).then((value) => print(value), onError: (e) {
      print(['onError', e]);
    });
    print(await courses.elementAt(10));
  } on RangeError catch (e) {
    print(['catch', e]);
  }
  // print(await courses.first);
  // print(await courses.first);
  // courses.listen((event) {
  //   print([-1, event]);
  // });
  courses.listen((event) {
    print([0, event]);
  }, onDone: () {
    courses.listen((event) {
      print([1, event]);
    });
  });
  // print(await courses.elementAt(0));
  // print(await courses.elementAt(3));
  // print(await courses.elementAt(3));
  // courses.toList().then((value) => print(value));
  // courses.listen((event) {
  //   print(['event', event]);
  // }, onDone: () {
  //   print(courses.values);
  // });

  // var dashboardCards = await client.getDashboardCards();
  // print(dashboardCards);

  // var customColors = await client.api.users.getCustomColors(id: 'self');
  // print(customColors);

  var cookies = client.session.cookieJar.filterCookies(client.baseUrl);
  var file = File('../credentials/cookies.json');
  file.writeAsStringSync(jsonEncode(cookies));
  // client.close();
}
