import '../http/http.dart' as http;
import '../objects.dart' as objects;
import 'paginations.dart' as paginations;

/// https://canvas.instructure.com/doc/api/files.html#File
class File extends objects.Base {
  File({Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['id', 'display_name'];

  Object? get id => getattr('id');
  Object? get uuid => getattr('uuid');
  Object? get folderId => getattr('folder_id');
  Object? get displayName => getattr('display_name');
  Object? get filename => getattr('filename');
  Object? get contentType => getattr('content-type');
  Object? get url => getattr('url');

  /// file size in bytes
  Object? get size => getattr('size');
  Object? get createdAt => getattr('created_at');
  Object? get updatedAt => getattr('updated_at');
  Object? get unlockAt => getattr('unlock_at');
  Object? get locked => getattr('locked');
  Object? get hidden => getattr('hidden');
  Object? get lockAt => getattr('lock_at');
  Object? get hiddenForUser => getattr('hidden_for_user');
  Object? get thumbnailUrl => getattr('thumbnail_url');
  Object? get modifiedAt => getattr('modified_at');

  /// simplified content-type mapping
  Object? get mimeClass => getattr('mime_class');

  /// identifier for file in third-party transcoding service
  Object? get mediaEntryId => getattr('media_entry_id');
  Object? get lockedForUser => getattr('locked_for_user');
  Object? get lockInfo => getattr('lock_info');
  Object? get lockExplanation => getattr('lock_explanation');

  /// optional: url to the document preview. This url is specific to the user
  /// making the api call. Only included in submission endpoints.
  Object? get previewUrl => getattr('preview_url');
}

/// List files
///
/// `GET /api/v1/courses/:course_id/files`
///
/// `GET /api/v1/users/:user_id/files`
///
/// `GET /api/v1/groups/:group_id/files`
///
/// `GET /api/v1/folders/:id/files`
///
/// Returns the paginated list of files for the folder or course.
///
/// https://canvas.instructure.com/doc/api/files.html#method.files.api_index
paginations.Pagination<File> listFiles(
  http.Session session,
  Uri baseUrl, {
  required String context,
  required Object? contextId,
  Object? contentTypes,
  Object? excludeContentTypes,
  Object? searchTerm,
  Object? include,
  Object? only,
  Object? sort,
  Object? order,
  Object? page,
  int? perPage,
  Object? params,
}) {
  if (!(const ['courses', 'users', 'groups', 'folders']).contains(context)) {
    throw ArgumentError.value(context, 'context');
  }
  var method = 'GET';
  var url = '/api/v1/$context/$contextId/files';
  var p = [
    ['content_types', contentTypes],
    ['exclude_content_types', excludeContentTypes],
    ['search_term', searchTerm],
    ['include', include],
    ['only', only],
    ['sort', sort],
    ['order', order],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => File(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}
