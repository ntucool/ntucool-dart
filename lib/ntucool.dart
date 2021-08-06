library ntucool;

import 'dart:collection' show LinkedHashMap;
import 'dart:io' show HttpHeaders;

import 'package:html/parser.dart' show parse;

import 'src/api/common.dart' as common;
import 'src/api/paginations.dart' show Pagination;
import 'src/exceptions.dart' show RuntimeException;
import 'src/http/http.dart' show Session;
import 'src/objects.dart' show Interface;
import 'src/utils.dart' show addParameterBySelectors;

class Client with Interface {
  static final defaultBaseUrl = Uri.parse('https://cool.ntu.edu.tw/');

  covariant late Session session;
  covariant late Uri baseUrl;

  Client({Session? session, Uri? baseUrl}) {
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
    // await response.drain();
    print((await response.text()).contains('數位系統與實'));

    return response.statusCode == 200;
  }

  Pagination<common.Course> listCourses() {
    return common.listYourCourses(session, baseUrl);
  }

  void close({bool force = false}) => session.close();
}
