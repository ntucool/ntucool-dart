library ntucool;

import 'dart:collection' show LinkedHashMap;
import 'dart:convert';
import 'dart:io' show File, HttpHeaders;

import 'package:html/parser.dart' show parse;

import 'src/api/api.dart' show Api;
import 'src/exceptions.dart' show RuntimeException;
import 'src/http/cookies.dart' show SimpleCookie;
import 'src/http/http.dart' show Session;
import 'src/lock.dart' show FutureChainLock;
import 'src/objects.dart' show Interface;
import 'src/utils.dart' as utils;

export 'src/api/courses.dart' show Course, Term;
export 'src/api/dashboards.dart' show DashboardCard;
export 'src/api/enrollments.dart' show Enrollment;
export 'src/api/files.dart' show File;
export 'src/api/js_env.dart' show JsEnv;
export 'src/api/paginations.dart' show Pagination;
export 'src/api/tabs.dart' show Tab;
export 'src/api/users.dart' show User;
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
    utils.addParameterBySelectors(
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
    utils.addParameterBySelectors(
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
