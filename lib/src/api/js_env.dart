import 'dart:convert' as convert;

import 'package:html/parser.dart' as parser;

import '../exceptions.dart' as exceptions;
import '../http/http.dart' as http;
import '../objects.dart' as objects;
import '../utils.dart' as utils;

/// js_env
///
/// https://github.com/instructure/canvas-lms/blob/master/app/controllers/application_controller.rb
///
/// https://github.com/instructure/canvas-lms/blob/master/app/controllers/context_controller.rb
class JsEnv extends objects.Simple {
  JsEnv({Map<String, dynamic>? attributes}) : super(attributes: attributes);

  Object? get allRoles => getattr('ALL_ROLES');
  Object? get sections => getattr('SECTIONS');
  Object? get concludedSections => getattr('CONCLUDED_SECTIONS');
  Object? get searchUrl => getattr('SEARCH_URL');
  Object? get courseRootUrl => getattr('COURSE_ROOT_URL');
  Object? get contexts => getattr('CONTEXTS');
  Object? get resendInvitationsUrl => getattr('resend_invitations_url');
  Object? get permissions => getattr('permissions');
  Object? get course => getattr('course');

  Object? get newUserTutorials => getattr('NEW_USER_TUTORIALS');
}

/// This is experimental.
Future<JsEnv?> maybeRoster(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
}) async {
  var method = 'GET';
  var url = '/courses/$courseId/users';
  var tmp = await utils.request(
    session,
    method,
    baseUrl,
    reference: url,
  );
  var response = tmp.item1;
  var text = await response.text();
  var document = parser.parse(text);
  var scripts = document.querySelectorAll('head > script');
  for (var script in scripts) {
    var match = RegExp(r'ENV = (\{.*\});').firstMatch(script.text);
    if (match != null) {
      var source = match.group(1)!;
      var data;
      try {
        data = convert.jsonDecode(source);
      } on FormatException catch (e) {
        throw exceptions.JsonDecodeException(e);
      }
      return JsEnv(attributes: data);
    }
  }
  return null;
}
