library ntucool;

import 'dart:collection' show LinkedHashMap;
import 'dart:convert';
import 'dart:io' show File, HttpHeaders;

import 'package:html/parser.dart' show parse;

import 'src/api/api.dart' show Api;
import 'src/exceptions.dart' show RuntimeException;
import 'src/http/cookies.dart' show SimpleCookie;
import 'src/http/http.dart' show Session;
import 'src/objects.dart' show Interface;
import 'src/utils.dart' show addParameterBySelectors;

export 'src/api/dashboards.dart' show DashboardCard;
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

  Future<bool> saml(username, password) async {
    var url = baseUrl.resolve('/login/saml');

    var response = await session.getUrl(url);
    var text = await response.text();
    var document = parse(text);

    // TODO: follow form submission algorithm
    // https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#form-submission-algorithm
    var form = document.getElementById('MainForm');
    if (form == null) {
      throw RuntimeException();
    }
    var method = form.attributes['method'];
    if (method == 'post') {
      method = 'POST';
    } else {
      throw RuntimeException();
    }
    var action = form.attributes['action'];
    if (action == null) {
      throw RuntimeException();
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

    response = await session.postUrl(url, data: map, headers: headers);
    text = await response.text();
    document = parse(text);
    form = document.querySelector('html > body > form[name="hiddenform"]');
    if (form == null) {
      throw RuntimeException();
    }
    method = form.attributes['method'];
    if (method == 'POST') {
      method = 'POST';
    } else {
      throw RuntimeException();
    }
    action = form.attributes['action'];
    if (action == null) {
      throw RuntimeException();
    }
    url = response.uri.resolve(action);

    map = LinkedHashMap<String, String>();
    addParameterBySelectors(
        document,
        map,
        LinkedHashMap.fromIterables(
            ['body > form > input[type=hidden][name="SAMLResponse"]'], [null]));

    response = await session.postUrl(url, data: (map), headers: headers);
    await response.drain();

    return response.statusCode == 200;
  }

  void close({bool force = false}) => session.close();
}

main(List<String> args) async {
  var client = Client();

  print(client.api.session);

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

  // var courses = await client.api.courses.getCourses().toList();
  // print(courses);

  // var dashboardCards = await client.getDashboardCards();
  // print(dashboardCards);

  var customColors = await client.api.users.getCustomColors(id: 'self');
  print(customColors);

  var cookies = client.session.cookieJar.filterCookies(client.baseUrl);
  var file = File('../credentials/cookies.json');
  file.writeAsStringSync(jsonEncode(cookies));
  client.close();
}
