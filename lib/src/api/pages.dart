import '../http/http.dart' as http;
import '../objects.dart' as objects;
import '../utils.dart' as utils;
import 'paginations.dart' as paginations;

/// https://canvas.instructure.com/doc/api/pages.html#Page
class Page extends objects.Base {
  Page({Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  @override
  final List<String> toStringNames = const ['page_id', 'url', 'title'];

  /// the unique locator for the page
  Object? get url => getattr('url');

  /// the title of the page
  Object? get title => getattr('title');

  /// the creation date for the page
  Object? get createdAt => getattr('created_at');

  /// the date the page was last updated
  Object? get updatedAt => getattr('updated_at');

  /// (DEPRECATED) whether this page is hidden from students (note: this is always
  /// reflected as the inverse of the published value)
  Object? get hideFromStudents => getattr('hide_from_students');

  /// roles allowed to edit the page; comma-separated list comprising a combination
  /// of 'teachers', 'students', 'members', and/or 'public' if not supplied, course
  /// defaults are used
  Object? get editingRoles => getattr('editing_roles');

  /// the User who last edited the page (this may not be present if the page was
  /// imported from another system)
  Object? get lastEditedBy => getattr('last_edited_by');

  /// the page content, in HTML (present when requesting a single page; omitted
  /// when listing pages)
  Object? get body => getattr('body');

  /// whether the page is published (true) or draft state (false).
  Object? get published => getattr('published');

  /// whether this page is the front page for the wiki
  Object? get frontPage => getattr('front_page');

  /// Whether or not this is locked for the user.
  Object? get lockedForUser => getattr('locked_for_user');

  /// (Optional) Information for the user about the lock. Present when
  /// locked_for_user is true.
  Object? get lockInfo => getattr('lock_info');

  /// (Optional) An explanation of why this is locked for the user. Present when
  /// locked_for_user is true.
  Object? get lockExplanation => getattr('lock_explanation');
  Object? get pageId => getattr('page_id');
  Object? get htmlUrl => getattr('html_url');
  Object? get todoDate => getattr('page_id');
}

/// https://canvas.instructure.com/doc/api/pages.html#PageRevision
class PageRevision extends objects.Base {
  PageRevision(
      {Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  @override
  final List<String> toStringNames = const ['revision_id', 'url', 'title'];

  /// an identifier for this revision of the page
  Object? get revisionId => getattr('revision_id');

  /// the time when this revision was saved
  Object? get updatedAt => getattr('updated_at');

  /// whether this is the latest revision or not
  Object? get latest => getattr('latest');

  /// the User who saved this revision, if applicable (this may not be present if
  /// the page was imported from another system)
  Object? get editedBy => getattr('edited_by');

  /// the following fields are not included in the index action and may be omitted
  /// from the show action via summary=1 the historic url of the page
  Object? get url => getattr('url');

  /// the historic page title
  Object? get title => getattr('title');

  /// the historic page contents
  Object? get body => getattr('body');
}

/// Show front page
///
/// `GET /api/v1/courses/:course_id/front_page`
///
/// `GET /api/v1/groups/:group_id/front_page`
///
/// Retrieve the content of the front page
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.show_front_page
Future<Page> getFrontPage(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/front_page';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Page(attributes: data, session: session, baseUrl: baseUrl);
}

/// Duplicate page
///
/// `POST /api/v1/courses/:course_id/pages/:url/duplicate`
///
/// Duplicate a wiki page
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.duplicate
Future<Page> duplicatePage(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? url,
  Object? params,
}) async {
  var method = 'POST';
  var _url = '/api/v1/courses/$courseId/pages/$url/duplicate';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: _url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Page(attributes: data, session: session, baseUrl: baseUrl);
}

/// Update/create front page
///
/// `PUT /api/v1/courses/:course_id/front_page`
///
/// `PUT /api/v1/groups/:group_id/front_page`
///
/// Update the title or contents of the front page
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.update_front_page
Future<Page> updateFrontPage(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  Object? wikiPage,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var url = '/api/v1/$context/$contextId/front_page';
  var p = [
    ['wiki_page', wikiPage],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Page(attributes: data, session: session, baseUrl: baseUrl);
}

/// List pages
///
/// `GET /api/v1/courses/:course_id/pages`
///
/// `GET /api/v1/groups/:group_id/pages`
///
/// A paginated list of the wiki pages associated with a course or group
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.index
paginations.Pagination<Page> listPages(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  Object? sort,
  Object? order,
  Object? searchTerm,
  Object? published,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/pages';
  var p = [
    ['sort', sort],
    ['order', order],
    ['search_term', searchTerm],
    ['published', published],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => Page(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Create page
///
/// `POST /api/v1/courses/:course_id/pages`
///
/// `POST /api/v1/groups/:group_id/pages`
///
/// Create a new wiki page
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.create
Future<Page> createPage(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  Object? wikiPage,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var url = '/api/v1/$context/$contextId/pages';
  var p = [
    ['wiki_page', wikiPage],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Page(attributes: data, session: session, baseUrl: baseUrl);
}

/// Show page
///
/// `GET /api/v1/courses/:course_id/pages/:url`
///
/// `GET /api/v1/groups/:group_id/pages/:url`
///
/// Retrieve the content of a wiki page
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.show
Future<Page> getPage(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? url,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var _url = '/api/v1/$context/$contextId/pages/$url';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: _url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Page(attributes: data, session: session, baseUrl: baseUrl);
}

/// Update/create page
///
/// `PUT /api/v1/courses/:course_id/pages/:url`
///
/// `PUT /api/v1/groups/:group_id/pages/:url`
///
/// Update the title or contents of a wiki page
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.update
Future<Page> updatePage(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? url,
  Object? wikiPage,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'PUT';
  var _url = '/api/v1/$context/$contextId/pages/$url';
  var p = [
    ['wiki_page', wikiPage],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: _url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Page(attributes: data, session: session, baseUrl: baseUrl);
}

/// Delete page
///
/// `DELETE /api/v1/courses/:course_id/pages/:url`
///
/// `DELETE /api/v1/groups/:group_id/pages/:url`
///
/// Delete a wiki page
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.destroy
Future<Page> deletePage(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? url,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'DELETE';
  var _url = '/api/v1/$context/$contextId/pages/$url';
  var p = [];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: _url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return Page(attributes: data, session: session, baseUrl: baseUrl);
}

/// List revisions
///
/// `GET /api/v1/courses/:course_id/pages/:url/revisions`
///
/// `GET /api/v1/groups/:group_id/pages/:url/revisions`
///
/// A paginated list of the revisions of a page. Callers must have update rights on the page in order to see page history.
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.revisions
paginations.Pagination<PageRevision> listRevisions(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? url,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var _url = '/api/v1/$context/$contextId/pages/$url/revisions';
  var p = [
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor = (value) =>
      PageRevision(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: _url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Show revision
///
/// `GET /api/v1/courses/:course_id/pages/:url/revisions/latest`
///
/// `GET /api/v1/groups/:group_id/pages/:url/revisions/latest`
///
/// `GET /api/v1/courses/:course_id/pages/:url/revisions/:revision_id`
///
/// `GET /api/v1/groups/:group_id/pages/:url/revisions/:revision_id`
///
/// Retrieve the metadata and optionally content of a revision of the page. Note that retrieving historic versions of pages requires edit rights.
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.show_revision
Future<PageRevision> getRevision(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? url,
  required Object? revisionId,
  Object? summary,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var _url = '/api/v1/$context/$contextId/pages/$url/revisions/$revisionId';
  var p = [
    ['summary', summary],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: _url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return PageRevision(attributes: data, session: session, baseUrl: baseUrl);
}

/// Revert to revision
///
/// `POST /api/v1/courses/:course_id/pages/:url/revisions/:revision_id`
///
/// `POST /api/v1/groups/:group_id/pages/:url/revisions/:revision_id`
///
/// Revert a page to a prior revision.
///
/// https://canvas.instructure.com/doc/api/pages.html#method.wiki_pages_api.revert
Future<PageRevision> revertToRevision(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  required Object? url,
  required Object? revisionId,
  Object? params,
}) async {
  if (!(const ['courses', 'groups']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'POST';
  var _url = '/api/v1/$context/$contextId/pages/$url/revisions/$revisionId';
  var p = [
    ['revision_id', revisionId],
  ];
  var paramsList = [p, params];
  var tmp = await utils.requestJson(
    session,
    method,
    baseUrl,
    reference: _url,
    paramsList: paramsList,
  );
  var data = tmp.item1;
  return PageRevision(attributes: data, session: session, baseUrl: baseUrl);
}
