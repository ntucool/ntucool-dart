import '../http/http.dart' show Session;
import '../objects.dart' show Base;
import '../utils.dart' show requestJson;
import 'paginations.dart' show Pagination;

/// https://canvas.instructure.com/doc/api/roles.html#Role
class Role extends Base {
  Role({Map<String, dynamic>? attributes, Session? session, Uri? baseUrl})
      : super(attributes: attributes, session: session, baseUrl: baseUrl);

  final List<String> toStringNames = const ['label'];

  /// The label of the role.
  Object? get label => getattr('label');

  /// The label of the role. (Deprecated alias for 'label')
  Object? get role => getattr('role');

  /// The role type that is being used as a base for this role. For account-level
  /// roles, this is 'AccountMembership'. For course-level roles, it is an
  /// enrollment type.
  Object? get baseRoleType => getattr('base_role_type');

  /// JSON representation of the account the role is in.
  Object? get account => getattr('account');

  /// The state of the role: 'active', 'inactive', or 'built_in'
  Object? get workflowState => getattr('workflow_state');

  /// A dictionary of permissions keyed by name (see permissions input parameter in
  /// the 'Create a role' API).
  Object? get permissions => getattr('permissions');
}

/// List roles
///
/// `GET /api/v1/accounts/:account_id/roles`
///
/// A paginated list of the roles available to an account.
///
/// https://canvas.instructure.com/doc/api/roles.html#method.role_overrides.api_index
Pagination<Role> listRoles(
  Session session,
  Uri baseUrl, {
  required Object? accountId,
  Object? state,
  Object? showInherited,
  Object? page,
  int? perPage,
  Object? params,
}) {
  var method = 'GET';
  var url = '/api/v1/accounts/$accountId/roles';
  var p = [
    ['state', state],
    ['show_inherited', showInherited],
    ['page', page],
    ['per_page', perPage],
  ];
  var paramsList = [p, params];
  var constructor =
      (value) => Role(attributes: value, session: session, baseUrl: baseUrl);
  return Pagination(
    session,
    method,
    baseUrl,
    reference: url,
    paramsList: paramsList,
    constructor: constructor,
  );
}

/// Get a single role
///
/// `GET /api/v1/accounts/:account_id/roles/:id`
///
/// Retrieve information about a single role
///
/// https://canvas.instructure.com/doc/api/roles.html#method.role_overrides.show
Future<Role> getRole(
  Session session,
  Uri baseUrl, {
  required Object? accountId,
  required Object? id,
  Object? role,
  Object? params,
}) async {
  var method = 'GET';
  var url = '/api/v1/accounts/$accountId/roles/$id';
  var p = [
    ['role', role],
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
  return Role(attributes: data, session: session, baseUrl: baseUrl);
}
