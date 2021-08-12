import '../http/http.dart' show Session;
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
