import '../http/http.dart' show Session;
import '../objects.dart' show Simple;
import '../utils.dart' show requestJson;

/// https://github.com/instructure/canvas-lms/blob/master/app/presenters/course_for_menu_presenter.rb
class DashboardCard extends Simple {
  DashboardCard({Map<String, dynamic>? attributes})
      : super(attributes: attributes);

  final List<String> toStringNames = const ['assetString'];

  Object? get longName => getattr('longName');
  Object? get shortName => getattr('shortName');
  Object? get originalName => getattr('originalName');
  Object? get courseCode => getattr('courseCode');
  Object? get assetString => getattr('assetString');
  Object? get href => getattr('href');
  Object? get term => getattr('term');
  Object? get subtitle => getattr('subtitle');
  Object? get enrollmentType => getattr('enrollmentType');
  Object? get observee => getattr('observee');
  Object? get id => getattr('id');
  Object? get isFavorited => getattr('isFavorited');
  Object? get image => getattr('image');
  Object? get position => getattr('position');
  Object? get links => getattr('links');
}

Future<List<DashboardCard>> getDashboardCards(Session session, Uri baseUrl,
    {Object? params}) async {
  var method = 'GET';
  var url = '/api/v1/dashboard/dashboard_cards';
  var paramsList = [params];
  var tmp = await requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = [for (var value in tmp.item1) DashboardCard(attributes: value)];
  return data;
}
