import '../http/http.dart' as http;
import '../objects.dart' as objects;
import '../utils.dart' as utils;
import 'paginations.dart' as paginations;

/// https://canvas.instructure.com/doc/api/modules.html#Module
class Module extends objects.Base {
  Module(
      {Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  @override
  final List<String> toStringNames = const ['id', 'name'];

  /// the unique identifier for the module
  Object? get id => getattr('id');

  /// the state of the module: 'active', 'deleted'
  Object? get workflowState => getattr('workflow_state');

  /// the position of this module in the course (1-based)
  Object? get position => getattr('position');

  /// the name of this module
  Object? get name => getattr('name');

  /// (Optional) the date this module will unlock
  Object? get unlockAt => getattr('unlock_at');

  /// Whether module items must be unlocked in order
  Object? get requireSequentialProgress =>
      getattr('require_sequential_progress');

  /// IDs of Modules that must be completed before this one is unlocked
  Object? get prerequisiteModuleIds => getattr('prerequisite_module_ids');

  /// The number of items in the module
  Object? get itemsCount => getattr('items_count');

  /// The API URL to retrive this module's items
  Object? get itemsUrl => getattr('items_url');

  /// The contents of this module, as an array of Module Items. (Present only if
  /// requested via include[]=items AND the module is not deemed too large by
  /// Canvas.)
  Object? get items => getattr(
        'items',
        constructor: (data) =>
            ModuleItem(attributes: data, session: session, baseUrl: baseUrl),
        isList: true,
      );

  /// The state of this Module for the calling user one of 'locked', 'unlocked',
  /// 'started', 'completed' (Optional; present only if the caller is a student or
  /// if the optional parameter 'student_id' is included)
  Object? get state => getattr('state');

  /// the date the calling user completed the module (Optional; present only if the
  /// caller is a student or if the optional parameter 'student_id' is included)
  Object? get completedAt => getattr('completed_at');

  /// if the student's final grade for the course should be published to the SIS
  /// upon completion of this module
  Object? get publishFinalGrade => getattr('publish_final_grade');

  /// (Optional) Whether this module is published. This field is present only if
  /// the caller has permission to view unpublished modules.
  Object? get published => getattr('published');
}

/// https://canvas.instructure.com/doc/api/modules.html#CompletionRequirement
class CompletionRequirement extends objects.Simple {
  CompletionRequirement({Map<String, dynamic>? attributes})
      : super(attributes: attributes);

  @override
  final List<String> toStringNames = const ['type'];

  /// one of 'must_view', 'must_submit', 'must_contribute', 'min_score',
  /// 'must_mark_done'
  Object? get type => getattr('type');

  /// minimum score required to complete (only present when type == 'min_score')
  Object? get minScore => getattr('min_score');

  /// whether the calling user has met this requirement (Optional; present only if
  /// the caller is a student or if the optional parameter 'student_id' is
  /// included)
  Object? get completed => getattr('completed');
}

/// https://canvas.instructure.com/doc/api/modules.html#ContentDetails
class ContentDetails extends objects.Simple {
  ContentDetails({Map<String, dynamic>? attributes})
      : super(attributes: attributes);

  Object? get pointsPossible => getattr('points_possible');
  Object? get dueAt => getattr('due_at');
  Object? get unlockAt => getattr('unlock_at');
  Object? get lockAt => getattr('lock_at');
  Object? get lockedForUser => getattr('locked_for_user');
  Object? get lockExplanation => getattr('lock_explanation');
  Object? get lockInfo => getattr('lock_info');
  Object? get hidden => getattr('hidden');
  Object? get displayName => getattr('display_name');
  Object? get thumbnailUrl => getattr('thumbnail_url');
  Object? get locked => getattr('locked');
}

/// https://canvas.instructure.com/doc/api/modules.html#ModuleItem
class ModuleItem extends objects.Base {
  ModuleItem(
      {Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  @override
  final List<String> toStringNames = const ['id', 'title'];

  /// the unique identifier for the module item
  Object? get id => getattr('id');

  /// the id of the Module this item appears in
  Object? get moduleId => getattr('module_id');

  /// the position of this item in the module (1-based)
  Object? get position => getattr('position');

  /// the title of this item
  Object? get title => getattr('title');

  /// 0-based indent level; module items may be indented to show a hierarchy
  Object? get indent => getattr('indent');

  /// the type of object referred to one of 'File', 'Page', 'Discussion',
  /// 'Assignment', 'Quiz', 'SubHeader', 'ExternalUrl', 'ExternalTool'
  Object? get type => getattr('type');

  /// the id of the object referred to applies to 'File', 'Discussion',
  /// 'Assignment', 'Quiz', 'ExternalTool' types
  Object? get contentId => getattr('content_id');

  /// link to the item in Canvas
  Object? get htmlUrl => getattr('html_url');

  /// (Optional) link to the Canvas API object, if applicable
  Object? get url => getattr('url');

  /// (only for 'Page' type) unique locator for the linked wiki page
  Object? get pageUrl => getattr('page_url');

  /// (only for 'ExternalUrl' and 'ExternalTool' types) external url that the item
  /// points to
  Object? get externalUrl => getattr('external_url');

  /// (only for 'ExternalTool' type) whether the external tool opens in a new tab
  Object? get newTab => getattr('new_tab');

  /// Completion requirement for this module item
  Object? get completionRequirement => getattr(
        'completion_requirement',
        constructor: (data) => CompletionRequirement(attributes: data),
      );

  /// (Present only if requested through include[]=content_details) If applicable,
  /// returns additional details specific to the associated object
  Object? get contentDetails => getattr(
        'content_details',
        constructor: (data) => ContentDetails(attributes: data),
      );

  /// (Optional) Whether this module item is published. This field is present only
  /// if the caller has permission to view unpublished items.
  Object? get published => getattr('published');
}

/// https://canvas.instructure.com/doc/api/modules.html#ModuleItemSequenceNode
class ModuleItemSequenceNode extends objects.Base {
  ModuleItemSequenceNode(
      {Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  /// The previous ModuleItem in the sequence
  Object? get prev => getattr(
        'prev',
        constructor: (data) =>
            ModuleItem(attributes: data, session: session, baseUrl: baseUrl),
      );

  /// The ModuleItem being queried
  Object? get current => getattr(
        'current',
        constructor: (data) =>
            ModuleItem(attributes: data, session: session, baseUrl: baseUrl),
      );

  /// The next ModuleItem in the sequence
  Object? get next => getattr(
        'next',
        constructor: (data) =>
            ModuleItem(attributes: data, session: session, baseUrl: baseUrl),
      );

  /// The conditional release rule for the module item, if applicable
  Object? get masteryPath => getattr('mastery_path');
}

/// https://canvas.instructure.com/doc/api/modules.html#ModuleItemSequence
class ModuleItemSequence extends objects.Base {
  ModuleItemSequence(
      {Map<String, dynamic>? attributes, http.Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  /// an array containing one ModuleItemSequenceNode for each appearence of the
  /// asset in the module sequence (up to 10 total)
  Object? get items => getattr(
        'items',
        constructor: (data) => ModuleItemSequenceNode(
            attributes: data, session: session, baseUrl: baseUrl),
        isList: true,
      );

  /// an array containing each Module referenced above
  Object? get modules => getattr(
        'modules',
        constructor: (data) =>
            Module(attributes: data, session: session, baseUrl: baseUrl),
        isList: true,
      );
}

/// List modules
///
/// `GET /api/v1/courses/:course_id/modules`
///
/// A paginated list of the modules in a course
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_modules_api.index
paginations.Pagination<Module> listModules(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  Object? include,
  Object? searchTerm,
  Object? studentId,
  Object? page,
  int? perPage,
  Object? params,
}) {
  var method = 'GET';
  var url = '/api/v1/courses/$courseId/modules';
  var p = [
    ['include', include],
    ['search_term', searchTerm],
    ['student_id', studentId],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => Module(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Show module
///
/// `GET /api/v1/courses/:course_id/modules/:id`
///
/// Get information about a single module
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_modules_api.show
Future<Module> getModule(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? id,
  Object? include,
  Object? studentId,
  Object? params,
}) async {
  var method = 'GET';
  var url = '/api/v1/courses/$courseId/modules/$id';
  var p = [
    ['include', include],
    ['student_id', studentId],
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
  return Module(attributes: data, session: session, baseUrl: baseUrl);
}

/// Create a module
///
/// `POST /api/v1/courses/:course_id/modules`
///
/// Create and return a new module
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_modules_api.create
Future<Module> createModule(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  Object? module,
  Object? params,
}) async {
  var method = 'POST';
  var url = '/api/v1/courses/$courseId/modules';
  var p = [
    ['module', module],
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
  return Module(attributes: data, session: session, baseUrl: baseUrl);
}

/// Update a module
///
/// `PUT /api/v1/courses/:course_id/modules/:id`
///
/// Update and return an existing module
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_modules_api.update
Future<Module> updateModule(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? id,
  Object? module,
  Object? params,
}) async {
  var method = 'PUT';
  var url = '/api/v1/courses/$courseId/modules/$id';
  var p = [
    ['module', module],
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
  return Module(attributes: data, session: session, baseUrl: baseUrl);
}

/// Delete module
///
/// `DELETE /api/v1/courses/:course_id/modules/:id`
///
/// Delete a module
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_modules_api.destroy
Future<Module> deleteModule(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? id,
  Object? params,
}) async {
  var method = 'DELETE';
  var url = '/api/v1/courses/$courseId/modules/$id';
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
  return Module(attributes: data, session: session, baseUrl: baseUrl);
}

/// Re-lock module progressions
///
/// `PUT /api/v1/courses/:course_id/modules/:id/relock`
///
/// Resets module progressions to their default locked state and recalculates them based on the current requirements.
///
/// Adding progression requirements to an active course will not lock students out of modules they have already unlocked unless this action is called.
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_modules_api.relock
Future<Module> reLockModuleProgressions(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? id,
  Object? params,
}) async {
  var method = 'PUT';
  var url = '/api/v1/courses/$courseId/modules/$id/relock';
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
  return Module(attributes: data, session: session, baseUrl: baseUrl);
}

/// List module items
///
/// `GET /api/v1/courses/:course_id/modules/:module_id/items`
///
/// A paginated list of the items in a module
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.index
paginations.Pagination<ModuleItem> listModuleItems(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  Object? include,
  Object? searchTerm,
  Object? studentId,
  Object? page,
  int? perPage,
  Object? params,
}) {
  var method = 'GET';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items';
  var p = [
    ['include', include],
    ['search_term', searchTerm],
    ['student_id', studentId],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor = (value) =>
      ModuleItem(attributes: value, session: session, baseUrl: baseUrl);
  return paginations.Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Show module item
///
/// `GET /api/v1/courses/:course_id/modules/:module_id/items/:id`
///
/// Get information about a single module item
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.show
Future<ModuleItem> getModuleItem(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  required Object? id,
  Object? include,
  Object? studentId,
  Object? params,
}) async {
  var method = 'GET';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items/$id';
  var p = [
    ['include', include],
    ['student_id', studentId],
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
  return ModuleItem(attributes: data, session: session, baseUrl: baseUrl);
}

/// Create a module item
///
/// `POST /api/v1/courses/:course_id/modules/:module_id/items`
///
/// Create and return a new module item
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.create
Future<ModuleItem> createModuleItem(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  Object? moduleItem,
  Object? params,
}) async {
  var method = 'POST';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items';
  var p = [
    ['module_item', moduleItem],
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
  return ModuleItem(attributes: data, session: session, baseUrl: baseUrl);
}

/// Update a module item
///
/// `PUT /api/v1/courses/:course_id/modules/:module_id/items/:id`
///
/// Update and return an existing module item
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.update
Future<ModuleItem> updateModuleItem(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  required Object? id,
  Object? moduleItem,
  Object? params,
}) async {
  var method = 'PUT';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items/$id';
  var p = [
    ['module_item', moduleItem],
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
  return ModuleItem(attributes: data, session: session, baseUrl: baseUrl);
}

/// Select a mastery path
///
/// `POST /api/v1/courses/:course_id/modules/:module_id/items/:id/select_mastery_path`
///
/// Select a mastery path when module item includes several possible paths. Requires Mastery Paths feature to be enabled.  Returns a compound document with the assignments included in the given path and any module items related to those assignments
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.select_mastery_path
Future selectMasteryPath(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  required Object? id,
  Object? assignmentSetId,
  Object? studentId,
  Object? params,
}) async {
  var method = 'POST';
  var url =
      '/api/v1/courses/$courseId/modules/$moduleId/items/$id/select_mastery_path';
  var p = [
    ['assignment_set_id', assignmentSetId],
    ['student_id', studentId],
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
  return data;
}

/// Delete module item
///
/// `DELETE /api/v1/courses/:course_id/modules/:module_id/items/:id`
///
/// Delete a module item
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.destroy
Future<ModuleItem> deleteModuleItem(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  required Object? id,
  Object? params,
}) async {
  var method = 'DELETE';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items/$id';
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
  return ModuleItem(attributes: data, session: session, baseUrl: baseUrl);
}

/// Mark module item as done
///
/// `PUT /api/v1/courses/:course_id/modules/:module_id/items/:id/done`
///
/// Mark a module item as done. Use HTTP method PUT to mark as done.
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.mark_as_done
Future markModuleItemAsDone(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  required Object? id,
  Object? params,
}) async {
  var method = 'PUT';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items/$id/done';
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
  return data;
}

/// Mark module item as not done
///
/// `DELETE /api/v1/courses/:course_id/modules/:module_id/items/:id/done`
///
/// Mark a module item as not done. Use HTTP method DELETE to mark as not done.
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.mark_as_done
Future markModuleItemAsNotDone(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  required Object? id,
  Object? params,
}) async {
  var method = 'DELETE';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items/$id/done';
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
  return data;
}

/// Get module item sequence
///
/// `GET /api/v1/courses/:course_id/module_item_sequence`
///
/// Given an asset in a course, find the ModuleItem it belongs to, the previous and next Module Items in the course sequence, and also any applicable mastery path rules
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.item_sequence
Future<ModuleItemSequence> getModuleItemSequence(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  Object? assetType,
  Object? assetId,
  Object? params,
}) async {
  var method = 'GET';
  var url = '/api/v1/courses/$courseId/module_item_sequence';
  var p = [
    ['asset_type', assetType],
    ['asset_id', assetId],
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
  return ModuleItemSequence(
      attributes: data, session: session, baseUrl: baseUrl);
}

/// Mark module item read
///
/// `POST /api/v1/courses/:course_id/modules/:module_id/items/:id/mark_read`
///
/// Fulfills “must view” requirement for a module item. It is generally not necessary to do this explicitly, but it is provided for applications that need to access external content directly (bypassing the html_url redirect that normally allows Canvas to fulfill “must view” requirements).
///
/// This endpoint cannot be used to complete requirements on locked or unpublished module items.
///
/// https://canvas.instructure.com/doc/api/modules.html#method.context_module_items_api.mark_item_read
Future markModuleItemRead(
  http.Session session,
  Uri baseUrl, {
  required Object? courseId,
  required Object? moduleId,
  required Object? id,
  Object? params,
}) async {
  var method = 'POST';
  var url = '/api/v1/courses/$courseId/modules/$moduleId/items/$id/mark_read';
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
  return data;
}
