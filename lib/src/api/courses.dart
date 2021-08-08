import '../http/http.dart' show Session;
import 'common.dart' show Course;
import 'paginations.dart' show Pagination;

export 'common.dart' show Course;

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
  Object? enrollmentRoleId,
  Object? enrollmentState,
  Object? excludeBlueprintCourses,
  Object? include,
  Object? state,
  int? perPage,
  Object? page,
  Object? params,
}) {
  var method = 'GET';
  var url = '/api/v1/courses';
  var paramsList = [params];
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
