import '../http/http.dart' show Session;
import '../utils.dart' show requestJson;
import 'common.dart' show Course, User;
import 'paginations.dart' show Pagination;

export 'common.dart' show Course, Term;

/// List your courses
///
/// `GET /api/v1/courses`
///
/// Returns the paginated list of active courses for the current user.
///
/// https://canvas.instructure.com/doc/api/courses.html#method.courses.index
Pagination<Course> listCourses(
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
  var constructor =
      (value) => Course(attributes: value, session: session, baseUrl: baseUrl);
  return Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// List users in course
///
/// `GET /api/v1/courses/:course_id/users`
///
/// `GET /api/v1/courses/:course_id/search_users`
///
/// Returns the paginated list of users in this course. And optionally the user's enrollments in the course.
///
/// https://canvas.instructure.com/doc/api/courses.html#method.courses.users
///
/// sort=last_login may return the following error.
///
/// {'errors': [{'message': 'An error occurred.', 'error_code': 'internal_server_error'}], 'error_report_id': error_report_id}
///
/// This may happen because of the lack of 'View usage reports' permission and the server handled it incorrectly.
///
/// See: https://canvas.instructure.com/doc/api/courses.html#method.courses.recent_students
Pagination<User> listUsersInCourse(
  Session session,
  Uri baseUrl, {
  required Object? courseId,
  String endpoint = 'users',
  Object? searchTerm,
  Object? sort,
  Object? enrollmentType,
  Object? enrollmentRole,
  Object? enrollmentRoleId,
  Object? include,
  Object? userId,
  Object? userIds,
  Object? enrollmentState,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['users', 'search_users']).contains(endpoint)) {
    throw ArgumentError.value(endpoint, 'endpoint');
  }
  var method = 'GET';
  var url = '/api/v1/courses/$courseId/$endpoint';
  var p = [
    ['search_term', searchTerm],
    ['sort', sort],
    ['enrollment_type', enrollmentType],
    ['enrollment_role', enrollmentRole],
    ['enrollment_role_id', enrollmentRoleId],
    ['include', include],
    ['user_id', userId],
    ['user_ids', userIds],
    ['enrollment_state', enrollmentState],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => User(attributes: value, session: session, baseUrl: baseUrl);
  return Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
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
  required Object? id,
  Object? accountId,
  Object? include,
  Object? teacherLimit,
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
