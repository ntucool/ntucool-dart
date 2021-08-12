import '../http/http.dart' show Session;
import '../utils.dart';
import 'common.dart' show User;
import 'paginations.dart' show Pagination;

export 'common.dart' show User;

/// Get custom colors
///
/// `GET /api/v1/users/:id/colors`
///
/// Returns all custom colors that have been saved for a user.
///
/// https://canvas.instructure.com/doc/api/users.html#method.users.get_custom_colors
Future getCustomColors(
  Session session,
  Uri baseUrl, {
  required Object? id,
  Object? params,
}) async {
  var method = 'GET';
  var url = '/api/v1/users/$id/colors';
  var paramsList = [params];
  var tmp = await requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return data;
}
