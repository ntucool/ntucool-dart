import '../http/http.dart' show Session;
import '../utils.dart' show requestJson;
import 'common.dart' show Course;
import 'paginations.dart' show Pagination;

export 'common.dart' show Course, Term;

/// List your courses
///
/// `GET /api/v1/courses`
///
/// Returns the paginated list of active courses for the current user.
///
/// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
Pagination<Course> getCourses(
  Session session,
  Uri baseUrl, {
  Object? enrollmentType,
  Object? enrollmentRole,
  Object? enrollmentRoleId,
  Object? enrollmentState,
  Object? excludeBlueprintCourses,
  Object? include,
  Object? state,
  Object? page,
  int? perPage,
  Object? params,
}) {
  var method = 'GET';
  var url = '/api/v1/courses';
  var p = [
    ['enrollment_type', enrollmentType],
    ['enrollment_role', enrollmentRole],
    ['enrollment_role_id', enrollmentRoleId],
    ['enrollment_state', enrollmentState],
    ['exclude_blueprint_courses', excludeBlueprintCourses],
    ['include', include],
    ['state', state],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  return Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: (value) =>
        Course(attributes: value, session: session, baseUrl: baseUrl),
  );
}

/// Get a single course
///
/// `GET /api/v1/courses/:id`
///
/// `GET /api/v1/accounts/:account_id/courses/:id`
///
/// Return information on a single course.
///
/// Accepts the same include[] parameters as the list action plus:
///
/// https://canvas.instructure.com/doc/api/courses.html#method.courses.show
Future<Course> getCourse(
  Session session,
  Uri baseUrl, {
  required Object id,
  Object? accountId,
  Object? include,
  int? teacherLimit,
  Object? params,
}) async {
  var method = 'GET';
  String url;
  if (accountId == null) {
    url = '/api/v1/courses/$id';
  } else {
    url = '/api/v1/accounts/$accountId/courses/$id';
  }
  var p = [
    ['include', include],
    ['teacher_limit', teacherLimit],
  ];
  var paramsList = [p, params];
  var tmp = await requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Course(attributes: data, session: session, baseUrl: baseUrl);
}
