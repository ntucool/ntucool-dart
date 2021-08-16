import '../objects.dart' show Base;
import '../http/http.dart' show Session;
import 'paginations.dart' show Pagination;

/// https://canvas.instructure.com/doc/api/tabs.html#Tab
class Tab extends Base {
  Tab({Map<String, dynamic>? attributes, Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id', 'label'];

  Object? get htmlUrl => getattr('html_url');
  Object? get id => getattr('id');
  Object? get label => getattr('label');
  Object? get type => getattr('type');

  /// only included if true
  Object? get hidden => getattr('hidden');

  /// possible values are: public, members, admins, and none
  Object? get visibility => getattr('visibility');

  /// 1 based
  Object? get position => getattr('position');
}

/// List available tabs for a course or group
///
/// `GET /api/v1/accounts/:account_id/tabs`
///
/// `GET /api/v1/courses/:course_id/tabs`
///
/// `GET /api/v1/groups/:group_id/tabs`
///
/// `GET /api/v1/users/:user_id/tabs`
///
/// Returns a paginated list of navigation tabs available in the current context.
///
/// https://canvas.instructure.com/doc/api/tabs.html#method.tabs.index
///
/// NTU COOL does not seem to support pagination.
Pagination<Tab> getAvailableTabs(
  Session session,
  Uri baseUrl, {
  required String context,
  required Object contextId,
  Object? include,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['accounts', 'courses', 'groups', 'users']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/tabs';
  var p = [
    ['include', include],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => Tab(attributes: value, session: session, baseUrl: baseUrl);
  return Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}
